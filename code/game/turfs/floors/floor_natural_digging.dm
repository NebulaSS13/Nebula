/turf/floor/natural/dig_pit()
	drop_diggable_resources()
	if(is_fundament_turf)
		return ..()
	ChangeTurf(/turf/floor/natural/dirt, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)

/turf/floor/natural/can_be_dug()
	return !density && !is_open()

/turf/floor/natural/clear_diggable_resources()
	dug = TRUE
	..()
