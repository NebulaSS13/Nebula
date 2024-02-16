/datum/extension/tool
	expected_type = /obj/item
	base_type = /datum/extension/tool
	var/list/tool_values        // Delay multipliers/general tool quality indicators, lower is better but 0 or lower means it isn't valid as a tool.
	var/list/tool_use_sounds    // Associative list of tool to sound/list of sounds used to override the archetype config sounds.
	var/list/tool_properties    // Associative list of tool archetype to a list of properties and their values for that archetype.

/datum/extension/tool/New(datum/holder, list/_tool_values, list/_tool_properties)
	..()
	tool_values = _tool_values
	for(var/atype in _tool_properties)
		var/list/cur_props = LAZYACCESS(tool_properties, atype)? tool_properties[atype] + _tool_properties[atype] : _tool_properties[atype]
		LAZYSET(tool_properties, atype, cur_props)

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
	. = clamp((TOOL_QUALITY_BEST - get_tool_quality(archetype)), TOOL_SPEED_BEST, TOOL_SPEED_WORST)

/datum/extension/tool/proc/get_tool_quality(var/archetype)
	return LAZYACCESS(tool_values, archetype)

/**Return the value of the property specified for the given tool archetype. */
/datum/extension/tool/proc/get_tool_property(var/archetype, var/property)
	var/list/props = LAZYACCESS(tool_properties, archetype)
	//If we don't override, check the datum's default values
	if(!LAZYLEN(props))
		var/decl/tool_archetype/T = GET_DECL(archetype)
		props = T.properties
	return LAZYACCESS(props, property)

/**Set the given tool property for the given tool archetype */
/datum/extension/tool/proc/set_tool_property(var/archetype, var/property, var/value)
	var/list/props = LAZYACCESS(tool_properties, archetype)
	if(!props)
		LAZYSET(tool_properties, archetype, list()) //Init the properties override list
		props = tool_properties[archetype]
	LAZYSET(props, property, value)

/datum/extension/tool/proc/handle_physical_manipulation(var/mob/user)
	return FALSE

// Returns a failure message as a string if the interaction fails.
/datum/extension/tool/proc/do_tool_interaction(var/archetype, var/mob/user, var/atom/target, var/delay = (1 SECOND), var/start_message, var/success_message, var/failure_message, var/fuel_expenditure = 0, var/check_skill = SKILL_CONSTRUCTION, var/check_skill_threshold, var/check_skill_prob = 50, var/set_cooldown = FALSE)

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
	 //If no sound overrides, grab the archetype's sound/sound list
	if(!use_sound)
		use_sound = tool_archetype.use_sound
	if(islist(use_sound))
		if(length(use_sound))
			use_sound = pick(use_sound)
		else
			use_sound = null
	if(use_sound)
		playsound(user.loc, use_sound, 100)

	// If we have a delay, reduce it by the tool speed and then further reduce via skill if necessary.
	if(delay)
		delay = max(5, CEILING(delay * get_tool_speed(archetype)))
		if(check_skill)
			if(!user.do_skilled(delay, check_skill, target, check_holding = TRUE, set_cooldown = set_cooldown))
				return TOOL_USE_FAILURE_NOMESSAGE
		else
			if(!do_after(user, delay, target, check_holding = TRUE, set_cooldown = set_cooldown))
				return TOOL_USE_FAILURE_NOMESSAGE

	// Basic skill check for the action - do it post-delay so they can't just spamclick.
	if(check_skill && check_skill_threshold && check_skill_prob)
		if(prob(user.skill_fail_chance(check_skill, check_skill_prob, check_skill_threshold)))
			to_chat(user, SPAN_WARNING("You fumble hopelessly with \the [holder]."))
			return TOOL_USE_FAILURE

	check_result = tool_archetype.handle_post_interaction(user, holder, fuel_expenditure)
	if(check_result != TOOL_USE_SUCCESS)
		return check_result

	if(check_result == TOOL_USE_SUCCESS && use_sound)
		playsound(user.loc, use_sound, 100) //A lot of interactions played a sound when starting and ending the interaction. This was missed.

	return TOOL_USE_SUCCESS
