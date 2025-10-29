/turf/floor
	var/gemstone_dropped = FALSE

/turf/floor/proc/flooring_is_diggable()
	var/decl/flooring/flooring = get_topmost_flooring()
	if(!flooring || flooring.constructed)
		return FALSE
	return TRUE

/turf/floor/can_be_dug(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	// This should be removed before digging trenches.
	if(!flooring_is_diggable())
		return FALSE
	var/decl/flooring/flooring = get_base_flooring()
	if(istype(flooring) && flooring.constructed)
		return FALSE
	var/decl/material/my_material = get_material()
	if(density || is_open() || !istype(my_material))
		return FALSE
	if(my_material.hardness > tool_hardness)
		return FALSE
	if(using_tool == TOOL_SHOVEL && my_material.hardness > MAT_VALUE_FLEXIBLE)
		return FALSE
	if(using_tool == TOOL_PICK && my_material.hardness <= MAT_VALUE_FLEXIBLE)
		return FALSE
	return TRUE

/turf/floor/dig_trench(mob/user, tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	if(!flooring_is_diggable())
		return

	var/decl/flooring/flooring = get_topmost_flooring()
	if(!flooring.handle_turf_digging(src))
		return

	var/old_height  = get_physical_height()
	var/new_height  = max(old_height-TRENCH_DEPTH_PER_ACTION, -(FLUID_DEEP))
	var/height_diff = round(abs(old_height-new_height))
	if(new_height <= -(FLUID_DEEP))
		var/open_turf_path = get_open_turf_type_by_area(src)
		if(!open_turf_path)
			to_chat(user, SPAN_WARNING("You cannot dig any lower!"))
			return
		to_chat(user, SPAN_DANGER("You break through \the [src]!"))
		drop_diggable_resources(user)
		ChangeTurf(open_turf_path)
	// Only drop mats if we actually changed the turf height sufficiently.
	else if(height_diff >= TRENCH_DEPTH_PER_ACTION)
		drop_diggable_resources(user)
	set_physical_height(new_height)

/turf/floor/dig_pit(mob/user, tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return has_flooring() ? null : ..()

/turf/floor/get_diggable_resources()
	var/decl/material/my_material = get_material()
	if(!flooring_is_diggable() || !istype(my_material) || !my_material.dug_drop_type || (get_physical_height() <= -(FLUID_DEEP)))
		return

	. = list()

	// All turfs drop resources to backfill them with (or make firepits, etc)
	.[my_material.dug_drop_type] = list("amount" = 3, "variance" = 2, "material" = my_material.type)

	// Dirt/mud/etc might have some worms.
	if(prob(5 * get_plant_growth_rate()))
		.[/obj/item/food/worm] = list("amount" = 1, "material" = /obj/item/food/worm::material)

	// Some materials (like clay) might contain gemstones.
	if(!gemstone_dropped && prob(my_material.gemstone_chance) && LAZYLEN(my_material.gemstone_types))
		gemstone_dropped = TRUE
		var/gem_mat = pick(my_material.gemstone_types)
		.[/obj/item/gemstone] = list("amount" = 1, "material" = gem_mat)

