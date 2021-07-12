var/global/datum/lighting_corner/dummy/dummy_lighting_corner = new
// Because we can control each corner of every lighting overlay.
// And corners get shared between multiple turfs (unless you're on the corners of the map, then 1 corner doesn't).
// For the record: these should never ever ever be deleted, even if the turf doesn't have dynamic lighting.

// This list is what the code that assigns corners listens to, the order in this list is the order in which corners are added to the /turf/corners list.
var/global/list/LIGHTING_CORNER_DIAGONAL = list(NORTHEAST, SOUTHEAST, SOUTHWEST, NORTHWEST)

// This is the reverse of the above - the position in the array is a dir. Update this if the above changes.
var/global/list/REVERSE_LIGHTING_CORNER_DIAGONAL = list(0, 0, 0, 0, 3, 4, 0, 0, 2, 1)

/datum/lighting_corner
	// t1 through t4 are our masters, in no particular order.
	// They are split into vars like this in the interest of reducing memory usage.
	// tX is the turf itself, tXi is the index of this corner in that turf's corners list.
	var/turf/t1
	var/t1i
	var/turf/t2
	var/t2i
	var/turf/t3
	var/t3i
	var/turf/t4
	var/t4i

	var/list/datum/light_source/affecting // Light sources affecting us.
	var/active                            = FALSE  // TRUE if one of our masters has dynamic lighting.

	var/x = 0
	var/y = 0
	var/z = 0

	// Our own intensity, from lights directly shining on us.
	var/self_r = 0
	var/self_g = 0
	var/self_b = 0

	// The intensity we're inheriting from the turf below us, if we're a Z-turf.
	var/below_r = 0
	var/below_g = 0
	var/below_b = 0

	// The final intensity, all things considered.
	var/apparent_r = 0
	var/apparent_g = 0
	var/apparent_b = 0

	var/needs_update = FALSE

	var/cache_r  = LIGHTING_SOFT_THRESHOLD
	var/cache_g  = LIGHTING_SOFT_THRESHOLD
	var/cache_b  = LIGHTING_SOFT_THRESHOLD
	var/cache_mx = 0

