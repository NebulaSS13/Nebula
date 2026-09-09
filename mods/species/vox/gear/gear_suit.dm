/obj/item/clothing/suit/space/void/setup_equip_flags()
	. = ..()
	if(bodytype_equip_flags & BODY_EQUIP_FLAG_EXCLUDE)
		bodytype_equip_flags |= BODY_EQUIP_FLAG_VOX

/obj/item/clothing/suit/space/void/vox
	name = "alien pressure suit"
	icon = 'mods/species/vox/icons/clothing/pressure_suit.dmi'
	desc = "A huge, armoured, pressurized suit, designed for distinctly nonhuman proportions."
	w_class = ITEM_SIZE_NORMAL
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/baton,
		/obj/item/energy_blade/sword,
		/obj/item/handcuffs,
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
	siemens_coefficient = 0.6
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	bodytype_equip_flags = BODY_EQUIP_FLAG_VOX
	flags_inv = (HIDEJUMPSUIT|HIDETAIL)

/obj/item/clothing/suit/space/void/vox/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)

/obj/item/clothing/suit/space/void/vox/carapace
	name = "alien carapace armour"
	color = "#486e6e"
	icon = 'mods/species/vox/icons/clothing/carapace_suit.dmi'
	desc = "An armoured, segmented carapace with glowing purple lights. It looks pretty run-down."
	markings_are_emissive = TRUE
	markings_flags = RESET_COLOR
	markings_state_modifier	= "-lights"
	markings_color = "#00ffff"

/obj/item/clothing/suit/space/void/vox/carapace/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/vox/carapace
	boots  = /obj/item/clothing/shoes/magboots/vox
	tank   = /obj/item/tank/nitrogen/vox

/obj/item/clothing/suit/space/void/vox/stealth
	name = "alien stealth suit"
	icon = 'mods/species/vox/icons/clothing/stealth_suit.dmi'
	desc = "A sleek black suit. It seems to have a tail, and is very heavy."

/obj/item/clothing/suit/space/void/vox/stealth/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/vox/stealth
	boots  = /obj/item/clothing/shoes/magboots/vox
	tank   = /obj/item/tank/nitrogen/vox

/obj/item/clothing/suit/space/void/vox/medic
	name = "alien armour"
	icon = 'mods/species/vox/icons/clothing/medic_suit.dmi'
	desc = "An almost organic-looking nonhuman pressure suit."

/obj/item/clothing/suit/space/void/vox/medic/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/vox/medic
	boots  = /obj/item/clothing/shoes/magboots/vox
	tank   = /obj/item/tank/nitrogen/vox

/obj/item/clothing/suit/armor/vox_scrap
	name = "rusted metal armor"
	desc = "A hodgepodge of various pieces of metal scrapped together into a rudimentary vox-shaped piece of armor."
	icon = 'mods/species/vox/icons/clothing/scrap_suit.dmi'
	allowed = list(/obj/item/gun, /obj/item/tank)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED) //Higher melee armor versus lower everything else.
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_TAIL
	bodytype_equip_flags = BODY_EQUIP_FLAG_VOX
	siemens_coefficient = 1 //It's literally metal
