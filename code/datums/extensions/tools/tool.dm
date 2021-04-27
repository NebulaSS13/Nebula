/datum/extension/tool
	base_type = /datum/extension/tool
	expected_type = /obj/item
	var/list/tool_types //List of tool archetypes.
	var/current_tool_type //The current type of tool this extension is.

/datum/extension/tool/New(var/datum/holder, var/list/init_tool_values)
	tool_types = init_tool_values
	..()

/datum/extension/tool/proc/get_current_tool_type(var/tool_flag)
	LAZYACCESS(tool_values, tool_flag)

/datum/extension/tool/proc/get_tool_quality_descriptor(var/tool_type)
	if(!(tool_type in tool_types))
		return

	switch(tool_types[tool_type])
		if(0.1 to 0.7)
			. = SPAN_WARNING("[pick("crude", "awful", "dysfunctional")]")
		if(0.8 to 1)
			. = pick("decent", "adequate", "useful")
		if(1.1 to INFINITY)
			. = pick("excellent", "exquisite", "great")

/datum/extension/tool/proc/change_tool_type(var/user)
	if(!length(tool_types))
		return
	var/current_type_pos = tool_types.Find(current_tool_type, 1, length(tool_types))
	var/max_list_len = length(tool_types)

	if(current_type_pos < max_list_len)
		current_tool_type = tool_types[current_type_pos+1]
	else if(current_type_pos == max_list_len)
		current_tool_type = tool_types[1]
	to_chat(user, SPAN_NOTICE("You are now using [src] as an [get_tool_quality_descriptor(current_tool_type)] [current_tool_type]."))

/datum/extension/tool/proc/get_tool_speed(var/user)
	return tool_types[current_tool_type]