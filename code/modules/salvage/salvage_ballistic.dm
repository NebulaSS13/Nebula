/obj/item/salvage/ballistic
	name = "broken ballistic weapon"
	icon = /obj/item/gun/projectile/automatic/assault_rifle::icon
	icon_state = /obj/item/gun/projectile/automatic/assault_rifle::icon_state
	abstract_type = /obj/item/salvage/ballistic

/obj/item/salvage/ballistic/get_repair_options()
	return ..() + /decl/salvage_repair_option/component

/obj/item/salvage/ballistic/assault
	salvaged_type = /obj/item/gun/projectile/automatic/assault_rifle

/obj/item/salvage/ballistic/pistol
	salvaged_type = /obj/item/gun/projectile/pistol

/obj/item/salvage/ballistic/smg
	salvaged_type = /obj/item/gun/projectile/automatic/smg

/obj/item/salvage/ballistic/shotgun_pump
	salvaged_type = /obj/item/gun/projectile/shotgun/pump

/obj/item/salvage/ballistic/shotgun_doublebarrel
	salvaged_type = /obj/item/gun/projectile/shotgun/doublebarrel

