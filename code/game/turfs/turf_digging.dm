/// Return an assoc list of resource item type to a base and a random component
/// ex. return list(/obj/item/stack/material/ore/handful/sand = list(3, 2))
/turf/proc/get_diggable_resources()
	return null

/turf/exterior/get_diggable_resources()
	if(istype(material) && material.dug_drop_type && (get_physical_height() > -(FLUID_DEEP)))
		return list(material.dug_drop_type = list(3, 2))

/turf/proc/clear_diggable_resources()
	SHOULD_CALL_PARENT(TRUE)
	update_icon()

/turf/proc/can_be_dug(tool_hardness = MAT_VALUE_MALLEABLE, max_diggable_hardness = MAT_VALUE_FLEXIBLE)
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

/turf/proc/can_dig_pit(tool_hardness = MAT_VALUE_MALLEABLE)
	return can_be_dug(tool_hardness) && !(locate(/obj/structure/pit) in src)

/turf/proc/try_dig_pit(var/mob/user, var/obj/item/tool, using_tool = TOOL_SHOVEL)
	if((!user && !tool) || tool.do_tool_interaction(using_tool, user, src, 5 SECONDS, set_cooldown = TRUE))
		return dig_pit(tool?.material?.hardness)
	return null

/turf/proc/dig_pit(tool_hardness = MAT_VALUE_MALLEABLE)
	return can_dig_pit(tool_hardness) && new /obj/structure/pit(src)

/turf/proc/can_dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, max_diggable_hardness = MAT_VALUE_FLEXIBLE)
	return FALSE

/turf/proc/try_dig_trench(mob/user, obj/item/tool, max_diggable_hardness = MAT_VALUE_FLEXIBLE, using_tool = TOOL_SHOVEL)
	if((!user && !tool) || tool.do_tool_interaction(using_tool, user, src, 2.5 SECONDS, set_cooldown = TRUE))
		return dig_trench(tool?.material?.hardness, max_diggable_hardness)
	return null

/turf/proc/dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, max_diggable_hardness = MAT_VALUE_FLEXIBLE)
	return FALSE
