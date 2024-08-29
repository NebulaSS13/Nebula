/obj/item/proc/get_tool_quality(var/archetype)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.get_tool_quality(archetype)
	if(!.)
		var/decl/tool_archetype/tool_arch = GET_DECL(archetype)
		. = tool_arch.get_default_quality(src)

/obj/item/proc/get_best_tool_archetype()
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	if(tool)
		for(var/tool_archetype in tool.tool_values)
			if(!. || tool.get_tool_quality(tool_archetype) > tool.get_tool_quality(.))
				. = tool_archetype

/obj/item/proc/get_tool_speed(var/archetype)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.get_tool_speed(archetype)
	if(!.)
		var/decl/tool_archetype/tool_arch = GET_DECL(archetype)
		. = tool_arch.get_default_speed(src)

/**Returns the property's value for a givent archetype. */
/obj/item/proc/get_tool_property(var/archetype, var/property)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.get_tool_property(archetype, property)

/obj/item/proc/get_expected_tool_use_delay(archetype, delay, mob/user, check_skill = SKILL_CONSTRUCTION)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.get_expected_tool_use_delay(archetype, delay, user, check_skill)

/obj/item/proc/get_tool_sound(var/archetype)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.get_tool_sound(archetype)

/obj/item/proc/get_tool_message(var/archetype)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.get_tool_message(archetype)

/**Set the property for the given tool archetype to the specified value. */
/obj/item/proc/set_tool_property(var/archetype, var/property, var/value)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	. = tool?.set_tool_property(archetype, property, value)

/obj/item/proc/do_tool_interaction(var/archetype, var/mob/user, var/atom/target, var/delay = (1 SECOND), var/start_message, var/success_message, var/failure_message, var/fuel_expenditure = 0, var/check_skill = SKILL_CONSTRUCTION, var/prefix_message, var/suffix_message, var/check_skill_threshold, var/check_skill_prob = 50, var/set_cooldown = FALSE)

	if(get_tool_quality(archetype) <= 0)
		return FALSE

	if(!user_can_attack_with(user))
		return FALSE

	. = handle_tool_interaction(archetype, user, src, target, delay, start_message, success_message, failure_message, fuel_expenditure, check_skill, prefix_message, suffix_message, check_skill_threshold, check_skill_prob, set_cooldown)

	if(QDELETED(user) || QDELETED(target))
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
			tool_string = "<a href='byond://?src=\ref[SScodex];show_examined_info=[tool_archetype.codex_key];show_to=\ref[user]'>[tool_string]</a>"
		LAZYADD(tool_strings, tool_string)
	if(length(tool_strings))
		to_chat(user, "[gender == PLURAL ? "They look" : "It looks"] like [english_list(tool_strings)].")
