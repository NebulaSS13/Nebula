/turf/floor/natural/ice
	name = "ice"
	desc = "A sheet of smooth, slick ice. Be careful not to slip..."
	icon = 'icons/turf/flooring/ice.dmi'
	footstep_type = /decl/footsteps/plating
	base_color = COLOR_LIQUID_WATER
	color = COLOR_LIQUID_WATER
	material = /decl/material/solid/ice
	can_engrave = TRUE

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
	desc = "Let it snow, let it snow, let it snow..."
	icon = 'icons/turf/flooring/snow.dmi'
	icon_edge_layer = EXT_EDGE_SNOW
	footstep_type = /decl/footsteps/snow
	possible_states = 13
	dirt_color = "#e3e7e8"
	material = /decl/material/solid/ice/snow

/turf/floor/natural/snow/get_base_movement_delay(travel_dir, mob/mover)
	. = ..()
	if(mover)
		var/obj/item/clothing/shoes/shoes = mover.get_equipped_item(slot_shoes_str)
		if(shoes)
			. += shoes.snow_slowdown_mod
		var/decl/species/my_species = mover.get_species()
		if(my_species)
			. += my_species.snow_slowdown_mod
		. = max(., 0)

/turf/floor/natural/snow/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	handle_melting()
	return ..()

/turf/floor/natural/snow/handle_melting(list/meltable_materials)
	. = ..()
	ChangeTurf(/turf/floor/natural/ice, keep_air = TRUE, keep_height = TRUE)
