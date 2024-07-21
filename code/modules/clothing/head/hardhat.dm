/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon = 'icons/clothing/head/hardhat/yellow.dmi'
	action_button_name = "Toggle Headlamp"
	brightness_on = 4 //luminosity when on
	w_class = ITEM_SIZE_NORMAL
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_MINOR,
		ARMOR_RAD = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.9
	light_wedge = LIGHT_WIDE
	heat_protection = SLOT_HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"materials":1,"engineering":1,"combat":1}'
	replaced_in_loadout = FALSE
	_base_attack_force = 5

/obj/item/clothing/head/hardhat/orange
	icon = 'icons/clothing/head/hardhat/orange.dmi'

/obj/item/clothing/head/hardhat/red
	icon = 'icons/clothing/head/hardhat/red.dmi'

/obj/item/clothing/head/hardhat/white
	icon = 'icons/clothing/head/hardhat/white.dmi'

/obj/item/clothing/head/hardhat/dblue
	icon = 'icons/clothing/head/hardhat/blue.dmi'

/obj/item/clothing/head/hardhat/ems
	name = "\improper EMS helmet"
	desc = "A polymer helmet worn by EMTs throughout human space to protect their head. This one comes with an attached flashlight and has 'Medic' written on its back in blue lettering."
	icon = 'icons/clothing/head/hardhat/medic.dmi'
	w_class = ITEM_SIZE_NORMAL
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/head/hardhat/firefighter
	name = "firefighter helmet"
	desc = "A complete, face covering helmet specially designed for firefighting. It is airtight and has a port for internals."
	icon = 'icons/clothing/head/hardhat/firefighter.dmi'
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	permeability_coefficient = 0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCK_ALL_HAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/clothing/head/hardhat/damage_control
	name = "damage control helmet"
	desc = "A helmet commonly used by engineers and first responders throughout the human space. Comes with a built-in flashlight."
	icon = 'icons/clothing/head/hardhat/damage_control.dmi'
	flags_inv = HIDEEARS|BLOCK_HEAD_HAIR

/obj/item/clothing/head/hardhat/ems/dc_light
	name = "light damage control helmet"
	desc = "A lighter polymer helmet commonly used by engineers and first responders throughout the human space. It comes with a built-in flashlight and has 'Damage Control' written on its back in yellow lettering."
	icon = 'icons/clothing/head/hardhat/damage_control_light.dmi'
