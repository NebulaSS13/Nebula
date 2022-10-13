/obj/item/clothing/suit/armor/vest
	name = "armored vest"
	desc = "An armor vest made of synthetic fibers."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/suit/armor/vest.dmi'
	armor = list(
		DEF_MELEE = ARMOR_MELEE_KNIVES,
		DEF_BULLET = ARMOR_BALLISTIC_PISTOL,
		DEF_LASER = ARMOR_LASER_SMALL,
		DEF_ENERGY = ARMOR_ENERGY_MINOR,
		DEF_BOMB = ARMOR_BOMB_PADDED
		)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/suit/armor/vest/heavy
	name = "heavy armor vest"
	desc = "A synthetic armor vest. This one has added webbing and ballistic plates."
	armor = list(
		DEF_MELEE = ARMOR_MELEE_KNIVES,
		DEF_BULLET = ARMOR_BALLISTIC_RESISTANT,
		DEF_LASER = ARMOR_LASER_HANDGUNS,
		DEF_ENERGY = ARMOR_ENERGY_SMALL,
		DEF_BOMB = ARMOR_BOMB_PADDED
		)
	starting_accessories = list(/obj/item/clothing/accessory/storage/pouches)