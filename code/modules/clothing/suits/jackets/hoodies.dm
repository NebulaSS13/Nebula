/obj/item/clothing/suit/jacket/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon = 'icons/clothing/suits/hoodie.dmi'
	min_cold_protection_temperature = T0C - 20
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	hood = /obj/item/clothing/head/hoodiehood

/obj/item/clothing/suit/jacket/hoodie/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons),
		GET_DECL(/decl/clothing_state_modifier/hood)
	)
	return expected_state_modifiers

/obj/item/clothing/suit/jacket/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	color = COLOR_DARK_GRAY

/obj/item/clothing/suit/jacket/hoodie/get_assumed_clothing_state_modifiers()
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

/obj/item/clothing/suit/jacket/hoodie/grim
	name = "black hoodie"
	desc = "A generic black hoodie. There's a pattern akin to splattered blood along the bottom."
	icon = 'icons/clothing/suits/grim_hoodie.dmi'
	hood = /obj/item/clothing/head/hoodiehood/grim

/obj/item/clothing/head/hoodiehood/grim
	name = "black hood"
	desc = "A generic black hood."
	icon = 'icons/clothing/head/grim_hood.dmi'
