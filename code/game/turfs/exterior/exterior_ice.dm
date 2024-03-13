/turf/floor/natural/ice
	name = "ice"
	icon = 'icons/turf/exterior/ice.dmi'
	footstep_type = /decl/footsteps/plating
	base_color = COLOR_LIQUID_WATER
	color = COLOR_LIQUID_WATER
	material = /decl/material/solid/ice

/turf/floor/natural/ice/Initialize()
	. = ..()
	update_icon()

/turf/floor/natural/ice/on_update_icon()
	. = ..()
	var/image/I = image(icon, "shine")
	I.appearance_flags |= RESET_COLOR
	add_overlay(I)

/turf/floor/natural/snow
	name = "snow"
	icon = 'icons/turf/exterior/snow.dmi'
	icon_edge_layer = EXT_EDGE_SNOW
	footstep_type = /decl/footsteps/snow
	possible_states = 13
	dirt_color = "#e3e7e8"
	material = /decl/material/solid/ice/snow

/turf/floor/natural/snow/get_base_movement_delay(travel_dir, mob/mover)
	. = ..()
	if(mover)
		var/decl/flooring/snow = GET_DECL(/decl/flooring/snow)
		. += snow.get_movement_delay(travel_dir, mover)

/turf/floor/natural/snow/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	handle_melting()
	return ..()

/turf/floor/natural/snow/handle_melting(list/meltable_materials)
	. = ..()
	ChangeTurf(/turf/floor/natural/ice, keep_height = TRUE)
