//All of the armor below is mostly unused
/obj/item/clothing/suit/armor/officer
	name = "officer jacket"
	desc = "An armored jacket used in special operations."
	icon_state = "detective"
	item_state = "detective"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/tdome/red
	name = "thunderdome suit (red)"
	desc = "Reddish armor."
	icon_state = "tdred"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tdome/green
	name = "thunderdome suit (green)"
	desc = "Pukish armor."
	icon_state = "tdgreen"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	w_class = ITEM_SIZE_NORMAL
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency)
	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SMALL, 
		rad = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.9
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	min_pressure_protection = 0