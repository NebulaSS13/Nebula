/datum/extension/tool
	expected_type = /obj/item
	base_type = /datum/extension/tool
	var/list/tool_values     // Delay multipliers/general tool quality indicators, lower is better but 0 or lower means it isn't valid as a tool.
	var/list/tool_use_sounds // Associative list of tool to sound/list of sounds used to override the archetype config sounds.

/datum/extension/tool/New(datum/holder, list/_tool_values)
	..()
	tool_values = _tool_values

/datum/extension/tool/proc/set_sound_overrides(list/_tool_use_sounds)

	// If we are supplied a list, assume it's an assoc list of tool types to sound.
	if(islist(_tool_use_sounds))
		tool_use_sounds = _tool_use_sounds
	else // Otherwise, init the list, and assume a non-list non-null value is an override for all tool types.
		tool_use_sounds = list()
		if(_tool_use_sounds)
			for(var/tool in tool_values)
				tool_use_sounds[tool] = _tool_use_sounds

	// Fill in any unset tools with the default sound for the tool type.
	for(var/tool in tool_values)
		if(isnull(tool_use_sounds[tool]))
			var/decl/tool_archetype/tool_archetype = GET_DECL(tool)
			tool_use_sounds[tool] = tool_archetype.use_sound

/datum/extension/tool/proc/get_tool_speed(var/archetype)
	. = Clamp((TOOL_QUALITY_BEST - get_tool_quality(archetype)), TOOL_SPEED_BEST, TOOL_SPEED_WORST)

/datum/extension/tool/proc/get_tool_quality(var/archetype)
	return LAZYACCESS(tool_values, archetype)

/datum/extension/tool/proc/handle_physical_manipulation(var/mob/user)
	return FALSE

// Returns a failure message as a string if the interaction fails.
/datum/extension/tool/proc/do_tool_interaction(var/archetype, var/mob/user, var/atom/target, var/delay, var/fuel_expenditure = 0, var/start_message)

	if(!istype(user) || !istype(target))
		return TOOL_USE_FAILURE_NOMESSAGE

	var/decl/tool_archetype/tool_archetype = GET_DECL(archetype)
	var/check_result = tool_archetype.can_use_tool(holder, fuel_expenditure)
	if(check_result != TOOL_USE_SUCCESS)
		return check_result

	check_result = tool_archetype.handle_pre_interaction(user, holder, fuel_expenditure)
	if(check_result != TOOL_USE_SUCCESS)
		return check_result

	user.visible_message(SPAN_NOTICE("\The [user] begins [start_message || tool_archetype.use_message] \the [target] with \the [holder]."), SPAN_NOTICE("You begin [start_message || tool_archetype.use_message] \the [target] with \the [holder]."))
	var/use_sound = LAZYACCESS(tool_use_sounds, archetype)
	if(islist(use_sound) && length(use_sound))
		use_sound = pick(use_sound)
	if(use_sound)
		playsound(user.loc, use_sound, 100)

	if(!do_after(user, max(5, CEILING(delay * get_tool_speed(archetype))), holder))
		return TOOL_USE_FAILURE_NOMESSAGE

	check_result = tool_archetype.handle_post_interaction(user, holder, fuel_expenditure)
	if(check_result != TOOL_USE_SUCCESS)
		return check_result
	
	if(check_result == TOOL_USE_SUCCESS && use_sound)
		playsound(user.loc, use_sound, 100) //A lot of interactions played a sound when starting and ending the interaction. This was missed.
	
	return TOOL_USE_SUCCESS
