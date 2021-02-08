/obj/item/gun/projectile/shotgun
	barrel = /obj/item/firearm_component/barrel/ballistic/shotgun

/obj/item/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced W-T Remmington 29x shotgun is a favourite of police and security forces on many worlds. Useful for sweeping alleys."
	icon = 'icons/obj/guns/shotgun/pump.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':4,'materials':2}"
	receiver = /obj/item/firearm_component/receiver/ballistic/pump
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	one_hand_penalty = 8
	bulk = 6

/obj/item/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon = 'icons/obj/guns/shotgun/doublebarrel.dmi'
	barrel = /obj/item/firearm_component/barrel/ballistic/shotgun/double
	receiver = /obj/item/firearm_component/receiver/ballistic/cycle
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':3,'materials':1}"
	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)

/obj/item/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon = 'icons/obj/guns/shotgun/sawnoff.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	barrel = /obj/item/firearm_component/barrel/ballistic/shotgun/double/sawn

/obj/item/gun/projectile/shotgun/doublebarrel/sawn/empty
	starts_loaded = FALSE