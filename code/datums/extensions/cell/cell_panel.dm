/datum/extension/loaded_cell/panel
	var/panel_open = FALSE

// We hook the try_unload() proc to do our panel opening and closing.
/datum/extension/loaded_cell/panel/has_tool_unload_interaction(var/obj/item/tool)
	return IS_TOOL(tool, TOOL_SCREWDRIVER)

/datum/extension/loaded_cell/panel/try_unload(var/mob/user, var/obj/item/tool)
	if(!istype(user) || QDELETED(user) || user.incapacitated())
		return FALSE
	if(tool)
		panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] \the [holder]'s battery compartment."))
		var/obj/item/holder_item = holder
		holder_item.update_icon()
		return TRUE
	return panel_open && ..()

/datum/extension/loaded_cell/panel/get_examine_text()
	. = ..() + SPAN_NOTICE("\The [holder]'s battery compartment is [panel_open ? "open" : "closed"]. Use a screwdriver to [panel_open ? "close" : "open"] it.")
