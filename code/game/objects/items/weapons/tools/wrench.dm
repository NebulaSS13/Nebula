/obj/item/wrench
	name = "wrench"
	desc = "A good, durable combination wrench, with self-adjusting, universal open- and ring-end mechanisms to match a wide variety of nuts and bolts."
	icon = 'icons/obj//items/tool/wrench.dmi'
	icon_state = "wrench"
	item_state = "wrench"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 7
	throwforce = 7.0
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':1,'engineering':1}"
	material = MAT_STEEL
	center_of_mass = @"{'x':17,'y':16}"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/wrench/Initialize()
	icon_state = "wrench[pick("","_red","_black","_green","_blue")]"
	. = ..()