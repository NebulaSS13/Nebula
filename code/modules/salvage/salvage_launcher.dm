/obj/item/salvage/launcher
	name = "broken grenade launcher"
	icon = /obj/item/gun/launcher/grenade::icon
	icon_state = /obj/item/gun/launcher/grenade::icon_state
	abstract_type = /obj/item/salvage/launcher

/obj/item/salvage/launcher/get_repair_options()
	return ..() + /decl/salvage_repair_option/launcher

/obj/item/salvage/launcher/grenade
	salvaged_type = /obj/item/gun/launcher/grenade

/obj/item/salvage/launcher/dartgun
	salvaged_type = /obj/item/gun/projectile/dartgun
