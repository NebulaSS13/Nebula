/obj/item/clothing/suit/space/void/skrell
	name = "Skrellian voidsuit"
	icon = 'mods/species/bayliens/skrell/icons/clothing/suit/skrell_suit_white.dmi'
	desc = "Seems like a wetsuit with reinforced plating seamlessly attached to it. Very chic."
	allowed = list(
		/obj/item/rcd,
		/obj/item/tool,
		/obj/item/t_scanner,
		/obj/item/storage/ore,
		/obj/item/tank
	)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SMALL,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/space/void/skrell/black
	icon = 'mods/species/bayliens/skrell/icons/clothing/suit/skrell_suit_black.dmi'