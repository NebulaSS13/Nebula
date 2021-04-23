/obj/item/power_tool
	var/tool_flags //bitflags for tools, listed in defines/items_tools.dm
	var/tool_change_sound = 'sound/items/Ratchet.ogg' //the sound we use when change_type is called.

/obj/item/power_tool/attack_self(var/mob/user)
	change_type()

/obj/item/power_tool/proc/change_type()
	return

/obj/item/power_tool/hydraulic_cutter
	name = "hydraulic cutter"
	desc = "A universal, miniturized hydraulic tool with interchangable heads for either prying or cutting. But not both at the same time."
	icon = 'icons/obj/items/tool/cutter.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	material_force_multiplier = 0.2
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':3,'engineering':3}"
	material = /decl/material/solid/metal/steel
	center_of_mass = @"{'x':17,'y':16}"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	drop_sound = 'sound/foley/bardrop1.ogg'
	tool_flags = TOOL_FLAG_CROWBAR

/obj/item/power_tool/hydraulic_cutter/change_type()
	if(tool_flags & TOOL_FLAG_CROWBAR)
		tool_flags = TOOL_FLAG_WIRECUTTER
	else
		tool_flags = TOOL_FLAG_CROWBAR
	update_icon()
	playsound(src.loc, tool_change_sound, 75, 1)

/obj/item/power_tool/hydraulic_cutter/on_update_icon()
	cut_overlays()
	if(tool_flags & TOOL_FLAG_CROWBAR)
		add_overlay(image(icon, "pry"))
	else
		add_overlay(image(icon, "cut"))

/obj/item/power_tool/power_drill
	name = "power drill"
	desc = "A universal power drill, with heads for most common screw and bolt types."
	icon = 'icons/obj/items/tool/powerdrill.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	material_force_multiplier = 0.2
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':3,'engineering':3}"
	material = /decl/material/solid/metal/steel
	center_of_mass = @"{'x':17,'y':16}"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	drop_sound = 'sound/foley/bardrop1.ogg'
	tool_flags = TOOL_FLAG_WRENCH

/obj/item/power_tool/power_drill/change_type()
	if(tool_flags & TOOL_FLAG_WRENCH)
		tool_flags = TOOL_FLAG_SCREWDRIVER
	else
		tool_flags = TOOL_FLAG_WRENCH
	update_icon()
	playsound(src.loc, tool_change_sound, 75, 1)

/obj/item/power_tool/power_drill/on_update_icon()
	cut_overlays()
	if(tool_flags & TOOL_FLAG_WRENCH)
		add_overlay(image(icon, "bolt"))
	else
		add_overlay(image(icon, "screw"))