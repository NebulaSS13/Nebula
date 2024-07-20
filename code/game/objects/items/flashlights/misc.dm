/obj/item/flashlight/upgraded
	name = "\improper LED flashlight"
	desc = "An energy efficient flashlight."
	icon = 'icons/obj/lighting/biglight.dmi'
	flashlight_range = 6
	flashlight_power = 3

/obj/item/flashlight/flashdark
	name = "flashdark"
	desc = "A strange device manufactured with mysterious elements that somehow emits darkness. Or maybe it just sucks in light? Nobody knows for sure."
	icon = 'icons/obj/lighting/flashdark.dmi'
	w_class = ITEM_SIZE_NORMAL
	flashlight_range = 8
	flashlight_power = -6

/obj/item/flashlight/maglight
	name = "maglight"
	desc = "A very, very heavy duty flashlight."
	icon = 'icons/obj/lighting/maglight.dmi'
	_base_attack_force = 10
	attack_verb = list ("smacked", "thwacked", "thunked")
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	light_wedge = LIGHT_NARROW

/******************************Lantern*******************************/
/obj/item/flashlight/lantern
	name = "lantern"
	desc = "A mining lantern."
	icon = 'icons/obj/lighting/lantern.dmi'
	_base_attack_force = 10
	attack_verb = list ("bludgeoned", "bashed", "whack")
	w_class = ITEM_SIZE_NORMAL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	flashlight_range = 2
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE

/obj/item/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_TINY
	flashlight_range = 2
