/obj/item/gun/hand
	name = "handgun"
	icon = 'icons/obj/guns/pistol.dmi'
	force = 5
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':2,'materials':2}"
	grip = /obj/item/firearm_component/grip
	firearm_frame_subtype = /obj/item/gun/hand

/obj/item/gun/long
	name = "long gun"
	icon = 'icons/obj/guns/bolt_action.dmi'
	w_class = ITEM_SIZE_HUGE
	force = 5
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':4,'materials':2}"
	grip = /obj/item/firearm_component/grip/long
	stock = /obj/item/firearm_component/stock
	firearm_frame_subtype = /obj/item/gun/long

/obj/item/gun/staff
	name = "staff"
	icon = 'icons/obj/guns/staff.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	origin_tech = null
	grip = /obj/item/firearm_component/grip/staff
	firearm_frame_subtype = /obj/item/gun/staff

/obj/item/gun/cannon
	name = "cannon"
	origin_tech = "{'combat':7,'materials':2,'esoteric':8}"
	force = 10
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	grip = /obj/item/firearm_component/grip/cannon
	stock = /obj/item/firearm_component/stock/cannon
	firearm_frame_subtype = /obj/item/gun/cannon
