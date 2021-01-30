/obj/item/clothing/suit/space/void/Initialize()
	. = ..()
	if("exclude" in bodytype_restricted)
		LAZYDISTINCTADD(bodytype_restricted, BODYTYPE_VOX)
	else if(length(bodytype_restricted))
		LAZYREMOVE(bodytype_restricted, BODYTYPE_VOX)
	else
		bodytype_restricted = list("exclude", BODYTYPE_VOX)

/obj/item/clothing/suit/space/vox
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
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SMALL, 
		rad = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.6
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	bodytype_restricted = list(BODYTYPE_VOX)
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/space/vox/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)
	bodytype_restricted = list(BODYTYPE_VOX)

/obj/item/clothing/suit/space/vox/carapace
	name = "alien carapace armour"
	icon = 'mods/species/vox/icons/clothing/carapace_suit.dmi'
	desc = "An armoured, segmented carapace with glowing purple lights. It looks pretty run-down."

/obj/item/clothing/suit/space/vox/stealth
	name = "alien stealth suit"
	icon = 'mods/species/vox/icons/clothing/stealth_suit.dmi'
	desc = "A sleek black suit. It seems to have a tail, and is very heavy."

/obj/item/clothing/suit/space/vox/medic
	name = "alien armour"
	icon = 'mods/species/vox/icons/clothing/medic_suit.dmi'
	desc = "An almost organic-looking nonhuman pressure suit."

/obj/item/clothing/suit/armor/vox_scrap
	name = "rusted metal armor"
	desc = "A hodgepodge of various pieces of metal scrapped together into a rudimentary vox-shaped piece of armor."
	icon = 'mods/species/vox/icons/clothing/scrap_suit.dmi'
	allowed = list(/obj/item/gun, /obj/item/tank)
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED) //Higher melee armor versus lower everything else.
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS|SLOT_LOWER_BODY|SLOT_LEGS
	bodytype_restricted = list(BODYTYPE_VOX)
	siemens_coefficient = 1 //Its literally metal

/obj/item/clothing/suit/armor/vox_scrap/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
	