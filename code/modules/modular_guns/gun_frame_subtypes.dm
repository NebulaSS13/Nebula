/obj/item/gun/hand
	name = "handgun"
	icon = 'icons/obj/guns/pistol.dmi'
	force = 5
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':2,'materials':2}"
	firearm_frame_subtype = /obj/item/gun/hand

/obj/item/gun/long
	name = "long gun"
	icon = 'icons/obj/guns/bolt_action.dmi'
	w_class = ITEM_SIZE_HUGE
	force = 5
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':4,'materials':2}"
	firearm_frame_subtype = /obj/item/gun/long

/obj/item/gun/staff
	name = "staff"
	icon = 'icons/obj/guns/staff.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	origin_tech = null
	firearm_frame_subtype = /obj/item/gun/staff

/obj/item/gun/cannon
	name = "cannon"
	origin_tech = "{'combat':7,'materials':2,'esoteric':8}"
	force = 10
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	firearm_frame_subtype = /obj/item/gun/cannon
