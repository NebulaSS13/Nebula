/turf/exterior/ice
	name = "ice"
	icon = 'icons/turf/exterior/ice.dmi'
	footstep_type = /decl/footsteps/plating

/turf/exterior/snow
	name = "snow"
	icon = 'icons/turf/exterior/snow.dmi'
	icon_edge_layer = EXT_EDGE_SNOW
	footstep_type = /decl/footsteps/snow
	possible_states = 13
	dirt_color = "#e3e7e8"

/turf/exterior/snow/get_base_movement_delay(travel_dir, mob/mover)
	. = ..()
	if(mover)
		var/decl/flooring/snow = GET_DECL(/decl/flooring/snow)
		. += snow.get_movement_delay(travel_dir, mover)

/turf/exterior/snow/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	melt()

/turf/exterior/snow/melt()
	if(icon_state != "permafrost")
		SetName("permafrost")
		icon_state = "permafrost"
		icon_edge_layer = -1
		footstep_type = /decl/footsteps/asteroid
