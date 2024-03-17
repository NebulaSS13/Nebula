/obj/item/clothing/suit/tangzhuang
	name = "tangzhuang jacket"
	desc = "A traditional Chinese coat tied together with straight, symmetrical knots."
	icon = 'icons/clothing/accessories/clothing/tangzuhang.dmi'

/obj/item/clothing/suit/tangzhuang/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/rolled_sleeves)
	)
	return expected_state_modifiers

/obj/item/clothing/suit/sherwani
	name = "sherwani"
	desc = "A long, coat-like frock with fancy embroidery on the cuffs and collar."
	icon = 'icons/clothing/accessories/clothing/sherwani.dmi'

/obj/item/clothing/suit/thawb
	name = "thawb"
	desc = "A white, ankle-length robe designed to be cool in hot climates."
	icon = 'icons/clothing/accessories/clothing/thawb.dmi'

/obj/item/clothing/suit/dashiki
	name = "black dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is green and black."
	icon = 'icons/clothing/accessories/clothing/dashiki.dmi'

/obj/item/clothing/suit/dashiki/red
	name = "red dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is red."
	icon = 'icons/clothing/accessories/clothing/dashiki_red.dmi'

/obj/item/clothing/suit/dashiki/blue
	name = "blue dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is blue."
	icon = 'icons/clothing/accessories/clothing/dashiki_blue.dmi'

/obj/item/clothing/suit/fire_overpants
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
