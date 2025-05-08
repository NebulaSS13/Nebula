/turf
	var/dynamic_lighting = TRUE
	luminosity = 1

	var/tmp/lighting_corners_initialised = FALSE

	/// List of light sources affecting this turf.
	var/tmp/list/datum/light_source/affecting_lights
	/// Our lighting overlay, used to apply multiplicative lighting to the tile and its contents.
	var/tmp/atom/movable/lighting_overlay/lighting_overlay
	var/tmp/list/datum/lighting_corner/corners
	/// Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.
	var/tmp/has_opaque_atom = FALSE

/// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.vis_update()

/// Forces a lighting update. Reconsider lights is preferred when possible.
/turf/proc/force_update_lights()
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.force_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_overlay)
		if (lighting_overlay.loc != src)
			PRINT_STACK_TRACE("Lighting overlay variable on turf [log_info_line(src)] is insane, lighting overlay actually located on [log_info_line(lighting_overlay.loc)]!")

		qdel(lighting_overlay, TRUE)
		lighting_overlay = null

	for (var/datum/lighting_corner/C in corners)
		C.update_active()

// Builds a lighting overlay for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay(now = FALSE)
	if (lighting_overlay)
		CRASH("Attempted to create lighting_overlay on tile that already had one.")

	if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
		if (!lighting_corners_initialised || !corners)
			generate_missing_corners()

		new /atom/movable/lighting_overlay(src, now)

		for (var/datum/lighting_corner/C in corners)
			if (!C.active) // We would activate the corner, calculate the lighting for it.
				for (var/L in C.affecting)
					var/datum/light_source/S = L
					S.recalc_corner(C, TRUE)

				C.active = TRUE

/// Returns the average color of this tile. Roughly corresponds to the color of a single old-style lighting overlay.
/turf/proc/get_avg_color()
	if (!lighting_overlay)
		return null

	var/lum_r
	var/lum_g
	var/lum_b

	for (var/datum/lighting_corner/L in corners)
		lum_r += L.apparent_r
		lum_g += L.apparent_g
		lum_b += L.apparent_b

	lum_r = CLAMP01(lum_r / 4) * 255
	lum_g = CLAMP01(lum_g / 4) * 255
	lum_b = CLAMP01(lum_b / 4) * 255

	return rgb(lum_r, lum_g, lum_b)

#define SCALE(targ,min,max) (targ - min) / (max - min)

/// Returns a lumcount (average intensity of color channels) scaled between minlum and maxlum.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_overlay)
		return 0.5

	var/totallums = 0
	for (var/datum/lighting_corner/L in corners)
		totallums += L.apparent_r + L.apparent_b + L.apparent_g

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = SCALE(totallums, minlum, maxlum)

	return CLAMP01(totallums)

#undef SCALE

/// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
#ifdef AO_USE_LIGHTING_OPACITY
	var/old = has_opaque_atom
#endif

	has_opaque_atom = FALSE
	if (opacity)
		has_opaque_atom = TRUE
	else
		for (var/thing in src) // Loop through every movable atom on our tile
			var/atom/movable/A = thing
			if (A.opacity)
				has_opaque_atom = TRUE
				break 	// No need to continue if we find something opaque.

#ifdef AO_USE_LIGHTING_OPACITY
	if (old != has_opaque_atom)
		regenerate_ao()
#endif

/turf/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	if (!Obj)
		return

	if (Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

// This block isn't needed now, but it's here if supporting area dyn lighting changes is needed later.

// /turf/change_area(area/old_area, area/new_area)
// 	if (new_area.dynamic_lighting != old_area.dynamic_lighting)
// 		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
// 			lighting_build_overlay()
// 		else
// 			lighting_clear_overlay()

// This is inlined in lighting_source.dm.
// Update it too if you change this.
/turf/proc/generate_missing_corners()
	if (!TURF_IS_DYNAMICALLY_LIT_UNSAFE(src) && !light_source_solo && !light_source_multi && !(z_flags & ZM_ALLOW_LIGHTING) && !ambient_light && !ambient_has_indirect)
		return

	lighting_corners_initialised = TRUE
	if (!corners)
		corners = new(4)

	for (var/i = 1 to 4)
		if (corners[i]) // Already have a corner on this direction.
			continue

		corners[i] = new/datum/lighting_corner(src, LIGHTING_CORNER_DIAGONAL[i], i)
