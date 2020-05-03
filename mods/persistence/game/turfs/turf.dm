/turf/after_deserialize()
	..()
	initial_gas = null
	if(is_on_fire)
		hotspot_expose(700, 2)
	is_on_fire = FALSE
	needs_air_update = TRUE
	queue_icon_update()
	if(dynamic_lighting)
		lighting_build_overlay()
	else
		lighting_clear_overlay()