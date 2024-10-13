/decl/flooring/grass
	name               = "grass"
	icon               = 'icons/turf/flooring/grass.dmi'
	icon_base          = "grass"
	desc               = "A patch of thriving meadowgrass."
	has_base_range     = 3
	footstep_type      = /decl/footsteps/grass
	icon_edge_layer    = FLOOR_EDGE_GRASS
	color              = "#5e7a3b"
	turf_flags         = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	can_engrave        = FALSE
	damage_temperature = T0C+80
	flooring_flags     = TURF_REMOVE_SHOVEL
	force_material     = /decl/material/solid/organic/plantmatter/grass
	growth_value       = 1.2 // Shouldn't really matter since you can't plant on grass, it turns to dirt first.
	var/harvestable    = FALSE

/decl/flooring/grass/fire_act(turf/floor/target, datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(target.get_topmost_flooring() == src && (exposed_temperature > T0C + 200 && prob(5)) || exposed_temperature > T0C + 1000)
		target.set_flooring(null)
		return TRUE
	return ..()

/decl/flooring/grass/wild
	name               = "wild grass"
	icon               = 'icons/turf/flooring/wildgrass.dmi'
	icon_base          = "wildgrass"
	desc               = "A lush, overgrown patch of wild meadowgrass. Watch out for snakes."
	has_base_range     = null
	icon_edge_layer    = FLOOR_EDGE_GRASS_WILD
	harvestable        = TRUE

/decl/flooring/grass/wild/get_movable_alpha_mask_state(atom/movable/mover)
	. = ..() || "mask_grass"

/decl/flooring/grass/wild/handle_item_interaction(turf/floor/floor, mob/user, obj/item/item)
	if(IS_KNIFE(item) && harvestable)
		if(item.do_tool_interaction(TOOL_KNIFE, user, floor, 3 SECONDS, start_message = "harvesting", success_message = "harvesting") && !QDELETED(floor) && floor.get_topmost_flooring() == src)
			new /obj/item/stack/material/bundle/grass(floor, rand(2,5))
			floor.set_flooring(/decl/flooring/grass)
		return TRUE
	return ..()

/decl/flooring/grass/fake
	desc            = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon            = 'icons/turf/flooring/fakegrass.dmi'
	has_base_range  = 3
	build_type      = /obj/item/stack/tile/grass
	force_material  = /decl/material/solid/organic/plastic
