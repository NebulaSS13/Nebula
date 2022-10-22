/obj/item/proc/get_tool_quality(var/archetype)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.get_tool_quality(archetype)

/obj/item/proc/get_tool_speed(var/archetype)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.get_tool_speed(archetype)

/obj/item/proc/do_tool_interaction(var/archetype, var/mob/user, var/atom/target, var/delay = (1 SECOND), var/start_message, var/success_message, var/failure_message, var/fuel_expenditure = 0)

	if(get_tool_quality(archetype) <= 0)
		return FALSE

	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool.do_tool_interaction(archetype, user, target, delay, fuel_expenditure, start_message)

	if(QDELETED(user))
		return FALSE

	if(. == TOOL_USE_SUCCESS)
		if(success_message)
			user.visible_message(
				SPAN_NOTICE("\The [user] finishes [success_message] \the [target] with \the [src]."), 
				SPAN_NOTICE("You finish [success_message] \the [target] with \the [src].")
			)
		return TRUE

	if(. == TOOL_USE_FAILURE_NOMESSAGE && failure_message)
		to_chat(user, SPAN_WARNING(failure_message))
	return FALSE

/obj/item/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(!user || user.get_preference_value(/datum/client_preference/inquisitive_examine) == PREF_OFF)
		return
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	var/list/tool_strings
	for(var/tool_type in tool?.tool_values)
		var/decl/tool_archetype/tool_archetype = GET_DECL(tool_type)
		var/tool_string = tool_archetype.get_tool_quality_descriptor(tool.tool_values[tool_type])
		if(tool_archetype.codex_key)
			tool_string = "<a href='?src=\ref[SScodex];show_examined_info=[tool_archetype.codex_key];show_to=\ref[user]'>[tool_string]</a>"
		LAZYADD(tool_strings, tool_string)
	if(length(tool_strings))
		to_chat(user, "[gender == PLURAL ? "They look" : "It looks"] like [english_list(tool_strings)].")
