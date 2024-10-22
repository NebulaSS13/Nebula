/datum/extension/tool/variable
	var/current_tool
	var/list/tool_config_sounds // Associative list of tool to sound/list of sounds used to override the archetype use sounds.

/datum/extension/tool/variable/set_sound_overrides(list/_tool_use_sounds, list/_tool_config_sounds)
	..()

	// If we are supplied a list, assume it's an assoc list of tool types to sound.
	if(islist(_tool_config_sounds))
		tool_config_sounds = _tool_config_sounds
	else // Otherwise, init the list, and assume a non-list non-null value is an override for all tool types.
		tool_config_sounds = list()
		if(_tool_config_sounds)
			for(var/tool in tool_values)
				tool_config_sounds[tool] = _tool_config_sounds

	// Fill in any unset tools with the default sound for the tool type.
	for(var/tool in tool_values)
		if(isnull(tool_config_sounds[tool]))
			var/decl/tool_archetype/tool_archetype = GET_DECL(tool)
			tool_config_sounds[tool] = tool_archetype.config_sound

/datum/extension/tool/variable/New(datum/holder, list/_tool_values, list/_tool_use_sounds)
	..()
	if(length(tool_values) < 2)
		PRINT_STACK_TRACE("Variable tool extension created with [length(tool_values)]] tool value\s, requires minimum of 2.")
		return
	current_tool = tool_values[1]

/datum/extension/tool/variable/get_tool_quality(archetype)
	return (current_tool == archetype) ? ..() : 0

/datum/extension/tool/variable/get_tool_speed(archetype)
	return (current_tool == archetype) ? ..() : INFINITY

/datum/extension/tool/variable/handle_physical_manipulation(var/mob/user)
	return switch_tool(next_in_list(current_tool, tool_values), user)

/datum/extension/tool/variable/proc/switch_tool(new_tool, mob/user)
	if(!(new_tool in tool_values))
		CRASH("Invalid tool mode [new_tool] passed to [holder]'s [type]!")
	current_tool = new_tool
	var/config_sound = LAZYACCESS(tool_config_sounds, current_tool)
	if(islist(config_sound) && length(config_sound))
		config_sound = pick(config_sound)
	if(config_sound)
		playsound(user.loc, config_sound, 50, 1)
	var/decl/tool_archetype/tool_archetype = GET_DECL(current_tool)
	var/tool_name = tool_archetype.name
	if(tool_archetype.article)
		tool_name = "\a [tool_name]"

	to_chat(user, get_adjustment_message(tool_name))
	var/atom/A = holder
	A.update_icon()
	return TRUE

/datum/extension/tool/variable/proc/get_adjustment_message(tool_name)
	return SPAN_NOTICE("You adjust \the [holder] to function as [tool_name].")

/datum/extension/tool/variable/simple/get_adjustment_message(tool_name)
	return SPAN_NOTICE("You adjust your grip on \the [holder] to use it as [tool_name].")