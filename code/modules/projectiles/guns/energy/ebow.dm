
/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon = 'icons/obj/guns/energy_crossbow.dmi'
	on_mob_icon = 'icons/obj/guns/energy_crossbow.dmi'
	icon_state = "world"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':2,'magnets':2,'esoteric':5}"
	material = MAT_STEEL
	slot_flags = SLOT_BELT
	silenced = 1
	fire_sound = 'sound/weapons/Genhit.ogg'
	projectile_type = /obj/item/projectile/energy/bolt
	max_shots = 8
	self_recharge = 1
	charge_meter = 0
	combustion = 0

/obj/item/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/item/projectile/energy/dart
	max_shots = 5

/obj/item/gun/energy/crossbow/ninja/mounted
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = ITEM_SIZE_LARGE
	force = 10
	one_hand_penalty = 1
	material = MAT_STEEL
	projectile_type = /obj/item/projectile/energy/bolt/large
