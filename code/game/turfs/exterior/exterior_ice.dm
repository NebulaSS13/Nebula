/turf/exterior/ice
	name = "ice"
	icon = 'icons/turf/exterior/ice.dmi'
	footstep_type = /decl/footsteps/plating
	base_color = COLOR_LIQUID_WATER
	color = COLOR_LIQUID_WATER

/turf/exterior/ice/Initialize()
	. = ..()
	update_icon()

/turf/exterior/ice/on_update_icon()
	. = ..()
	var/image/I = image(icon, "shine")
	I.appearance_flags |= RESET_COLOR
	add_overlay(I)

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
	handle_melting()
	return ..()

/turf/exterior/snow/handle_melting(list/meltable_materials)
	. = ..()
	ChangeTurf(/turf/exterior/ice, keep_height = TRUE)
