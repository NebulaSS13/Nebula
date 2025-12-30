/obj/item/clustertool
	name = "alien clustertool"
	desc = "A bewilderingly complex knot of tool heads."
	icon = 'mods/species/skrell/icons/gear/gear_rig.dmi'
	icon_state = "clustertool"
	w_class = ITEM_SIZE_SMALL

/obj/item/clustertool/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool/variable, list(
		TOOL_WRENCH =      TOOL_QUALITY_GOOD,
		TOOL_WIRECUTTERS = TOOL_QUALITY_GOOD,
		TOOL_CROWBAR =     TOOL_QUALITY_GOOD,
		TOOL_SCREWDRIVER = TOOL_QUALITY_GOOD
	))

/obj/item/clustertool/on_update_icon()
	. = ..()
	icon_state = initial(icon_state)
	if(IS_WRENCH(src))
		icon_state = "[icon_state]-wrench"
	else if(IS_WIRECUTTER(src))
		icon_state = "[icon_state]-wirecutters"
	else if(IS_CROWBAR(src))
		icon_state = "[icon_state]-crowbar"
	else if(IS_SCREWDRIVER(src))
		icon_state = "[icon_state]-screwdriver"
