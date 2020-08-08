/*GLOVES*/

/obj/item/clothing/gloves/thick/unsc //Combined effect of SWAT gloves and insulated gloves
	desc = "Standard Issue UNSC Marine Gloves."
	name = "UNSC Combat gloves"
	icon_state = "unsc_gloves"
	item_state = "unsc_gloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	body_parts_covered = HANDS
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 15, bio = 0, rad = 0)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/thick/urf //Combined effect of SWAT gloves and insulated gloves
	desc = "Standard Issue URF Combat Gloves."
	name = "URF Combat gloves"
	item_state = "urfgloves_worn"
	icon_state = "urfgloves_obj"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	body_parts_covered = HANDS
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 15, bio = 0, rad = 0)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

