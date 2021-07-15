/obj/item/clustertool
	name = "alien clustertool"
	desc = "A bewilderingly complex knot of tool heads."
	icon = 'mods/species/ascent/icons/ascent.dmi'
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
	icon_state = initial(icon_state)
	if(isWrench(src))
		icon_state = "[icon_state]-wrench"
	else if(isWirecutter(src))
		icon_state = "[icon_state]-wirecutters"
	else if(isCrowbar(src))
		icon_state = "[icon_state]-crowbar"
	else if(isScrewdriver(src))
		icon_state = "[icon_state]-screwdriver"
