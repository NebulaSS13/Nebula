/decl/flooring/grass
	name               = "grass"
	icon               = 'icons/turf/flooring/grass.dmi'
	icon_base          = "grass"
	desc               = "A patch of thriving meadowgrass."
	has_base_range     = 3
	footstep_type      = /decl/footsteps/grass
	icon_edge_layer    = FLOOR_EDGE_GRASS
	color              = null // color from material
	turf_flags         = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	can_engrave        = FALSE
	damage_temperature = T0C+80
	flooring_flags     = TURF_REMOVE_SHOVEL
	force_material     = /decl/material/solid/organic/plantmatter/grass
	growth_value       = 1.2 // Shouldn't really matter since you can't plant on grass, it turns to dirt first.
	uid                = "floor_grass"
	can_conceal_hazards = TRUE

	var/harvestable    = FALSE

/decl/flooring/grass/fire_act(turf/floor/target, datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(target.get_topmost_flooring() == src && (exposed_temperature > T0C + 200 && prob(5)) || exposed_temperature > T0C + 1000)
		target.remove_flooring(target.get_topmost_flooring())
		return TRUE
	return ..()

/decl/flooring/grass/handle_turf_digging(turf/floor/target)
	target.remove_flooring(target.get_topmost_flooring())
	return FALSE

/decl/flooring/grass/wild
	name               = "wild grass"
	icon               = 'icons/turf/flooring/wildgrass.dmi'
	icon_base          = "wildgrass"
	desc               = "A lush, overgrown patch of wild meadowgrass. Watch out for snakes."
	has_base_range     = null
	icon_edge_layer    = FLOOR_EDGE_GRASS_WILD
	harvestable        = TRUE
	uid                = "floor_grass_wild"

/decl/flooring/grass/wild/get_movable_alpha_mask_state(atom/movable/mover)
	. = ..() || "mask_grass"

/decl/flooring/grass/wild/handle_item_interaction(turf/floor/floor, mob/user, obj/item/item)
	var/decl/material/floor_material = floor.get_material()
	if(IS_KNIFE(item) && harvestable && istype(floor_material) && floor_material.dug_drop_type)
		if(item.do_tool_interaction(TOOL_KNIFE, user, floor, 3 SECONDS, start_message = "harvesting", success_message = "harvesting") && !QDELETED(floor) && floor.get_topmost_flooring() == src)
			new floor_material.dug_drop_type(floor, rand(2,5))
			floor.remove_flooring(src)
		return TRUE
	return ..()

/decl/flooring/grass/get_vehicle_transit_delay(obj/vehicle/vehicle)
	return 1

/decl/flooring/grass/fake
	desc            = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon            = 'icons/turf/flooring/fakegrass.dmi'
	has_base_range  = 3
	color           = "#5e7a3b"
	build_type      = /obj/item/stack/tile/grass
	force_material  = /decl/material/solid/organic/plastic
	uid                = "floor_grass_fake"

/decl/flooring/grass/fake/get_vehicle_transit_delay(obj/vehicle/vehicle)
	return vehicle::base_speed
