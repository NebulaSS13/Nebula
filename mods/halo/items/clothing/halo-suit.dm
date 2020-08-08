
/*UNSC*/

/*URF*/

/*URFC*/

/obj/item/clothing/suit/armor/special/urfc
	name = "URFC Rifleman Armour"
	desc = "Somewhat expensive and hand crafted, this armor is the pinnacle of the work force of the URF and it's many workers. Filled with pouches and storage compartments, while still keeping a scary amount of both mobility and protection. An ideal collage of the strengths of the URF, but with the added protection found only in high tier UNSC equipment. It's quite comfy, and is space proof."
	icon = 'icons/clothing/urf_commando.dmi'
	item_state = "rifleman_a_worn"
	icon_state = "rifleman_a_obj"
	icon_override = 'icons/clothing/urf_commando.dmi'
	blood_overlay_type = "armor"
	item_state_slots = list(slot_l_hand_str = "urf_armour", slot_r_hand_str = "urf_armour")
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 100, rad = 25)
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE