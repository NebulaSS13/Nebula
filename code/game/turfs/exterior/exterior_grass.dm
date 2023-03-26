/turf/exterior/grass
	name = "grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	flooring_layers = /decl/flooring/grass

/decl/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass
	can_engrave = FALSE
	icon = 'icons/turf/flooring/grass.dmi'
	footstep_type = /decl/footsteps/grass
	icon_edge_layer = EXT_EDGE_GRASS

/turf/exterior/wildgrass
	name = "wild grass"
	icon = 'icons/turf/flooring/wildgrass.dmi'
	color = "#799c4b"
	icon_state = "wildgrass"
	flooring_layers = /decl/flooring/wildgrass

/decl/flooring/wildgrass
	name = "wild grass"
	desc = "Watch out for snakes!"
	icon_base = "wildgrass"
	icon = 'icons/turf/flooring/wildgrass.dmi'
	color = "#799c4b"
	damage_temperature = T0C+80
	icon_edge_layer = EXT_EDGE_GRASS_WILD
	footstep_type = /decl/footsteps/grass
	can_engrave = FALSE

/turf/exterior/wildgrass/Initialize(mapload, no_update_icon)
	. = ..()
	//It's possible we're created on a level that's not a planet!
	var/datum/planetoid_data/P = SSmapping.planetoid_data_by_z[z]
	var/grass_color = P?.get_grass_color()
	if(grass_color)
		color = grass_color

	//#TODO: Check if this is still relevant/wanted since we got map gen to handle this?
	var/datum/extension/buried_resources/resources = get_or_create_extension(src, /datum/extension/buried_resources)
	if(prob(70))
		LAZYSET(resources.resources, /decl/material/solid/graphite, rand(3,5))
	if(prob(5))
		LAZYSET(resources.resources, /decl/material/solid/metal/uranium, rand(1,3))
	if(prob(2))
		LAZYSET(resources.resources, /decl/material/solid/gemstone/diamond,  1)
	if(!LAZYLEN(resources.resources))
		remove_extension(src, /datum/extension/buried_resources)

/turf/exterior/wildgrass/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if((temperature > T0C + 200 && prob(5)) || temperature > T0C + 1000)
		handle_melting()
	return ..()

/turf/exterior/wildgrass/handle_melting(list/meltable_materials)
	. = ..()
	set_flooring_layers(/decl/flooring/scorched_ground)

/decl/flooring/scorched_ground
	name = "scorched ground"
	icon_edge_layer = -1
	icon_base = "scorched"
	footstep_type = /decl/footsteps/asteroid
	color = null
	icon = 'icons/turf/flooring/scorched.dmi'
