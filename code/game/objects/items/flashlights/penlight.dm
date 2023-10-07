/obj/item/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon = 'icons/obj/lighting/penlight.dmi'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_EARS
	w_class = ITEM_SIZE_TINY
	flashlight_range = 2
	light_wedge = LIGHT_OMNI

/obj/item/flashlight/pen/Initialize()
	set_extension(src, /datum/extension/tool, list(TOOL_PEN = TOOL_QUALITY_DEFAULT), list(TOOL_PEN = list(TOOL_PROP_COLOR = "black", TOOL_PROP_COLOR_NAME = "black")))
	. = ..()
