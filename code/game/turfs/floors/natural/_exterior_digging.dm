/turf/exterior
	var/const/MAX_DIGGABLE_HARDNESS = MAT_VALUE_HARD

/turf/exterior/dig_pit(tool_hardness = MAT_VALUE_MALLEABLE)
	if(istype(material) && material.hardness > tool_hardness)
		return
	if(is_fundament_turf)
		return ..()
	drop_diggable_resources()
	ChangeTurf(/turf/exterior/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, max_diggable_hardness = MAT_VALUE_FLEXIBLE)
	if(istype(material) && (!material || material.hardness > tool_hardness || material.hardness > max_diggable_hardness))
		return
	if(is_fundament_turf)
		var/new_height = max(get_physical_height()-TRENCH_DEPTH_PER_ACTION, -(FLUID_DEEP))
		var/height_diff = abs(get_physical_height()-new_height)
		// Only drop mats if we actually changed the turf height sufficiently.
		if(height_diff >= TRENCH_DEPTH_PER_ACTION)
			drop_diggable_resources()
		set_physical_height(new_height)
	else
		ChangeTurf(/turf/exterior/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/can_be_dug(tool_hardness = MAT_VALUE_MALLEABLE, max_diggable_hardness = MAT_VALUE_FLEXIBLE)
	return !density && !is_open() && material && material.hardness <= tool_hardness && material.hardness <= max_diggable_hardness

/turf/exterior/can_dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, max_diggable_hardness = MAT_VALUE_FLEXIBLE)
	return can_be_dug(tool_hardness, max_diggable_hardness) && get_physical_height() > -(FLUID_DEEP)
