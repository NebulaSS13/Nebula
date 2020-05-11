//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon = 'icons/clothing/spacesuit/void/merc/helmet.dmi'
	on_mob_icon = 'icons/clothing/spacesuit/void/merc/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.3
	camera = /obj/machinery/camera/network/mercenary

/obj/item/clothing/suit/space/void/merc
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	icon = 'icons/clothing/spacesuit/void/merc/suit.dmi'
	on_mob_icon = 'icons/clothing/spacesuit/void/merc/suit.dmi'
	w_class = ITEM_SIZE_LARGE //normally voidsuits are bulky but the merc voidsuit is 'advanced' or something
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/void/merc/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/space/void/merc/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/merc
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen