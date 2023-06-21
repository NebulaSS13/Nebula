/decl/tool_archetype/pen
	name        = "pen"
	use_message = "writing"
	use_sound   = list('sound/effects/pen1.ogg','sound/effects/pen2.ogg')
	properties  = list(
		TOOL_PROP_COLOR           = "black",
		TOOL_PROP_COLOR_NAME      = "black",
		TOOL_PROP_PEN_FLAG        = 0,
		TOOL_PROP_USES            = -1,
		TOOL_PROP_PEN_SIG         = null,
		TOOL_PROP_PEN_SHADE_COLOR = "black",
		TOOL_PROP_PEN_FONT        = PEN_FONT_DEFAULT,
		)

/**Returns the signature to use when signing with a pen. Meant to help deal with chameleon pens and regular pens. */
/decl/tool_archetype/pen/proc/get_signature(var/mob/user, var/obj/item/tool)
	. = tool.get_tool_property(TOOL_PEN, TOOL_PROP_PEN_SIG)
	if(!.)
		if(user?.real_name)
			. = user.real_name
		else
			. = "Anonymous"

/decl/tool_archetype/pen/proc/decrement_uses(var/mob/user, var/obj/item/tool, var/decrement = 1)
	. = tool.get_tool_property(TOOL_PEN, TOOL_PROP_USES)
	if(. < 0)
		return TRUE
	. -= decrement
	tool.set_tool_property(TOOL_PEN, TOOL_PROP_USES, max(0, .)) //Prevent negatives and turning the pen into an infinite uses pen
	if(. <= 0 && (tool.get_tool_property(TOOL_PEN, TOOL_PROP_PEN_FLAG) & PEN_FLAG_DEL_EMPTY))
		qdel(tool)

/**Toggles the active/inactive state of some pens */
/decl/tool_archetype/pen/proc/toggle_active(var/mob/user, var/obj/item/pen/tool)
	//only a single type of pen can toggle
	if(istype(tool, /obj/item/pen))
		tool.toggle()

/decl/tool_archetype/pen/can_use_tool(obj/item/tool, expend_fuel = 1)
	var/uses = tool.get_tool_property(TOOL_PEN, TOOL_PROP_USES)
	return ..() && ((uses < 0) || (uses - expend_fuel) >= 0)

/decl/tool_archetype/pen/handle_pre_interaction(mob/user, obj/item/tool, expend_fuel = 1)
	var/uses_left = tool.get_tool_property(TOOL_PEN, TOOL_PROP_USES)
	if(uses_left < 0)
		return TOOL_USE_SUCCESS //Infinite
	if(uses_left == 0)
		to_chat(user, SPAN_WARNING("\The [tool] is spent."))
		return TOOL_USE_FAILURE
	return TOOL_USE_SUCCESS

/decl/tool_archetype/pen/handle_post_interaction(mob/user, obj/item/tool, expend_fuel = 1)
	if(decrement_uses(user, tool, expend_fuel) <= 0)
		to_chat(user, SPAN_WARNING("You used up your [tool]!"))
	return TOOL_USE_SUCCESS