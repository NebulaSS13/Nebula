/obj/item/gun/energy/laser/aep7
	name = "AEP7 Laser Pistol"
	desc = "An AEP7 Laser Pistol."
	icon = 'mods/content/fallout/guns/icons/laser/aep7.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	max_shots = 12
	projectile_type = /obj/item/projectile/beam/laserpistol

/obj/item/gun/energy/laser/aep7/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
    return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)


/obj/item/gun/energy/laser/aer9
	name = "AER9 Laser Rifle"
	desc = "An AER9 laser rifle."
	icon = 'mods/content/fallout/guns/icons/laser/aer9.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	max_shots = 10			//Why would you use the weaker versions when you have the stronger ones? Answer: Ammo and availability.
	projectile_type = /obj/item/projectile/beam/laserrifleweak

/obj/item/gun/energy/laser/aer9/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
    return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)


/obj/item/gun/energy/laser/aer12
	name = "AER12 Laser Rifle"
	desc = "An AER12 laser rifle."
	icon = 'mods/content/fallout/guns/icons/laser/aer12.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	max_shots = 7
	projectile_type = /obj/item/projectile/beam/laserriflenormal

/obj/item/gun/energy/laser/aer12/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
    return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)

/obj/item/gun/energy/laser/aer14
	name = "AER14 Laser Rifle"
	desc = "An AER14 laser rifle."
	icon = 'mods/content/fallout/guns/icons/laser/aer14.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	max_shots = 5
	projectile_type = /obj/item/projectile/beam/laserriflenormal

/obj/item/gun/energy/laser/aer14/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
    return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)
