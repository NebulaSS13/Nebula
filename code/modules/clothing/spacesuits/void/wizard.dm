//Wizard Rig
/obj/item/clothing/head/helmet/space/void/wizard
	name = "gem-encrusted voidsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon = 'icons/clothing/spacesuit/void/wizard/helmet.dmi'
	material = /decl/material/solid/gemstone/crystal
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.7
	wizard_garb = 1

/obj/item/clothing/suit/space/void/wizard
	name = "gem-encrusted voidsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	icon = 'icons/clothing/spacesuit/void/wizard/suit.dmi'
	w_class = ITEM_SIZE_LARGE //normally voidsuits are bulky but this one is magic I suppose
	material = /decl/material/solid/gemstone/crystal
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.7
	wizard_garb = 1
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETAIL //For gloves.
	body_parts_covered = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_LEGS | SLOT_FEET | SLOT_ARMS | SLOT_TAIL
	cold_protection = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_LEGS | SLOT_FEET | SLOT_ARMS | SLOT_TAIL

/obj/item/clothing/suit/space/void/wizard/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)

/obj/item/clothing/gloves/wizard
	name = "mystical gloves"
	desc = "Reinforced, gem-studded gloves that radiate energy. They look like they go along with a matching voidsuit."
	color = COLOR_VIOLET
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_HANDS
	cold_protection =    SLOT_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	bodytype_equip_flags = null
	gender = PLURAL
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	material = /decl/material/solid/gemstone/crystal
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.7
