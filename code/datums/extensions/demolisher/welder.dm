/datum/extension/demolisher/welder
	demolish_verb = "cutting through"
	demolish_sound = 'sound/items/Welder.ogg'
	expected_type = /obj/item

/datum/extension/demolisher/welder/try_demolish(mob/user, turf/wall/wall)
	if(!(wall.get_material()?.removed_by_welder))
		to_chat(user, SPAN_WARNING("\The [wall] is too delicate to be dismantled with \the [holder]; try a hammer or crowbar."))
		return TRUE
	var/obj/item/welder = holder
	var/decl/tool_archetype/welder_archetype = GET_DECL(TOOL_WELDER)
	if(welder_archetype.can_use_tool(welder) != TOOL_USE_SUCCESS)
		return TRUE
	if(welder_archetype.handle_pre_interaction(welder) != TOOL_USE_SUCCESS)
		return TRUE
	return ..()

/datum/extension/demolisher/welder/get_demolish_delay(turf/wall/wall)
	return ..() * 0.7
