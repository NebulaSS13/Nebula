/obj/item/clothing/suit/jacket/winter
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon = 'icons/clothing/suits/wintercoat/coat.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)
	hood = /obj/item/clothing/head/winterhood
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/box/fancy/cigarettes, /obj/item/box/matches, /obj/item/chems/drinks/flask)
	siemens_coefficient = 0.6
	protects_against_weather = TRUE

/obj/item/clothing/suit/jacket/winter/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons),
		GET_DECL(/decl/clothing_state_modifier/hood)
	)
	return expected_state_modifiers

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon = 'icons/clothing/head/hood_winter.dmi'
	body_parts_covered = SLOT_HEAD
	cold_protection = SLOT_HEAD
	flags_inv = HIDEEARS | BLOCK_HEAD_HAIR
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	protects_against_weather = TRUE

/obj/item/clothing/suit/jacket/winter/captain
	name = "captain's winter coat"
	icon = 'icons/clothing/suits/wintercoat/captain.dmi'
	hood = /obj/item/clothing/head/winterhood/captain
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/captain
	icon = 'icons/clothing/head/hood_winter_captain.dmi'

/obj/item/clothing/suit/jacket/winter/security
	name = "security winter coat"
	icon = 'icons/clothing/suits/wintercoat/sec.dmi'
	hood = /obj/item/clothing/head/winterhood/security
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/security
	icon = 'icons/clothing/head/hood_winter_sec.dmi'

/obj/item/clothing/suit/jacket/winter/medical
	name = "medical winter coat"
	icon = 'icons/clothing/suits/wintercoat/med.dmi'
	hood = /obj/item/clothing/head/winterhood/medical
	armor = list(
		ARMOR_BIO = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/head/winterhood/medical
	icon = 'icons/clothing/head/hood_winter_med.dmi'

/obj/item/clothing/suit/jacket/winter/science
	name = "science winter coat"
	icon = 'icons/clothing/suits/wintercoat/sci.dmi'
	hood = /obj/item/clothing/head/winterhood/science
	armor = list(
		ARMOR_BOMB = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/science
	icon = 'icons/clothing/head/hood_winter_sci.dmi'

/obj/item/clothing/suit/jacket/winter/engineering
	name = "engineering winter coat"
	icon = 'icons/clothing/suits/wintercoat/eng.dmi'
	hood = /obj/item/clothing/head/winterhood/engineering
	armor = list(
		ARMOR_RAD = ARMOR_RAD_MINOR
	)

/obj/item/clothing/head/winterhood/engineering
	icon = 'icons/clothing/head/hood_winter_eng.dmi'

/obj/item/clothing/suit/jacket/winter/engineering/atmos
	name = "atmospherics winter coat"
	hood = /obj/item/clothing/head/winterhood/atmos
	icon = 'icons/clothing/suits/wintercoat/atmos.dmi'

/obj/item/clothing/head/winterhood/atmos
	icon = 'icons/clothing/head/hood_winter_atmos.dmi'

/obj/item/clothing/suit/jacket/winter/hydro
	name = "hydroponics winter coat"
	hood = /obj/item/clothing/head/winterhood/hydroponics
	icon = 'icons/clothing/suits/wintercoat/hydro.dmi'

/obj/item/clothing/head/winterhood/hydroponics
	icon = 'icons/clothing/head/hood_winter_hydro.dmi'

/obj/item/clothing/suit/jacket/winter/cargo
	name = "cargo winter coat"
	hood = /obj/item/clothing/head/winterhood/cargo
	icon = 'icons/clothing/suits/wintercoat/cargo.dmi'

/obj/item/clothing/head/winterhood/cargo
	icon = 'icons/clothing/head/hood_winter_cargo.dmi'

/obj/item/clothing/suit/jacket/winter/miner
	name = "mining winter coat"
	hood = /obj/item/clothing/head/winterhood/mining
	icon = 'icons/clothing/suits/wintercoat/mining.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
	)

/obj/item/clothing/head/winterhood/mining
	icon = 'icons/clothing/head/hood_winter_mining.dmi'
