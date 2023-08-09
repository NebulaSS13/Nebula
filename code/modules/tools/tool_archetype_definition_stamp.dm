/decl/tool_archetype/stamp
	name        = "stamp"
	use_message = "stamping"
	use_sound   = 'sound/effects/stamp.ogg'
	properties  = list(
		TOOL_PROP_COLOR           = "black",
		TOOL_PROP_COLOR_NAME      = "black",
		TOOL_PROP_STAMP_ICON      = "",
		TOOL_PROP_USES            = -1,
		)

/decl/tool_archetype/stamp/proc/decrement_uses(var/mob/user, var/obj/item/tool, var/decrement = 1)
	. = tool.get_tool_property(TOOL_STAMP, TOOL_PROP_USES)
	if(. < 0)
		return TRUE
	. -= decrement

/decl/tool_archetype/stamp/can_use_tool(obj/item/tool, expend_fuel = 1)
	var/uses = tool.get_tool_property(TOOL_STAMP, TOOL_PROP_USES)
	return ..() && ((uses < 0) || (uses - expend_fuel) >= 0)

/decl/tool_archetype/stamp/handle_pre_interaction(mob/user, obj/item/tool, expend_fuel = 1)
	var/uses_left = tool.get_tool_property(TOOL_STAMP, TOOL_PROP_USES)
	if(uses_left < 0)
		return TOOL_USE_SUCCESS //Infinite
	if(uses_left == 0)
		to_chat(user, SPAN_WARNING("\The [tool] is dry!"))
		return TOOL_USE_FAILURE
	return TOOL_USE_SUCCESS

/decl/tool_archetype/stamp/handle_post_interaction(mob/user, obj/item/tool, expend_fuel = 1)
	if(decrement_uses(user, tool, expend_fuel) <= 0)
		to_chat(user, SPAN_WARNING("\The [tool] is dry!"))
	return TOOL_USE_SUCCESS