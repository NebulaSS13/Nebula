//Jackets with buttons, used for labcoats, IA jackets, First Responder jackets, and brown jackets.
/obj/item/clothing/suit/storage/toggle/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons)
	)
	return expected_state_modifiers

/obj/item/clothing/suit/storage/toggle/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon = 'icons/clothing/suit/wintercoat/coat.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
		)
	hood = /obj/item/clothing/head/winterhood
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/storage/box/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/chems/drinks/flask)
	siemens_coefficient = 0.6
	protects_against_weather = TRUE

/obj/item/clothing/suit/storage/toggle/wintercoat/get_assumed_clothing_state_modifiers()
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

/obj/item/clothing/suit/storage/toggle/wintercoat/captain
	name = "captain's winter coat"
	icon = 'icons/clothing/suit/wintercoat/captain.dmi'
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

/obj/item/clothing/suit/storage/toggle/wintercoat/security
	name = "security winter coat"
	icon = 'icons/clothing/suit/wintercoat/sec.dmi'
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

/obj/item/clothing/suit/storage/toggle/wintercoat/medical
	name = "medical winter coat"
	icon = 'icons/clothing/suit/wintercoat/med.dmi'
	hood = /obj/item/clothing/head/winterhood/medical
	armor = list(
		ARMOR_BIO = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/head/winterhood/medical
	icon = 'icons/clothing/head/hood_winter_med.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/science
	name = "science winter coat"
	icon = 'icons/clothing/suit/wintercoat/sci.dmi'
	hood = /obj/item/clothing/head/winterhood/science
	armor = list(
		ARMOR_BOMB = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/science
	icon = 'icons/clothing/head/hood_winter_sci.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/engineering
	name = "engineering winter coat"
	icon = 'icons/clothing/suit/wintercoat/eng.dmi'
	hood = /obj/item/clothing/head/winterhood/engineering
	armor = list(
		ARMOR_RAD = ARMOR_RAD_MINOR
	)

/obj/item/clothing/head/winterhood/engineering
	icon = 'icons/clothing/head/hood_winter_eng.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	hood = /obj/item/clothing/head/winterhood/atmos
	icon = 'icons/clothing/suit/wintercoat/atmos.dmi'

/obj/item/clothing/head/winterhood/atmos
	icon = 'icons/clothing/head/hood_winter_atmos.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/hydro
	name = "hydroponics winter coat"
	hood = /obj/item/clothing/head/winterhood/hydroponics
	icon = 'icons/clothing/suit/wintercoat/hydro.dmi'

/obj/item/clothing/head/winterhood/hydroponics
	icon = 'icons/clothing/head/hood_winter_hydro.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/cargo
	name = "cargo winter coat"
	hood = /obj/item/clothing/head/winterhood/cargo
	icon = 'icons/clothing/suit/wintercoat/cargo.dmi'

/obj/item/clothing/head/winterhood/cargo
	icon = 'icons/clothing/head/hood_winter_cargo.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/miner
	name = "mining winter coat"
	hood = /obj/item/clothing/head/winterhood/mining
	icon = 'icons/clothing/suit/wintercoat/mining.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
	)

/obj/item/clothing/head/winterhood/mining
	icon = 'icons/clothing/head/hood_winter_mining.dmi'

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon = 'icons/clothing/suit/hoodie.dmi'
	min_cold_protection_temperature = T0C - 20
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	action_button_name = "Toggle Hood"
	hood = /obj/item/clothing/head/hoodiehood

/obj/item/clothing/suit/storage/toggle/hoodie/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons),
		GET_DECL(/decl/clothing_state_modifier/hood)
	)
	return expected_state_modifiers

/obj/item/clothing/head/hoodiehood
	name = "hoodie hood"
	desc = "A hood attached to a warm sweatshirt."
	icon = 'icons/clothing/head/hood.dmi'
	body_parts_covered = SLOT_HEAD
	min_cold_protection_temperature = T0C - 20
	cold_protection = SLOT_HEAD
	flags_inv = HIDEEARS | BLOCK_HEAD_HAIR
