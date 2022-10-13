
/obj/item/clothing/suit/space/void/swat
	name = "\improper SWAT suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon = 'icons/clothing/spacesuit/void/deathsquad/suit.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/handcuffs,/obj/item/tank)
	armor = list(
		DEF_MELEE = ARMOR_MELEE_RESISTANT,
		DEF_BULLET = ARMOR_BALLISTIC_RESISTANT,
		DEF_LASER = ARMOR_LASER_MAJOR,
		DEF_ENERGY = ARMOR_ENERGY_MINOR,
		DEF_BOMB = ARMOR_BOMB_PADDED,
		DEF_BIO = ARMOR_BIO_SHIELDED,
		DEF_RAD = ARMOR_RAD_SMALL
		)
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0.6

/obj/item/clothing/suit/space/void/swat/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)
