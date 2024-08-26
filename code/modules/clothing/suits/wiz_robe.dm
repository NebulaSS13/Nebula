/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon = 'icons/clothing/head/wizard/wizard.dmi'
	//Not given any special protective value since the magic robes are full-body protection --NEO
	siemens_coefficient = 0.8
	body_parts_covered = 0
	wizard_garb = 1

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "Strange-looking, red, hat-wear that most certainly belongs to a real magic user."
	icon = 'icons/clothing/head/wizard/red.dmi'
	siemens_coefficient = 0.8

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARD written across it in sequins. Comes with a cool beard."
	icon = 'icons/clothing/head/wizard/fake.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_FACE

/obj/item/clothing/head/wizard/marisa
	name = "witch hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon = 'icons/clothing/head/wizard/marisa.dmi'
	siemens_coefficient = 0.8

/obj/item/clothing/head/wizard/magus
	name = "magus helm"
	desc = "A mysterious helmet that hums with an unearthly power."
	icon = 'icons/clothing/head/wizard/magus.dmi'
	siemens_coefficient = 0.8
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/head/wizard/cap
	name = "gentleman's cap"
	desc = "A checkered gray flat cap woven together with the rarest of threads."
	icon = 'icons/clothing/head/flatcap.dmi'
	siemens_coefficient = 0.8

/obj/item/clothing/suit/wizrobe
	name = "wizard robe"
	desc = "A magnificant, gem-lined robe that seems to radiate power."
	icon = 'icons/clothing/suits/wizard/wizard.dmi'
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_MINOR,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	allowed = list(/obj/item/paper/scroll)
	siemens_coefficient = 0.8
	wizard_garb = 1

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificant, red, gem-lined robe that seems to radiate power."
	icon = 'icons/clothing/suits/wizard/red.dmi'

/obj/item/clothing/suit/wizrobe/marisa
	name = "witch robe"
	desc = "Magic is all about the spell power, ZE!"
	icon = 'icons/clothing/suits/wizard/marisa.dmi'

/obj/item/clothing/suit/wizrobe/magusblue
	name = "magus robe"
	desc = "A set of armoured robes that seem to radiate a dark power."
	icon = 'icons/clothing/suits/wizard/magusblue.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_HANDS|SLOT_LEGS|SLOT_FEET

/obj/item/clothing/suit/wizrobe/magusred
	name = "magus robe"
	desc = "A set of armoured robes that seem to radiate a dark power."
	icon = 'icons/clothing/suits/wizard/magusred.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_HANDS|SLOT_LEGS|SLOT_FEET

/obj/item/clothing/suit/wizrobe/psypurple
	name = "purple robes"
	desc = "Heavy, royal purple robes threaded with psychic amplifiers and weird, bulbous lenses. Do not machine wash."
	icon = 'icons/clothing/suits/wizard/psy.dmi'
	gender = PLURAL

/obj/item/clothing/suit/wizrobe/gentlecoat
	name = "gentleman's coat"
	desc = "A heavy threaded tweed gray jacket. For a different sort of Gentleman."
	icon = 'icons/clothing/suits/wizard/gentleman.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS

/obj/item/clothing/suit/wizrobe/fake
	name = "wizard robe"
	desc = "A rather dull, blue robe meant to mimick real wizard robes."
	icon = 'icons/clothing/suits/wizard/fake.dmi'
	armor = null
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/marisa/fake
	name = "witch hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	armor = null
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/marisa/fake
	name = "witch robe"
	desc = "Magic is all about the spell power, ZE!"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS
	armor = null
	siemens_coefficient = 1.0

