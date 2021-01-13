/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "A classy waistcoat."
	icon_state = "vest"
	item_state = "wcoat"

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
	icon_state = "suspenders"

/obj/item/clothing/accessory/suspenders/colorable
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon_state = "suspenders_color"

/obj/item/clothing/accessory/dashiki
	name = "black dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is green and black."
	icon_state = "dashiki"

/obj/item/clothing/accessory/dashiki/red
	name = "red dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is red."
	icon_state = "dashikired"

/obj/item/clothing/accessory/dashiki/blue
	name = "blue dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is blue."
	icon_state = "dashikiblue"

/obj/item/clothing/accessory/thawb
	name = "thawb"
	desc = "A white, ankle-length robe designed to be cool in hot climates."
	icon_state = "thawb"

/obj/item/clothing/accessory/sherwani
	name = "sherwani"
	desc = "A long, coat-like frock with fancy embroidery on the cuffs and collar."
	icon_state = "sherwani"

/obj/item/clothing/accessory/qipao
	name = "qipao"
	desc = "A tight-fitting blouse with intricate designs of flowers embroidered on it."
	icon_state = "qipao"

/obj/item/clothing/accessory/sweater
	name = "turtleneck sweater"
	desc = "A stylish sweater to keep you warm on those cold days."
	icon_state = "sweater"

/obj/item/clothing/accessory/ubac
	name = "black ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is black."
	icon_state = "ubacblack"

/obj/item/clothing/accessory/ubac/blue
	name = "blue ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is blue."
	icon_state = "ubacblue"

/obj/item/clothing/accessory/ubac/tan
	name = "tan ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is tan."
	icon_state = "ubactan"

/obj/item/clothing/accessory/ubac/green
	name = "green ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is green."
	icon_state = "ubacgreen"

/obj/item/clothing/accessory/tangzhuang
	name = "tangzhuang jacket"
	desc = "A traditional Chinese coat tied together with straight, symmetrical knots."
	icon_state = "tangzhuang"  //This was originally intended to have the ability to roll sleeves. I can't into code. Will be done later (hopefully.)

/obj/item/clothing/accessory/fire_overpants
	name = "fire overpants"
	desc = "some overpants made of fire-resistant synthetic fibers. To be worn over the uniform."
	icon_state = "fire_overpants"
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
	icon_state = "venter"
	item_state = "venter"
	slot = "over"

/obj/item/clothing/accessory/space_adapted/bracer
	name = "legbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's legs upright comfortably, protecting their bones from high levels of gravity."
	icon_state = "legbrace"
	item_state = "legbrace"

/obj/item/clothing/accessory/space_adapted/bracer/neckbrace
	name = "neckbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's neck upright comfortably, protecting their bones from high levels of gravity."
	icon_state = "neckbrace"
	item_state = "neckbrace"
