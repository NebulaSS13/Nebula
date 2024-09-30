/obj/item/clothing/head/helmet/space/void/ascent
	name = "\improper Ascent voidsuit helmet"
	desc = "An articulated spacesuit helmet of mantid manufacture."
	icon = 'mods/species/ascent/icons/alate_spacesuit/helmet.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	bodytype_equip_flags = BODY_EQUIP_FLAG_ALATE

/obj/item/clothing/suit/space/void/ascent
	name = "\improper Ascent voidsuit"
	desc = "A form-fitting spacesuit of mantid manufacture."
	icon = 'mods/species/ascent/icons/alate_spacesuit/suit.dmi'
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	bodytype_equip_flags = BODY_EQUIP_FLAG_ALATE
	allowed = list(
		/obj/item/clustertool,
		/obj/item/tank/mantid,
		/obj/item/gun/energy/particle/small,
		/obj/item/weldingtool/electric/mantid,
		/obj/item/multitool/mantid,
		/obj/item/stack/medical/resin,
		/obj/item/chems/drinks/cans/waterbottle/ascent
	)