/obj/item/clothing/suit/armor/vest/heavy/warden
	starting_accessories = list(/obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/warden)

/obj/item/clothing/suit/armor/vest/heavy/hos
	starting_accessories = list(/obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/hos)

/obj/item/clothing/suit/armor/pcarrier/detective
	color = COLOR_DARK_GREEN_GRAY
	starting_accessories = list(/obj/item/clothing/accessory/armorplate, /obj/item/clothing/accessory/badge)

/obj/item/clothing/suit/armor/pcarrier/tactical
	name = "tactical plate carrier"
	color = COLOR_TAN
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/tactical, /obj/item/clothing/accessory/storage/pouches/large/tan)

/obj/item/clothing/suit/armor/warden
	name = "warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "warden_jacket"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS