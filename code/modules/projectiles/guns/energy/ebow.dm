
/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon = 'icons/obj/guns/energy_crossbow.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"combat":2,"magnets":2,"esoteric":5}'
	material = /decl/material/solid/metal/steel
	slot_flags = SLOT_LOWER_BODY
	silencer = TRUE
	fire_sound = 'sound/weapons/Genhit.ogg'
	projectile_type = /obj/item/projectile/energy/bolt
	max_shots = 8
	self_recharge = 1
	charge_meter = 0
	combustion = 0

/obj/item/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = ITEM_SIZE_LARGE
	_base_attack_force = 10
	one_hand_penalty = 1
	material = /decl/material/solid/metal/steel
	projectile_type = /obj/item/projectile/energy/bolt/large
