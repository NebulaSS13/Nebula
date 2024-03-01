/turf/exterior/ice
	name = "ice"
	icon = 'icons/turf/flooring/ice.dmi'
	icon_state = "ice"
	flooring_layers = /decl/flooring/ice

/decl/flooring/ice
	name = "ice"
	icon_base = "ice"
	icon = 'icons/turf/flooring/ice.dmi'
	footstep_type = /decl/footsteps/plating

/turf/exterior/snow
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snow"
	dirt_color = "#e3e7e8"
	flooring_layers = /decl/flooring/snow

/decl/flooring/snow
	name = "snow"
	desc = "Let it sno-ow... Let it snow..."
	icon = 'icons/turf/flooring/snow.dmi'
	icon_base = "snow"
	icon_edge_layer = EXT_EDGE_SNOW
	footstep_type = /decl/footsteps/snow
	has_base_range = 13
	flags = TURF_REMOVE_SHOVEL
	build_type = null
	can_engrave = FALSE

/decl/flooring/snow/get_flooring_movement_delay(travel_dir, mob/mover)
	. = ..()
	if(mover)
		var/obj/item/clothing/shoes/shoes = mover.get_equipped_item(slot_shoes_str)
		if(shoes)
			. += shoes.snow_slowdown_mod
		var/decl/species/my_species = mover.get_species()
		if(my_species)
			. += my_species.snow_slowdown_mod
		. = max(., 0)

/turf/exterior/snow/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	handle_melting()
	return ..()

/turf/exterior/snow/handle_melting(list/meltable_materials)
	. = ..()
	set_flooring_layers(/decl/flooring/permafrost)

/decl/flooring/permafrost
	name = "permafrost"
	icon = 'icons/turf/flooring/permafrost.dmi'
	icon_base = "permafrost"
	icon_edge_layer = -1
	footstep_type = /decl/footsteps/asteroid
