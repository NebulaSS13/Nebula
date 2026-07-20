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

	/// If a connection for z-lights exists, the corner above us.
	var/datum/lighting_corner/above_corner
	/// If a connection for z-lights exists, the corner below us.
	var/datum/lighting_corner/below_corner

	var/list/datum/light_source/affecting // Light sources affecting us.
	var/active                            = FALSE  // TRUE if one of our masters has dynamic lighting.

	var/x = 0
	var/y = 0
	var/z = 0

	// Our own intensity, from lights directly shining on us.
	var/self_r = 0
	var/self_g = 0
	var/self_b = 0

	// The intensity we're inheriting from the turfs below us, if we're a Z-turf. This is a sum of all below turfs.
	var/below_r = 0
	var/below_g = 0
	var/below_b = 0

	// Ambient turf lighting that's not inherited from a light source. These are updated as absolute values.
	var/ambient_r = 0
	var/ambient_g = 0
	var/ambient_b = 0

	// The turf above us' ambient values.
	var/above_ambient_r = 0
	var/above_ambient_g = 0
	var/above_ambient_b = 0

	// The final intensity, all things considered.
	var/apparent_r = 0
	var/apparent_g = 0
	var/apparent_b = 0

	var/needs_update = FALSE

	var/cache_r  = 0
	var/cache_g  = 0
	var/cache_b  = 0
	var/cache_mx = 0

/datum/lighting_corner/New(turf/new_turf, diagonal, oi, direction = LIGHTING_CORNER_GENERATE_BOTH)
	SSlighting.total_lighting_corners += 1

	var/has_ambience = FALSE

	t1 = new_turf.resolve_to_actual_turf()
	z = t1.z
	t1i = oi

	if (TURF_IS_AMBIENT_LIT_UNSAFE(new_turf))
		has_ambience = TRUE

	var/vertical   = diagonal & ~(diagonal - 1) // The horizontal directions (4 and 8) are bigger than the vertical ones (1 and 2), so we can reliably say the lsb is the horizontal direction.
	var/horizontal = diagonal & ~vertical       // Now that we know the horizontal one we can get the vertical one.

	x = t1.x + (horizontal == EAST  ? 0.5 : -0.5)
	y = t1.y + (vertical   == NORTH ? 0.5 : -0.5)

	// My initial plan was to make this loop through a list of all the dirs (horizontal, vertical, diagonal).
	// Issue being that the only way I could think of doing it was very messy, slow and honestly overengineered.
	// So we'll have this hardcode instead.
	var/turf/T
	// This is to resolve the proper diagonal direction relative to the corner position for mimiced turfs.
	var/Tc


	// Diagonal one is easy.
	T = get_step_resolving_mimic(t1, diagonal)
	if (T) // In case we're on the map's border.
		if (!T.corners)
			T.corners = new(4)

		t2 = T
		t2i = REVERSE_LIGHTING_CORNER_DIAGONAL[diagonal]
		T.corners[t2i] = src
		if (TURF_IS_AMBIENT_LIT_UNSAFE(T))
			has_ambience = TRUE

	// Now the horizontal one.
	T = get_step_resolving_mimic(t1, horizontal)
	Tc = t1.x + (horizontal == EAST  ? 1 : -1)
	if (T) // Ditto.
		if (!T.corners)
			T.corners = new(4)

		t3 = T
		t3i = REVERSE_LIGHTING_CORNER_DIAGONAL[((Tc > x) ? EAST : WEST) | ((t1.y > y) ? NORTH : SOUTH)] // Get the dir based on coordinates.
		T.corners[t3i] = src
		if (TURF_IS_AMBIENT_LIT_UNSAFE(T))
			has_ambience = TRUE

	// And finally the vertical one.
	T = get_step_resolving_mimic(t1, vertical)
	Tc = t1.y + (vertical   == NORTH ? 1 : -1)
	if (T)
		if (!T.corners)
			T.corners = new(4)

		t4 = T
		t4i = REVERSE_LIGHTING_CORNER_DIAGONAL[((t1.x > x) ? EAST : WEST) | ((Tc > y) ? NORTH : SOUTH)] // Get the dir based on coordinates.
		T.corners[t4i] = src
		if (TURF_IS_AMBIENT_LIT_UNSAFE(T))
			has_ambience = TRUE

	if (has_ambience)
		init_ambient()
	generate_z_connections(direction)
	update_active()

#define OVERLAY_PRESENT(T) (T && T.lighting_overlay)

