/obj/item/clothing/accessory/toggleable
	name = "vest"
	desc = "A slick suit vest."
	icon = 'icons/clothing/accessories/clothing/vest.dmi'
	icon_state = ICON_STATE_WORLD

/obj/item/clothing/accessory/toggleable/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons)
	)
	return expected_state_modifiers

/obj/item/clothing/accessory/toggleable/black_vest
	name = "black vest"
	color = COLOR_GRAY15

