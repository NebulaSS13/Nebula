/turf/floor/natural
	var/const/MAX_DIGGABLE_HARDNESS = MAT_VALUE_HARD

/turf/exterior/can_be_dug(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	. = !density && !is_open() && material
	if(.)
		if(material.hardness > tool_hardness)
			return FALSE
		if(using_tool == TOOL_SHOVEL && material.hardness > MAT_VALUE_FLEXIBLE)
			return FALSE
		if(using_tool == TOOL_PICK && material.hardness <= MAT_VALUE_FLEXIBLE)
			return FALSE

/turf/exterior/dig_pit(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	if(is_fundament_turf)
		return ..()
	drop_diggable_resources()
	ChangeTurf(/turf/floor/natural/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/dig_farm(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	if(is_fundament_turf)
		return ..()
	drop_diggable_resources()
	ChangeTurf(/turf/exterior/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	if(is_fundament_turf)
		var/new_height = max(get_physical_height()-TRENCH_DEPTH_PER_ACTION, -(FLUID_DEEP))
		var/height_diff = abs(get_physical_height()-new_height)
		// Only drop mats if we actually changed the turf height sufficiently.
		if(height_diff >= TRENCH_DEPTH_PER_ACTION)
			drop_diggable_resources()
		set_physical_height(new_height)
	else
		ChangeTurf(/turf/floor/natural/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)
