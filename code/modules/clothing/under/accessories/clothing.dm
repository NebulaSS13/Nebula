/obj/item/clothing/accessory/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/clothing/accessories/clothing/suspenders_red.dmi'

/obj/item/clothing/accessory/suspenders/colorable
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/clothing/accessories/clothing/suspenders.dmi'

/obj/item/clothing/accessory/tangzhuang
	name = "tangzhuang jacket"
	desc = "A traditional Chinese coat tied together with straight, symmetrical knots."
	icon = 'icons/clothing/accessories/clothing/tangzuhang.dmi'

/obj/item/clothing/accessory/tangzhuang/tangzhuang/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/rolled_sleeves)
	)
	return expected_state_modifiers

/obj/item/clothing/accessory/fire_overpants
	name = "fire overpants"
	desc = "some overpants made of fire-resistant synthetic fibers. To be worn over the uniform."
	icon = 'icons/clothing/accessories/clothing/fire_overpants.dmi'

	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50

	armor = list(ARMOR_LASER = ARMOR_LASER_MINOR, ARMOR_ENERGY = ARMOR_ENERGY_MINOR, ARMOR_BOMB = ARMOR_BOMB_MINOR)
	body_parts_covered = SLOT_LOWER_BODY | SLOT_LEGS | SLOT_TAIL
	accessory_slowdown = 0.5

	heat_protection = SLOT_LOWER_BODY | SLOT_LEGS | SLOT_TAIL
	cold_protection = SLOT_LOWER_BODY | SLOT_LEGS | SLOT_TAIL

	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE

/obj/item/clothing/accessory/venter
	name = "venter assembly"
	desc = "A series of complex tubes, meant to dissipate heat from the skin passively."
	icon = 'icons/clothing/accessories/venter.dmi'
	accessory_slot = "over"

/obj/item/clothing/accessory/bracer
	name = "legbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's legs upright comfortably, protecting their bones from high levels of gravity."
	icon = 'icons/clothing/accessories/legbrace.dmi'

/obj/item/clothing/accessory/bracer/neckbrace
	name = "neckbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's neck upright comfortably, protecting their bones from high levels of gravity."
	icon = 'icons/clothing/accessories/neckbrace.dmi'
