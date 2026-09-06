/obj/item/salvage/energy
	name = "broken energy weapon"
	icon = /obj/item/gun/energy/laser::icon
	icon_state = /obj/item/gun/energy/laser::icon_state
	abstract_type = /obj/item/salvage/energy

/obj/item/salvage/energy/get_repair_options()
	return ..() + /decl/salvage_repair_option/energy

/obj/item/salvage/energy/ionrifle
	salvaged_type = /obj/item/gun/energy/ionrifle

/obj/item/salvage/energy/laserrifle
	salvaged_type = /obj/item/gun/energy/laser

/obj/item/salvage/energy/laser_retro
	salvaged_type = /obj/item/gun/energy/retro/captain
