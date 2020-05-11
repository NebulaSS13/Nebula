//Wizard Rig
/obj/item/clothing/head/helmet/space/void/wizard
	name = "gem-encrusted voidsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon = 'icons/clothing/spacesuit/void/wizard/helmet.dmi'
	on_mob_icon = 'icons/clothing/spacesuit/void/wizard/helmet.dmi'
	unacidable = 1 //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.7
	sprite_sheets_obj = null
	wizard_garb = 1

/obj/item/clothing/suit/space/void/wizard
	name = "gem-encrusted voidsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	icon = 'icons/clothing/spacesuit/void/wizard/suit.dmi'
	on_mob_icon = 'icons/clothing/spacesuit/void/wizard/suit.dmi'
	w_class = ITEM_SIZE_LARGE //normally voidsuits are bulky but this one is magic I suppose
	unacidable = 1
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.7
	sprite_sheets_obj = null
	wizard_garb = 1
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETAIL //For gloves.
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS

/obj/item/clothing/suit/space/void/wizard/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/gloves/wizard
	name = "mystical gloves"
	desc = "Reinforced, gem-studded gloves that radiate energy. They look like they go along with a matching voidsuit."
	icon_state = "mystical"
	item_state = "purplegloves"
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = HANDS
	cold_protection =    HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	bodytype_restricted = null
	gender = PLURAL
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	unacidable = 1
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.7
