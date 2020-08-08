/*UNSC*/

/*URF*/

/*URFC*/

/obj/item/clothing/head/helmet/urfc
	name = "URFC Rifleman Helmet"
	desc = "Somewhat expensive and hand crafted, this helmet has been clearly converted from an old spec ops grade EVA combat helmet as the foundation. Despite the old age, a lot of work has been put into adding additional armor and refining the base processes, such as an internal oxygen filter and the replacement of the visor. It's quite heavy, but a lot of soft material has been added to the inside to make the metal more comfy. Outdated, but can be expected in combat engagements to perform on par with modern equipment, due to the extensive modifications."
	icon = 'icons/clothing/urf_commando.dmi'
	icon_override = 'icons/clothing/urf_commando.dmi'
	item_state = "rifleman_worn"
	icon_state = "rifleman_helmet"
	item_state_slots = list(slot_l_hand_str = "urf_helmet", slot_r_hand_str = "urf_helmet")
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 60, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 100, rad = 25)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0