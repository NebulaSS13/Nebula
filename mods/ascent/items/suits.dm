/obj/item/clothing/head/helmet/space/void/ascent
	name = "\improper Ascent voidsuit helmet"
	desc = "An articulated spacesuit helmet of mantid manufacture."
	icon_state = "ascent_general"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	bodytype_restricted = list(BODYTYPE_MANTID_SMALL)
	sprite_sheets = list(BODYTYPE_MANTID_SMALL = 'mods/ascent/icons/species/mantid/onmob_head_alate.dmi')

/obj/item/clothing/suit/space/void/ascent
	name = "\improper Ascent voidsuit"
	desc = "A form-fitting spacesuit of mantid manufacture."
	icon_state = "ascent_general"
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	bodytype_restricted = list(BODYTYPE_MANTID_SMALL)
	sprite_sheets = list(BODYTYPE_MANTID_SMALL = 'mods/ascent/icons/species/mantid/onmob_suit_alate.dmi')
	allowed = list(
		/obj/item/clustertool,
		/obj/item/tank/mantid,
		/obj/item/gun/energy/particle/small,
		/obj/item/weldingtool/electric/mantid,
		/obj/item/multitool/mantid,
		/obj/item/stack/medical/resin,
		/obj/item/chems/food/drinks/cans/waterbottle/ascent
	)