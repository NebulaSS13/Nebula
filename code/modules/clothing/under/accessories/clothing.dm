/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "A classy waistcoat."
	icon = 'icons/clothing/accessories/clothing/vest.dmi'

/obj/item/clothing/accessory/wcoat/black
	color = COLOR_GRAY15

/obj/item/clothing/accessory/wcoat/armored
	desc = "A classy waistcoat. This one seems suspiciously more durable."
	color = COLOR_GRAY15
	armor = list(
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		melee = ARMOR_MELEE_SMALL,
		energy = ARMOR_ENERGY_MINOR
		)
	body_parts_covered = SLOT_UPPER_BODY
	origin_tech = "{'combat':2,'materials':3,'esoteric':2}"

/obj/item/clothing/accessory/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/clothing/accessories/clothing/suspenders_red.dmi'

/obj/item/clothing/accessory/suspenders/colorable
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/clothing/accessories/clothing/suspenders.dmi'

/obj/item/clothing/accessory/dashiki
	name = "black dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is green and black."
	icon = 'icons/clothing/accessories/clothing/dashiki.dmi'

/obj/item/clothing/accessory/dashiki/red
	name = "red dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is red."
	icon = 'icons/clothing/accessories/clothing/dashiki_red.dmi'

/obj/item/clothing/accessory/dashiki/blue
	name = "blue dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is blue."
	icon = 'icons/clothing/accessories/clothing/dashiki_blue.dmi'

/obj/item/clothing/accessory/thawb
	name = "thawb"
	desc = "A white, ankle-length robe designed to be cool in hot climates."
	icon = 'icons/clothing/accessories/clothing/thawb.dmi'

/obj/item/clothing/accessory/sherwani
	name = "sherwani"
	desc = "A long, coat-like frock with fancy embroidery on the cuffs and collar."
	icon = 'icons/clothing/accessories/clothing/sherwani.dmi'

/obj/item/clothing/accessory/qipao
	name = "qipao"
	desc = "A tight-fitting blouse with intricate designs of flowers embroidered on it."
	icon = 'icons/clothing/accessories/clothing/qipao.dmi'

/obj/item/clothing/accessory/sweater
	name = "turtleneck sweater"
	desc = "A stylish sweater to keep you warm on those cold days."
	icon = 'icons/clothing/accessories/clothing/sweater.dmi'

/obj/item/clothing/accessory/ubac
	name = "black ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is black."
	icon = 'icons/clothing/accessories/clothing/ubac.dmi'

/obj/item/clothing/accessory/ubac/blue
	name = "blue ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is blue."
	icon = 'icons/clothing/accessories/clothing/ubac_blue.dmi'

/obj/item/clothing/accessory/ubac/tan
	name = "tan ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is tan."
	icon = 'icons/clothing/accessories/clothing/ubac_tan.dmi'

/obj/item/clothing/accessory/ubac/green
	name = "green ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is green."
	icon = 'icons/clothing/accessories/clothing/ubac_green.dmi'

/obj/item/clothing/accessory/tangzhuang
	name = "tangzhuang jacket"
	desc = "A traditional Chinese coat tied together with straight, symmetrical knots."
	icon = 'icons/clothing/accessories/clothing/tangzuhang.dmi'
	var/sleeves_rolled = FALSE

/obj/item/clothing/accessory/tangzhuang/on_update_icon()
	icon_state = get_world_inventory_state()
	if(sleeves_rolled && check_state_in_icon("[icon_state]-sleeves", icon))
		icon_state = "[icon_state]-sleeves"

/obj/item/clothing/accessory/tangzhuang/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(sleeves_rolled && check_state_in_icon("[ret.icon_state]-sleeves", ret.icon))
		ret.icon_state = "[ret.icon_state]-sleeves"
	return ret

/obj/item/clothing/accessory/fire_overpants
	name = "fire overpants"
	desc = "some overpants made of fire-resistant synthetic fibers. To be worn over the uniform."
	icon = 'icons/clothing/accessories/clothing/fire_overpants.dmi'

	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50

	armor = list(laser = ARMOR_LASER_MINOR, energy = ARMOR_ENERGY_MINOR, bomb = ARMOR_BOMB_MINOR)
	body_parts_covered = SLOT_LOWER_BODY | SLOT_LEGS
	slowdown = 0.5

	heat_protection = SLOT_LOWER_BODY | SLOT_LEGS
	cold_protection = SLOT_LOWER_BODY | SLOT_LEGS

	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE

/obj/item/clothing/accessory/space_adapted/venter
	name = "venter assembly"
	desc = "A series of complex tubes, meant to dissipate heat from the skin passively."
	icon = 'icons/clothing/accessories/venter.dmi'
	slot = "over"

/obj/item/clothing/accessory/space_adapted/bracer
	name = "legbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's legs upright comfortably, protecting their bones from high levels of gravity."
	icon = 'icons/clothing/accessories/legbrace.dmi'

/obj/item/clothing/accessory/space_adapted/bracer/neckbrace
	name = "neckbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's neck upright comfortably, protecting their bones from high levels of gravity."
	icon = 'icons/clothing/accessories/neckbrace.dmi'