/datum/lighting_corner/New(turf/new_turf, diagonal, oi)
	SSlighting.lighting_corners += src

	t1 = new_turf
	z = new_turf.z
	t1i = oi

	var/vertical   = diagonal & ~(diagonal - 1) // The horizontal directions (4 and 8) are bigger than the vertical ones (1 and 2), so we can reliably say the lsb is the horizontal direction.
	var/horizontal = diagonal & ~vertical       // Now that we know the horizontal one we can get the vertical one.

	x = new_turf.x + (horizontal == EAST  ? 0.5 : -0.5)
	y = new_turf.y + (vertical   == NORTH ? 0.5 : -0.5)

	// My initial plan was to make this loop through a list of all the dirs (horizontal, vertical, diagonal).
	// Issue being that the only way I could think of doing it was very messy, slow and honestly overengineered.
	// So we'll have this hardcode instead.
	var/turf/T

	// Diagonal one is easy.
	T = get_step(new_turf, diagonal)
	if (T) // In case we're on the map's border.
		if (!T.corners)
			T.corners = new(4)

		t2 = T
		t2i = REVERSE_LIGHTING_CORNER_DIAGONAL[diagonal]
		T.corners[t2i] = src

	// Now the horizontal one.
	T = get_step(new_turf, horizontal)
	if (T) // Ditto.
		if (!T.corners)
			T.corners = new(4)

		t3 = T
		t3i = REVERSE_LIGHTING_CORNER_DIAGONAL[((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH)] // Get the dir based on coordinates.
		T.corners[t3i] = src

	// And finally the vertical one.
	T = get_step(new_turf, vertical)
	if (T)
		if (!T.corners)
			T.corners = new(4)

		t4 = T
		t4i = REVERSE_LIGHTING_CORNER_DIAGONAL[((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH)] // Get the dir based on coordinates.
		T.corners[t4i] = src

	update_active()

#define OVERLAY_PRESENT(T) (T && T.lighting_overlay)

/datum/lighting_corner/proc/update_active()
	active = FALSE

	if (OVERLAY_PRESENT(t1) || OVERLAY_PRESENT(t2) || OVERLAY_PRESENT(t3) || OVERLAY_PRESENT(t4))
		active = TRUE

#undef OVERLAY_PRESENT

#define GET_ABOVE(T) (HasAbove(T:z) ? get_step(T, UP) : null)

// God that was a mess, now to do the rest of the corner code! Hooray!
/datum/lighting_corner/proc/update_lumcount(delta_r, delta_g, delta_b, now = FALSE)
	if (!(delta_r + delta_g + delta_b))
		return

	self_r += delta_r
	self_g += delta_g
	self_b += delta_b

	apparent_r = self_r + below_r
	apparent_g = self_g + below_g
	apparent_b = self_b + below_b

	var/turf/T
	var/Ti
	// Grab the first master that's a Z-turf, if one exists.
	if (t1 && (T = GET_ABOVE(t1)) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t1i
	else if (t2 && (T = GET_ABOVE(t2)) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t2i
	else if (t3 && (T = GET_ABOVE(t3)) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t3i
	else if (t4 && (T = GET_ABOVE(t4)) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t4i
	else	// Nothing above us that cares about below light.
		T = null

	if (T)
		if (!T.corners || !T.corners[Ti])
			T.generate_missing_corners()
		var/datum/lighting_corner/above = T.corners[Ti]
		above.update_below_lumcount(delta_r, delta_g, delta_b, now)

	// This needs to be down here instead of the above if so the lum values are properly updated.
	if (needs_update)
		return

	if (!now)
		needs_update = TRUE
		SSlighting.corner_queue += src
	else
		update_overlays(TRUE)

#undef GET_ABOVE

/datum/lighting_corner/proc/update_below_lumcount(delta_r, delta_g, delta_b, now = FALSE)
	if (!(delta_r + delta_g + delta_b))
		return

	below_r += delta_r
	below_g += delta_g
	below_b += delta_b

	apparent_r = self_r + below_r
	apparent_g = self_g + below_g
	apparent_b = self_b + below_b

	// This needs to be down here instead of the above if so the lum values are properly updated.
	if (needs_update)
		return

	if (!now)
		needs_update = TRUE
		SSlighting.corner_queue += src
	else
		update_overlays(TRUE)

/datum/lighting_corner/proc/update_overlays(now = FALSE)
	var/lr = apparent_r
	var/lg = apparent_g
	var/lb = apparent_b

	// Cache these values a head of time so 4 individual lighting overlays don't all calculate them individually.
	var/mx = max(lr, lg, lb) // Scale it so 1 is the strongest lum, if it is above 1.
	. = 1 // factor
	if (mx > 1)
		. = 1 / mx

	else if (mx < LIGHTING_SOFT_THRESHOLD)
		. = 0 // 0 means soft lighting.

	if (.)
		cache_r = round(lr * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
		cache_g = round(lg * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
		cache_b = round(lb * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	else
		cache_r = cache_g = cache_b = LIGHTING_SOFT_THRESHOLD

	cache_mx = round(mx, LIGHTING_ROUND_VALUE)

	var/turf/T
	for (var/i in 1 to 4)
		// this is ugly as fuck, but it's still more legible than doing this with a macro
		switch (i)
			if (1) T = t1
			if (2) T = t2
			if (3) T = t3
			if (4) T = t4

		var/atom/movable/lighting_overlay/Ov
		if (T && (Ov = T.lighting_overlay))
			if (now)
				Ov.update_overlay()
			else if (!Ov.needs_update)
				Ov.needs_update = TRUE
				SSlighting.overlay_queue += Ov

/datum/lighting_corner/Destroy(force = FALSE)
	PRINT_STACK_TRACE("Someone [force ? "force-" : ""]deleted a lighting corner.")
	if (!force)
		return QDEL_HINT_LETMELIVE

	SSlighting.lighting_corners -= src
	return ..()

/datum/lighting_corner/dummy/New()
	return