/datum/lighting_corner/proc/update_active()
	active = FALSE

	if (OVERLAY_PRESENT(t1) || OVERLAY_PRESENT(t2) || OVERLAY_PRESENT(t3) || OVERLAY_PRESENT(t4))
		active = TRUE

#undef OVERLAY_PRESENT

#define GET_ABOVE(T) (HasAbove(T:z) ? get_step(T, UP) : null)
#define GET_BELOW(T) (HasBelow(T:z) ? get_step(T, DOWN) : null)

#define UPDATE_APPARENT(T, CH) T.apparent_##CH = T.self_##CH + T.below_##CH + T.ambient_##CH + T.above_ambient_##CH

// Configure ambient lighting for *just* this corner. This deliberately does not handle Z-propagation, that's managed by generate_z_connections().
/datum/lighting_corner/proc/init_ambient()
	var/sum_r = 0
	var/sum_g = 0
	var/sum_b = 0

	var/turf/T
	for (var/i in 1 to 4)
		// this is ugly as fuck, but it's still more legible than doing this with a macro
		switch (i)
			if (1) T = t1
			if (2) T = t2
			if (3) T = t3
			if (4) T = t4

		if (!T || !T.ambient_light)
			continue

		var/list/parts = rgb2num(T.ambient_light)

		sum_r += (parts[1] / 255) * T.ambient_light_multiplier
		sum_g += (parts[2] / 255) * T.ambient_light_multiplier
		sum_b += (parts[3] / 255) * T.ambient_light_multiplier

	sum_r /= 4
	sum_g /= 4
	sum_b /= 4

	ambient_r += sum_r
	ambient_g += sum_g
	ambient_b += sum_b

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	if (!needs_update)
		needs_update = TRUE
		SSlighting.corner_queue += src

