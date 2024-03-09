/decl/tool_archetype/welder
	name         = "welder"
	tool_sound   = list('sound/items/Welder.ogg','sound/items/Welder2.ogg')
	codex_key    = TOOL_CODEX_WELDER
	tool_message = "welding"

/decl/tool_archetype/welder/handle_pre_interaction(var/mob/user, var/obj/item/tool, var/expend_fuel = 0)
	var/obj/item/weldingtool/welder = tool
	if(!istype(tool) || !expend_fuel)
		return TOOL_USE_SUCCESS // Let's assume that this tool value is only given to non-welders if they should bypass fuel usage.
	if(!welder.isOn())
		to_chat(user, SPAN_WARNING("\The [welder] needs to be turned on to begin this task."))
		return TOOL_USE_FAILURE
	if(!welder.weld(expend_fuel, user))
		to_chat(user, SPAN_WARNING("You need more fuel to begin this task."))
		return TOOL_USE_FAILURE
	return TOOL_USE_SUCCESS

/decl/tool_archetype/welder/handle_post_interaction(var/mob/user, var/obj/item/tool, var/expend_fuel = 0)
	var/obj/item/weldingtool/welder = tool
	if(!istype(tool) || !expend_fuel)
		return TOOL_USE_SUCCESS
	if(!welder.isOn())
		to_chat(user, SPAN_WARNING("\The [welder] needs to be turned on to finish this task."))
		return TOOL_USE_FAILURE
	if(!welder.weld(expend_fuel, user))
		to_chat(user, SPAN_WARNING("You need more fuel to finish this task."))
		return TOOL_USE_FAILURE
	return TOOL_USE_SUCCESS
