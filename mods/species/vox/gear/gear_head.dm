/obj/item/clothing/head/helmet/space/void/setup_equip_flags()
	. = ..()
	if(bodytype_equip_flags & BODY_EQUIP_FLAG_EXCLUDE)
		bodytype_equip_flags |= BODY_EQUIP_FLAG_VOX

/obj/item/clothing/head/helmet/space/void/vox
	name = "alien helmet"
	icon = 'mods/species/vox/icons/clothing/pressure_helmet.dmi'
	desc = "A huge, armoured, pressurized helmet. Looks like an ancient human diving suit."
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SMALL,
		ARMOR_RAD = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.6
	item_flags = 0
	flags_inv = 0
	bodytype_equip_flags = BODY_EQUIP_FLAG_VOX

/obj/item/clothing/head/helmet/space/void/vox/carapace
	name = "alien visor"
	icon = 'mods/species/vox/icons/clothing/carapace_helmet.dmi'
	desc = "A glowing visor. The light slowly pulses, and seems to follow you."
	color = "#486e6e"
	markings_are_emissive = TRUE
	markings_flags = RESET_COLOR
	markings_state_modifier	= "-lights"
	markings_color = "#00ffff"

/obj/item/clothing/head/helmet/space/void/vox/stealth
	name = "alien stealth helmet"
	icon = 'mods/species/vox/icons/clothing/stealth_helmet.dmi'
	desc = "A smoothly contoured, matte-black alien helmet."

/obj/item/clothing/head/helmet/space/void/vox/medic
	name = "alien goggled helmet"
	icon = 'mods/species/vox/icons/clothing/medic_helmet.dmi'
	desc = "An alien helmet with enormous goggled lenses."
