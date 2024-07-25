/// Return an assoc list of resource item type to a base and a random component
/// ex. return list(/obj/item/stack/material/ore/handful/sand = list(3, 2))
/turf/proc/get_diggable_resources()
	return null

/turf/proc/clear_diggable_resources()
	SHOULD_CALL_PARENT(TRUE)
	update_icon()

/turf/proc/can_be_dug(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return FALSE

/turf/proc/drop_diggable_resources()
	SHOULD_CALL_PARENT(TRUE)
	var/list/diggable_resources = get_diggable_resources()
	if(!length(diggable_resources))
		return
	for(var/resource_type in diggable_resources)
		var/list/resource_amounts = diggable_resources[resource_type]
		if(ispath(resource_type, /obj/item/stack))
			LAZYADD(., new resource_type(src, resource_amounts[1] + rand(resource_amounts[2]), get_material_type()))
		else
			LAZYADD(., new resource_type(src, get_material_type()))
	clear_diggable_resources()

// Procs for digging pits.
/turf/proc/can_dig_pit(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_be_dug(tool_hardness, using_tool) && !(locate(/obj/structure/pit) in src)

/turf/proc/try_dig_pit(var/mob/user, var/obj/item/tool, using_tool = TOOL_SHOVEL)
	if((!user && !tool) || tool.do_tool_interaction(using_tool, user, src, 5 SECONDS, check_skill = SKILL_HAULING, set_cooldown = TRUE))
		return dig_pit(tool?.material?.hardness, using_tool)
	return null

/turf/proc/dig_pit(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_dig_pit(tool_hardness, using_tool) && new /obj/structure/pit(src)

// Procs for digging farms.
/turf/proc/can_dig_farm(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return get_plant_growth_rate() > 0 && can_be_dug(tool_hardness, using_tool) && !(locate(/obj/machinery/portable_atmospherics/hydroponics/soil) in src)

/turf/proc/try_dig_farm(mob/user, obj/item/tool, using_tool = TOOL_HOE)
	var/decl/material/material = get_material()
	if(!material?.tillable)
		return
	if((!user && !tool) || tool.do_tool_interaction(using_tool, user, src, 5 SECONDS, set_cooldown = TRUE, check_skill = SKILL_BOTANY))
		return dig_farm(tool?.material?.hardness, using_tool)
	return null

/turf/proc/dig_farm(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_dig_farm(tool_hardness, using_tool) && new /obj/machinery/portable_atmospherics/hydroponics/soil(src)

// Proc for digging trenches.
/turf/proc/can_dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_be_dug(tool_hardness, using_tool) && get_physical_height() > -(FLUID_DEEP)

/turf/proc/try_dig_trench(mob/user, obj/item/tool, using_tool = TOOL_SHOVEL)
	if((!user && !tool) || tool.do_tool_interaction(using_tool, user, src, 2.5 SECONDS, check_skill = SKILL_HAULING, set_cooldown = TRUE))
		return dig_trench(tool?.material?.hardness, using_tool)
	return null

/turf/proc/dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return FALSE
