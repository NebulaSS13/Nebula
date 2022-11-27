/decl/tool_archetype
	var/name = "tool"                             // Noun for the tool.
	var/article = TRUE                            // Boolean value for prefixing 'a' or 'an' to the tool name.
	var/use_sound = 'sound/items/Deconstruct.ogg' // Sound or list of sounds to play when this tool is used.
	var/config_sound = 'sound/items/Ratchet.ogg'  // Sound or list of sounds to play when this tool is selected as a variable tool head.
	var/codex_key
	var/use_message = "adjusting"
	var/list/properties                           // A list of named tool specific properties this tool offers, and the default value of that property, if applicable. 

/decl/tool_archetype/proc/can_use_tool(var/obj/item/tool, var/expend_fuel = 0)
	return istype(tool) && tool.get_tool_quality(type) > 0

/decl/tool_archetype/proc/handle_pre_interaction(var/mob/user, var/obj/item/tool, var/expend_fuel = 0)
	return TOOL_USE_SUCCESS

/decl/tool_archetype/proc/handle_post_interaction(var/mob/user, var/obj/item/tool, var/expend_fuel = 0)
	return TOOL_USE_SUCCESS

/decl/tool_archetype/proc/get_tool_quality_descriptor(var/value)

	if(value < TOOL_QUALITY_WORST)
		return

	switch(value)
		if(TOOL_QUALITY_GOOD to INFINITY)
			. = "excellent"
		if(TOOL_QUALITY_DECENT to TOOL_QUALITY_GOOD)
			. = "decent"
		if(TOOL_QUALITY_DEFAULT to TOOL_QUALITY_DECENT)
			. = "adequate"
		if(TOOL_QUALITY_MEDIOCRE to TOOL_QUALITY_DEFAULT)
			. = "mediocre"
		if(TOOL_QUALITY_BAD to TOOL_QUALITY_MEDIOCRE)
			. = "bad"
		if(0 to TOOL_QUALITY_BAD)
			. = "awful"
			
	if(.)
		if(article)
			. = "\a [.]"
		. = "[.] [name]"
		if(value < TOOL_QUALITY_MEDIOCRE)
			. = SPAN_WARNING(.)
		else if(value > TOOL_QUALITY_DECENT)
			. = SPAN_NOTICE(.)
