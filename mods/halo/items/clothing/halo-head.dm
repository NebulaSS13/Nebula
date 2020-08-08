/*UNSC*/

/obj/item/clothing/head/helmet/marine
	name = "Olive Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Helmet"
	icon_state = "helmet_novisor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/marine/medic
	name = "Olive Camo CH251 Helmet Medic"
	desc = "A medic variant of the standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	item_state = "CH252 Helmet Medic"
	icon_state = "helmet novisor medic_obj"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/medic/visor
	name = "Olive Camo CH251-V Helmet Medic"
	desc = "A medic variant of the standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	item_state = "CH252 Visor Helmet Medic"
	icon_state = "helmet medic_obj"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/visor
	name = "Olive Camo CH251-V Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Visor Helmet"
	icon_state = "helmet"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/brown
	name = "Brown Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Helmet B"
	icon_state = "helmet_b"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/medic/brown
	name = "Brown Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Helmet Medic B"
	icon_state = "helmet medic-b_obj"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/medic/brownvisor
	name = "Brown Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Visor Helmet Medic B"
	icon_state = "helmet medic-b_obj"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/brownvisor
	name = "Brown Camo CH251-V Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Visor Helmet B"
	icon_state = "helmet_b"
	body_parts_covered = HEAD|EYES

/*URF*/

/obj/item/clothing/head/helmet/lighturf/brown
	name = "LV28L Armored Helmet - Brown Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_brown"
	icon_state = "l_innie_helmet_obj_brown"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/blue
	name = "LV28L Armored Helmet - Blue Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_blue"
	icon_state = "l_innie_helmet_obj_blue"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/green
	name = "LV28L Armored Helmet - Green Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_green"
	icon_state = "l_innie_helmet_obj_green"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/black
	name = "LV28L Armored Helmet - Black Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_black"
	icon_state = "l_innie_helmet_obj_black"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/white
	name = "LV28L Armored Helmet - White Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_white"
	icon_state = "l_innie_helmet_obj_white"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/brown
	name = "LV28D Armored Helmet - Brown Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_brown"
	icon_state = "m_innie_helmet_obj_brown"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	slowdown_general = 0.2
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/blue
	name = "LV28D Armored Helmet - Blue Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_blue"
	icon_state = "m_innie_helmet_obj_blue"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	slowdown_general = 0.2
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/green
	name = "LV28D Armored Helmet - Green Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_green"
	icon_state = "m_innie_helmet_obj_green"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	slowdown_general = 0.2
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/black
	name = "LV28D Armored Helmet - Black Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_black"
	icon_state = "m_innie_helmet_obj_black"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	slowdown_general = 0.2
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/white
	name = "LV28D Armored Helmet - White Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_white"
	icon_state = "m_innie_helmet_obj_white"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	slowdown_general = 0.2
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/brown
	name = "LV28H Armored Helmet - Brown Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_brown"
	icon_state = "h_innie_helmet_obj_brown"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown_general = 1
	siemens_coefficient = 1.5
	armor_thickness = 20
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 20, rad = 15)
	gas_transfer_coefficient = 0.90
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/blue
	name = "LV28H Armored Helmet - Blue Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_blue"
	icon_state = "h_innie_helmet_obj_blue"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown_general = 1
	siemens_coefficient = 1.5
	armor_thickness = 20
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 20, rad = 15)
	gas_transfer_coefficient = 0.90
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/green
	name = "LV28H Armored Helmet - Green Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_green"
	icon_state = "h_innie_helmet_obj_green"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown_general = 1
	siemens_coefficient = 1.5
	armor_thickness = 20
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 20, rad = 15)
	gas_transfer_coefficient = 0.90
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/black
	name = "LV28H Armored Helmet - Black Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_black"
	icon_state = "h_innie_helmet_obj_black"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown_general = 1
	siemens_coefficient = 1.5
	armor_thickness = 20
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 20, rad = 15)
	gas_transfer_coefficient = 0.90
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/white
	name = "LV28H Armored Helmet - White Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-25 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_white"
	icon_state = "h_innie_helmet_obj_white"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown_general = 1
	siemens_coefficient = 1.5
	armor_thickness = 20
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 20, rad = 15)
	gas_transfer_coefficient = 0.90
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical


/*URFC*/

/obj/item/clothing/head/helmet/urfc
	name = "URFC Rifleman Helmet"
	desc = "Somewhat expensive and hand crafted, this helmet has been clearly converted from an old spec ops grade EVA combat helmet as the foundation. Despite the old age, a lot of work has been put into adding additional armor and refining the base processes, such as an internal oxygen filter and the replacement of the visor. It's quite heavy, but a lot of soft material has been added to the inside to make the metal more comfy. Outdated, but can be expected in combat engagements to perform on par with modern equipment, due to the extensive modifications."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "rifleman_worn"
	icon_state = "rifleman_helmet"
	item_state_slots = list(slot_l_hand_str = "urf_helmet", slot_r_hand_str = "urf_helmet")
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
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
	armor_thickness = 20

	integrated_hud = /obj/item/clothing/glasses/hud/tactical