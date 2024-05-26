/turf/exterior/dig_pit()
	drop_diggable_resources()
	if(is_fundament_turf)
		return ..()
	ChangeTurf(/turf/exterior/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/exterior/can_be_dug()
	return !density && !is_open()

/turf/exterior/clear_diggable_resources()
	dug = TRUE
	..()
