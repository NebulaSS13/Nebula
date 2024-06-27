//All of the armor below is mostly unused
/obj/item/clothing/suit/armor/officer
	name = "officer jacket"
	desc = "An armored jacket used in special operations."
	icon = 'icons/clothing/suits/detective_brown.dmi'
	blood_overlay_type = "coat"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/armor/tdome
	abstract_type = /obj/item/clothing/suit/armor/tdome
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/tdome/red
	name = "thunderdome suit (red)"
	desc = "Reddish armor."
	icon = 'icons/clothing/suits/tdred.dmi'
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tdome/green
	name = "thunderdome suit (green)"
	desc = "Pukish armor."
	icon = 'icons/clothing/suits/tdgreen.dmi'
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon = 'icons/clothing/suits/pirate.dmi'
	w_class = ITEM_SIZE_NORMAL
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/handcuffs,/obj/item/tank/emergency)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SMALL,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.9
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	min_pressure_protection = 0