/datum/lighting_corner/proc/generate_z_connections(direction = LIGHTING_CORNER_GENERATE_BOTH)
	ASSERT(z != null)
	/*
		ZM_ALLOW_LIGHTING means that a z-turf is lighting-connected to the turf below it.
		So:
			Upward: check if above and above is ALLOW_LIGHTING
			Downward: check if self is ALLOW_LIGHTING and below

		This corner will be shared by all four of its turfs, so it doesn't matter which condition passes.
		The above/below corners should be created if the master has a Z-connection and is ALLOW_LIGHTING, regardless of if it's actually dynamic. This allows light to shine
			through Z-turfs that are themselves not dynamic.
	*/

	// BOTH is 0, so it's true for both conditions.
	// Sometimes we need to only generate going upwards (or downwards); if this corner was created by another corner using this proc, then generating downward is invalid and causes infinite recursion.
	// We still need to scan downward (or upward) to find the new connection in this case though.
	#define GOING_UP (direction > LIGHTING_CORNER_GENERATE_DOWN)
	#define GOING_DOWN (direction < LIGHTING_CORNER_GENERATE_UP)

	var/turf/T

	var/datum/lighting_corner/old_above_corner = above_corner
	var/datum/lighting_corner/old_below_corner = below_corner

	/*
		This brick is responsible for finding the corner that's directly above us, and forcibly generating the corner if it doesn't exist yet.
		It's just the same block of code repeated four times (for each master), plus the case of there now being no above corner, but previously having had one.
		We also only initialize the one corner we need rather than all four since there's no benefit to initializing them all -- if a true light needs them, it'll make them itself.

		Nebula specific: due to lighting on edges of z-levels wrapping around, this logic needs to exclude masters that are on a different Z-level.
			This logic assumes that all (up to) four masters of this corner are equivalent, but this is not true of corners found via z-level transition boundaries.
			Turfs with transition corners should have at least one non-transition corner, so we just ignore them.
	*/
	if      (t1?.z == z && (T = t1.above || GET_ABOVE(t1)) && (T.z_flags & ZM_ALLOW_LIGHTING))
		if (!(above_corner = T.corners?[t1i]) && GOING_UP)
			if (!T.corners)
				T.corners = new(4)
			T.corners[t1i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[t1i], t1i, LIGHTING_CORNER_GENERATE_UP)
			above_corner = T.corners[t1i]
	else if (t2?.z == z && (T = t2.above || GET_ABOVE(t2)) && (T.z_flags & ZM_ALLOW_LIGHTING))
		if (!(above_corner = T.corners?[t2i]) && GOING_UP)
			if (!T.corners)
				T.corners = new(4)
			T.corners[t2i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[t2i], t2i, LIGHTING_CORNER_GENERATE_UP)
			above_corner = T.corners[t2i]
	else if (t3?.z == z && (T = t3.above || GET_ABOVE(t3)) && (T.z_flags & ZM_ALLOW_LIGHTING))
		if (!(above_corner = T.corners?[t3i]) && GOING_UP)
			if (!T.corners)
				T.corners = new(4)
			T.corners[t3i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[t3i], t3i, LIGHTING_CORNER_GENERATE_UP)
			above_corner = T.corners[t3i]
	else if (t4?.z == z && (T = t4.above || GET_ABOVE(t4)) && (T.z_flags & ZM_ALLOW_LIGHTING))
		if (!(above_corner = T.corners?[t4i]) && GOING_UP)
			if (!T.corners)
				T.corners = new(4)
			T.corners[t4i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[t4i], t4i, LIGHTING_CORNER_GENERATE_UP)
			above_corner = T.corners[t4i]
	else if (above_corner)	// connected -> disconnected transition
		/*
			The corner directly above us contains the sum of the light that comes from us and everything below us, which is conveniently everything that we need to remove.
			We iterate up through the stack removing only the above_corner's light contribution, as to not disturb light sourced from other turfs higher in the stack.
		*/
		for (var/datum/lighting_corner/corn = above_corner; corn; corn = corn.above_corner)
			corn.below_r -= above_corner.below_r
			corn.below_g -= above_corner.below_g
			corn.below_b -= above_corner.below_b

			UPDATE_APPARENT(corn, r)
			UPDATE_APPARENT(corn, g)
			UPDATE_APPARENT(corn, b)

			if (!corn.needs_update)
				corn.needs_update = TRUE
				SSlighting.corner_queue += corn

		above_corner.below_corner = null
		above_corner = null

	if (!old_above_corner && above_corner)	// disconnected -> connected transition
		if (!(apparent_r == apparent_g == apparent_b == 0))
			for (var/datum/lighting_corner/corn = above_corner; corn; corn = corn.above_corner)
				// We can't just steal the precomputed value from the above like we can in the removal case: our effect on the turf above us is our own self-light plus the light below us.
				corn.below_r += src.below_r + src.self_r
				corn.below_g += src.below_g + src.self_g
				corn.below_b += src.below_b + src.self_b

				UPDATE_APPARENT(corn, r)
				UPDATE_APPARENT(corn, g)
				UPDATE_APPARENT(corn, b)

				if (!corn.needs_update)
					corn.needs_update = TRUE
					SSlighting.corner_queue += corn

	// As above, so below. The ordering here is a bit different from the above block, check the comment at the top of this proc.
	if      (t1?.z == z && (t1.z_flags & ZM_ALLOW_LIGHTING) && (T = t1.below || GET_BELOW(t1)))
		if (!(below_corner = T.corners?[t1i]) && GOING_DOWN)
			if (!T.corners)
				T.corners = new(4)
			T.corners[t1i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[t1i], t1i, LIGHTING_CORNER_GENERATE_DOWN)
			below_corner = T.corners[t1i]
	else if (t2?.z == z && (t2.z_flags & ZM_ALLOW_LIGHTING) && (T = t2.below || GET_BELOW(t2)))
		if (!(below_corner = T.corners?[t2i]) && GOING_DOWN)
			if (!T.corners)
				T.corners = new(4)
			T.corners[t2i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[t2i], t2i, LIGHTING_CORNER_GENERATE_DOWN)
			below_corner = T.corners[t2i]
	else if (t3?.z == z && (t3.z_flags & ZM_ALLOW_LIGHTING) && (T = t3.below || GET_BELOW(t3)))
		if (!(below_corner = T.corners?[t3i]) && GOING_DOWN)
			if (!T.corners)
				T.corners = new(4)
			T.corners[t3i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[t3i], t3i, LIGHTING_CORNER_GENERATE_DOWN)
			below_corner = T.corners[t3i]
	else if (t4?.z == z && (t4.z_flags & ZM_ALLOW_LIGHTING) && (T = t4.below || GET_BELOW(t4)))
		if (!(below_corner = T.corners?[t4i]) && GOING_DOWN)
			if (!T.corners)
				T.corners = new(4)
			T.corners[t4i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[t4i], t4i, LIGHTING_CORNER_GENERATE_DOWN)
			below_corner = T.corners[t4i]
	else if (below_corner)	// connected -> disconnected transition
		/*
			Similar case to above, but not quite the same.
			The corner below us' `above_ambient_*` var contins both our contributed light as well as turfs above us, so just subtract that instead of combining both vars manually.
		*/
		for (var/datum/lighting_corner/corn = below_corner; corn; corn = corn.below_corner)
			corn.above_ambient_r -= below_corner.above_ambient_r
			corn.above_ambient_g -= below_corner.above_ambient_g
			corn.above_ambient_b -= below_corner.above_ambient_b

			UPDATE_APPARENT(corn, r)
			UPDATE_APPARENT(corn, g)
			UPDATE_APPARENT(corn, b)

			if (!corn.needs_update)
				corn.needs_update = TRUE
				SSlighting.corner_queue += corn

		below_corner.above_corner = null
		below_corner = null

	if (!old_below_corner && below_corner)	// disconnected -> connected transition
		// quick and dirty heuristic to avoid checking a bunch of different vars, it's still valid if we needlessly run this
		if (!(apparent_r == apparent_g == apparent_b == 0))
			for (var/datum/lighting_corner/corn = below_corner; corn; corn = corn.below_corner)
				// As with above, we can't just steal the precomputed value from our neighbor. Our effect will be the sum effect of turfs above us, plus our effect.
				corn.above_ambient_r += src.above_ambient_r + src.ambient_r
				corn.above_ambient_g += src.above_ambient_g + src.ambient_g
				corn.above_ambient_b += src.above_ambient_b + src.ambient_b

				UPDATE_APPARENT(corn, r)
				UPDATE_APPARENT(corn, g)
				UPDATE_APPARENT(corn, b)

				if (!corn.needs_update)
					corn.needs_update = TRUE
					SSlighting.corner_queue += corn

	if (above_corner)
		ASSERT(x == above_corner.x)
		ASSERT(y == above_corner.y)
		ASSERT(z == above_corner.z - 1)

	if (below_corner)
		ASSERT(x == below_corner.x)
		ASSERT(y == below_corner.y)
		ASSERT(z == below_corner.z + 1)

