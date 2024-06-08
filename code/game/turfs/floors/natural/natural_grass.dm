/turf/floor/natural/grass
	name = "grass"
	desc = "A patch of grass, growing steadily and healthily."
	possible_states = 1
	icon = 'icons/turf/flooring/grass.dmi'
	footstep_type = /decl/footsteps/grass
	icon_edge_layer = EXT_EDGE_GRASS
	icon_has_corners = TRUE
	color = "#5e7a3b"
	base_color = "#5e7a3b"
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	material = /decl/material/solid/organic/plantmatter/grass

/turf/floor/natural/grass/get_plant_growth_rate()
	return 1.2 // Shouldn't really matter since you can't plant on grass, it turns to dirt first.

/turf/floor/natural/grass/wild
	name = "wild grass"
	desc = "Tall, lush grass that reaches past your ankles."
	possible_states = null
	icon = 'icons/turf/flooring/wildgrass.dmi'
	icon_edge_layer = EXT_EDGE_GRASS_WILD
	footstep_type = /decl/footsteps/grass
	color = "#5e7a3b"
	base_color = "#5e7a3b"

/turf/floor/natural/grass/wild/get_movable_alpha_mask_state(atom/movable/mover)
	. = ..() || "mask_grass"

/obj/item/stack/material/bundle/grass
	drying_wetness = 60
	dried_type = /obj/item/stack/material/bundle/grass/dry
	material = /decl/material/solid/organic/plantmatter/grass
	is_spawnable_type = TRUE

/obj/item/stack/material/bundle/grass/dry
	drying_wetness = null
	dried_type = null
	material = /decl/material/solid/organic/plantmatter/grass/dry

/turf/floor/natural/grass/wild/attackby(obj/item/W, mob/user)
	if(IS_KNIFE(W) && !istype(flooring))
		if(W.do_tool_interaction(TOOL_KNIFE, user, src, 3 SECONDS, start_message = "harvesting", success_message = "harvesting"))
			if(QDELETED(src) || !istype(src, /turf/floor/natural/grass/wild))
				return TRUE
			new /obj/item/stack/material/bundle/grass(src, rand(2,5))
			ChangeTurf(/turf/floor/natural/grass, keep_air = TRUE)
		return TRUE
	return ..()

/turf/floor/natural/grass/wild/Initialize(mapload, no_update_icon)
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

/turf/floor/natural/grass/wild/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if((temperature > T0C + 200 && prob(5)) || temperature > T0C + 1000)
		handle_melting()
	return ..()

/turf/floor/natural/grass/wild/handle_melting(list/meltable_materials)
	. = ..()
	if(icon_state != "scorched")
		SetName("scorched ground")
		desc = "What was once lush grass has been reduced to burnt ashes."
		icon_state = "scorched"
		icon_edge_layer = -1
		footstep_type = /decl/footsteps/asteroid
		color = null
