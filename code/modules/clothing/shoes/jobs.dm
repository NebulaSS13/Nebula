/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots."
	name = "galoshes"
	icon = 'icons/clothing/feet/galoshes.dmi'
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_NOSLIP
	bodytype_restricted = null

/obj/item/clothing/shoes/galoshes/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_shoes_str, 1)

/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Tall synthleather boots with an artificial shine."
	icon = 'icons/clothing/feet/boots.dmi'
	material = /decl/material/solid/leather/synth
	applies_material_colour = TRUE
	force = 3
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_MINOR, 
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.7
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	cold_protection = SLOT_FEET
	body_parts_covered = SLOT_FEET
	heat_protection = SLOT_FEET
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	var/artificail_shine = 20
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = "{'materials':2,'engineering':2}"

/obj/item/clothing/shoes/jackboots/set_material(var/new_material)
	..()
	shine = max(shine, artificail_shine)

/obj/item/clothing/shoes/workboots
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon = 'icons/clothing/feet/boots.dmi'
	material = /decl/material/solid/leather/synth
	color = "#d88d4b"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		laser = ARMOR_LASER_MINOR, 
		energy = ARMOR_ENERGY_SMALL, 
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.7
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = SLOT_FEET
	heat_protection = SLOT_FEET
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = "{'materials':2,'engineering':2}"
