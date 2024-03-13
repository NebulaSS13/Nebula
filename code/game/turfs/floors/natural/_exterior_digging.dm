/turf/exterior/dig_pit()
	if(is_fundament_turf)
		return ..()
	drop_diggable_resources()
	ChangeTurf(/turf/exterior/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/dig_trench()
	if(is_fundament_turf)
		var/new_height = max(get_physical_height()-TRENCH_DEPTH_PER_ACTION, -(FLUID_DEEP))
		var/height_diff = abs(get_physical_height()-new_height)
		// Only drop mats if we actually changed the turf height sufficiently.
		if(height_diff >= TRENCH_DEPTH_PER_ACTION)
			drop_diggable_resources()
		set_physical_height(new_height)
	else
		ChangeTurf(/turf/exterior/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/can_dig_trench()
	return can_be_dug() && get_physical_height() > -(FLUID_DEEP)

/turf/exterior/can_be_dug()
	return !density && !is_open()
