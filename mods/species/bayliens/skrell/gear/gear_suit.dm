/obj/item/clothing/suit/space/void/skrell
	name = "Skrellian voidsuit"
	icon = 'mods/species/bayliens/skrell/icons/clothing/suit/skrell_suit_white.dmi'
	desc = "Seems like a wetsuit with reinforced plating seamlessly attached to it. Very chic."
	allowed = list(
		/obj/item/rcd,
		/obj/item/pickaxe,
		/obj/item/t_scanner,
		/obj/item/storage/ore,
		/obj/item/tank
	)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
		)
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/space/void/skrell/black
	icon = 'mods/species/bayliens/skrell/icons/clothing/suit/skrell_suit_black.dmi'