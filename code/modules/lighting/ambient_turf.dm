/turf
	/// If non-null, a hex RGB light color that should be applied to this turf.
	var/ambient_light
	/// The power of the above is multiplied by this. Setting too high may drown out normal lights on the same turf.
	var/ambient_light_multiplier = 0.3

	/// If this is TRUE, an above turf's ambient light is affecting this turf.
	var/tmp/ambient_has_indirect = FALSE

	// Record-keeping, do not touch -- that means you, admins.
	var/tmp/ambient_active = FALSE	//! Do we have non-zero ambient light? Use [TURF_IS_AMBIENT_LIT] instead of reading this directly.
	var/tmp/ambient_light_old_r = 0
	var/tmp/ambient_light_old_g = 0
	var/tmp/ambient_light_old_b = 0

/// Set the turf's self-ambience channel. This can only contain one value at a time, so it should generally only be used by the turf itself.
/turf/proc/set_ambient_light(color, multiplier)
	if (color == ambient_light && multiplier == ambient_light_multiplier)
		return

	ambient_light = isnull(color) ? ambient_light : color
	ambient_light_multiplier = isnull(multiplier) ? ambient_light_multiplier : multiplier

	update_ambient_light()

/// Replace one ambient light with another. This is effectively a delta update, but it can be used to pretend that our one channel is doing color blending.
/turf/proc/replace_ambient_light(old_color, new_color, old_multiplier, new_multiplier = 0)
	if (!TURF_IS_AMBIENT_LIT_UNSAFE(src))
		add_ambient_light(new_color, new_multiplier)
		return

	ASSERT(!isnull(old_multiplier))	// omitting new_multiplier is allowed for removing light nondestructively

	old_color ||= COLOR_WHITE
	new_color ||= COLOR_WHITE

	var/list/old_parts = rgb2num(old_color)
	var/list/new_parts = rgb2num(new_color)

	var/dr = (new_parts[1] / 255) * new_multiplier - (old_parts[1] / 255) * old_multiplier
	var/dg = (new_parts[2] / 255) * new_multiplier - (old_parts[2] / 255) * old_multiplier
	var/db = (new_parts[3] / 255) * new_multiplier - (old_parts[3] / 255) * old_multiplier

	if (!dr && !dg && !db)
		return

	add_ambient_light_raw(dr, dg, db)

/// Add an ambient light to the turf's self-channel. This is a delta update, retain your applied color if you want to be able to remove it later.
/turf/proc/add_ambient_light(color, multiplier, update = TRUE)
	if (!color)
		return

	multiplier ||= ambient_light_multiplier

	var/list/ambient_parts = rgb2num(color)

	var/ambient_r = (ambient_parts[1] / 255) * multiplier
	var/ambient_g = (ambient_parts[2] / 255) * multiplier
	var/ambient_b = (ambient_parts[3] / 255) * multiplier

	add_ambient_light_raw(ambient_r, ambient_g, ambient_b, update)

/// Directly manipulate the state of the self-ambience channel. Don't use unless you know what you're doing and how ambience works internally.
/turf/proc/add_ambient_light_raw(lr, lg, lb, update = TRUE)
	if (!lr && !lg && !lb)
		if (!ambient_light_old_r || !ambient_light_old_g || !ambient_light_old_b)
			ambient_active = FALSE
			SSlighting.total_ambient_turfs -= 1
		return

	if (!ambient_active)
		SSlighting.total_ambient_turfs += 1
		ambient_active = TRUE

	// There are four corners per (lit) turf, we don't want to apply our light 4 times -- compensate by dividing by 4.
	lr /= 4
	lg /= 4
	lb /= 4

	lr = round(lr, LIGHTING_ROUND_VALUE)
	lg = round(lg, LIGHTING_ROUND_VALUE)
	lb = round(lb, LIGHTING_ROUND_VALUE)

	ambient_light_old_r += lr
	ambient_light_old_g += lg
	ambient_light_old_b += lb

	if (!corners || !lighting_corners_initialised)
		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
			generate_missing_corners()
		else
			return

	// This list can contain nulls on things like space turfs -- they only have their neighbors' corners.
	for (var/datum/lighting_corner/C in corners)
		C.update_ambient_lumcount(lr, lg, lb, !update)

/// Wipe the entire self-ambience channel. This will preserve ambience from ambience groups.
/turf/proc/clear_ambient_light()
	if (ambient_light == null)
		return

	replace_ambient_light(ambient_light, COLOR_WHITE, ambient_light_multiplier, 0)
	ambient_light = null
	ambient_light_multiplier = initial(ambient_light_multiplier)

/turf/proc/update_ambient_light(no_corner_update = FALSE)
	// These are deltas.
	var/ambient_r = 0
	var/ambient_g = 0
	var/ambient_b = 0

	if (ambient_light)
		var/list/parts = rgb2num(ambient_light)
		ambient_r = ((parts[1] / 255) * ambient_light_multiplier) - ambient_light_old_r
		ambient_g = ((parts[2] / 255) * ambient_light_multiplier) - ambient_light_old_g
		ambient_b = ((parts[3] / 255) * ambient_light_multiplier) - ambient_light_old_b
	else
		ambient_r = -ambient_light_old_r
		ambient_g = -ambient_light_old_g
		ambient_b = -ambient_light_old_b

	add_ambient_light_raw(ambient_r, ambient_g, ambient_b, !no_corner_update)
