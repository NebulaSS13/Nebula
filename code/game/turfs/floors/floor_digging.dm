/turf/floor/proc/is_fundament()
	var/decl/flooring/flooring = get_topmost_flooring()
	return flooring ? !flooring.constructed : TRUE

/turf/floor/can_be_dug(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	// This should be removed before digging trenches.
	if(!is_fundament())
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

/turf/floor/can_dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_be_dug(tool_hardness, using_tool) && get_physical_height() > -(FLUID_DEEP)

/turf/floor/dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	if(!is_fundament())
		return
	var/new_height = max(get_physical_height()-TRENCH_DEPTH_PER_ACTION, -(FLUID_DEEP))
	var/height_diff = abs(get_physical_height()-new_height)
	// Only drop mats if we actually changed the turf height sufficiently.
	if(height_diff >= TRENCH_DEPTH_PER_ACTION)
		drop_diggable_resources()
	set_physical_height(new_height)

/turf/floor/dig_pit(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return has_flooring() ? null : ..()

/turf/floor/get_diggable_resources()
	var/decl/material/my_material = get_material()
	if(is_fundament() && istype(my_material) && my_material.dug_drop_type && (get_physical_height() > -(FLUID_DEEP)))
		return list(my_material.dug_drop_type = list(3, 2))
	return null
