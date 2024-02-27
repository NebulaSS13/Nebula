/turf/exterior/dig_pit()
	drop_diggable_resources()
	if(is_fundament_turf)
		return ..()
	ChangeTurf(/turf/exterior/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/dig_trench()
	drop_diggable_resources()
	if(is_fundament_turf)
		set_height(max(get_physical_height()-100, -(FLUID_DEEP)))
	else
		ChangeTurf(/turf/exterior/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/can_dig_trench()
	return can_be_dug() && get_physical_height() > -(FLUID_DEEP)

/turf/exterior/can_be_dug()
	return !density && !is_open()

/turf/exterior/clear_diggable_resources()
	dug = TRUE
	..()