#undef GOING_UP
#undef GOING_DOWN

// God that was a mess, now to do the rest of the corner code! Hooray!
/datum/lighting_corner/proc/update_lumcount(delta_r, delta_g, delta_b, now = FALSE)
	if (!(delta_r + delta_g + delta_b))
		return

	self_r += delta_r
	self_g += delta_g
	self_b += delta_b

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	for (var/datum/lighting_corner/corn = above_corner; corn; corn = corn.above_corner)
		corn.below_r += delta_r
		corn.below_g += delta_g
		corn.below_b += delta_b

		UPDATE_APPARENT(corn, r)
		UPDATE_APPARENT(corn, g)
		UPDATE_APPARENT(corn, b)

		// These are always queued, players are far less likely to notice these being a little behind.
		if (!corn.needs_update)
			corn.needs_update = TRUE
			SSlighting.corner_queue += corn

	// This needs to be down here instead of the above if so the lum values are properly updated.
	if (needs_update)
		return

	if (now)
		update_overlays(TRUE)
	else
		needs_update = TRUE
		SSlighting.corner_queue += src

/datum/lighting_corner/proc/update_ambient_lumcount(delta_r, delta_g, delta_b, skip_update = FALSE)

	ambient_r += delta_r
	ambient_g += delta_g
	ambient_b += delta_b

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	for (var/datum/lighting_corner/corn = below_corner; corn; corn = corn.below_corner)
		corn.above_ambient_r += delta_r
		corn.above_ambient_g += delta_g
		corn.above_ambient_b += delta_b

		UPDATE_APPARENT(corn, r)
		UPDATE_APPARENT(corn, g)
		UPDATE_APPARENT(corn, b)

		if (!skip_update && !corn.needs_update)
			corn.needs_update = TRUE
			SSlighting.corner_queue += corn

	if (needs_update || skip_update)
		return

	// Always queue for this, not important enough to hit the synchronous path.
	needs_update = TRUE
	SSlighting.corner_queue += src

/datum/lighting_corner/proc/update_overlays(now = FALSE)
	var/lr = apparent_r
	var/lg = apparent_g
	var/lb = apparent_b

	// Cache these values ahead of time so 4 individual lighting overlays don't all calculate them individually.
	var/mx = max(lr, lg, lb) // Scale it so 1 is the strongest lum, if it is above 1.
	. = 1 // factor
	if (mx > 1)
		. = 1 / mx

	cache_r = round(lr * ., LIGHTING_ROUND_VALUE)
	cache_g = round(lg * ., LIGHTING_ROUND_VALUE)
	cache_b = round(lb * ., LIGHTING_ROUND_VALUE)

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

	SSlighting.total_lighting_corners -= 1
	return ..()

/datum/lighting_corner/dummy/New()
	return

#undef UPDATE_APPARENT
