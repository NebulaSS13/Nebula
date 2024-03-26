/// Return an assoc list of resource item type to a base and a random component
/// ex. return list(/obj/item/stack/material/ore/handful/sand = list(3, 2))
/turf/proc/get_diggable_resources()
	return null

/turf/proc/clear_diggable_resources()
	SHOULD_CALL_PARENT(TRUE)
	update_icon()

/turf/proc/can_be_dug()
	return FALSE

/turf/proc/drop_diggable_resources()
	SHOULD_CALL_PARENT(TRUE)
	var/list/diggable_resources = get_diggable_resources()
	if(!length(diggable_resources))
		return
	for(var/resource_type in diggable_resources)
		var/list/resource_amounts = diggable_resources[resource_type]
		LAZYADD(., new resource_type(src, resource_amounts[1] + rand(resource_amounts[2])))
	clear_diggable_resources()

/turf/proc/can_dig_pit()
	return can_be_dug() && !(locate(/obj/structure/pit) in src)

/turf/proc/try_dig_pit(var/mob/user, var/obj/item/tool)
	if((!user && !tool) || tool.do_tool_interaction(TOOL_SHOVEL, user, src, 5 SECONDS, set_cooldown = TRUE))
		return dig_pit()
	return null

/turf/proc/dig_pit()
	return can_dig_pit() && new /obj/structure/pit(src)

/turf/proc/can_dig_trench()
	return FALSE

/turf/proc/try_dig_trench(mob/user, obj/item/tool)
	if((!user && !tool) || tool.do_tool_interaction(TOOL_SHOVEL, user, src, 2.5 SECONDS, set_cooldown = TRUE))
		return dig_trench()
	return null

/turf/proc/dig_trench()
	return FALSE
