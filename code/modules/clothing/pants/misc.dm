/obj/item/clothing/pants/fire_overpants
	name = "fire overpants"
	desc = "some overpants made of fire-resistant synthetic fibers. To be worn over the uniform."
	icon = 'icons/clothing/pants/overpants.dmi'
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	armor = list(ARMOR_LASER = ARMOR_LASER_MINOR, ARMOR_ENERGY = ARMOR_ENERGY_MINOR, ARMOR_BOMB = ARMOR_BOMB_MINOR)
	body_parts_covered = SLOT_LOWER_BODY | SLOT_LEGS | SLOT_TAIL
	accessory_slowdown = 0.5
	heat_protection = SLOT_LOWER_BODY | SLOT_LEGS | SLOT_TAIL
	cold_protection = SLOT_LOWER_BODY | SLOT_LEGS | SLOT_TAIL
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	accessory_slot = ACCESSORY_SLOT_DECOR


/obj/item/clothing/pants/mustard
	name = "mustard pants"
	desc = "A pair of mustard-yellow pants."
	icon = 'icons/clothing/pants/pants_mustard.dmi'

/obj/item/clothing/pants/mustard/overalls
	starting_accessories = list(
		/obj/item/clothing/shirt/button/blue,
		/obj/item/clothing/suit/apron/overalls/laborer
	)

/obj/item/clothing/pants/mankini
	name = "mankini"
	desc = "No honest man would wear this abomination."
	icon = 'icons/clothing/pants/mankini.dmi'
	siemens_coefficient = 1
	body_parts_covered = 0
