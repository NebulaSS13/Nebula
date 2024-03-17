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

/obj/item/clothing/accessory/toggleable/tan_jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_tan.dmi'

/obj/item/clothing/accessory/toggleable/charcoal_jacket
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_charcoal.dmi'

/obj/item/clothing/accessory/toggleable/navy_jacket
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_navy.dmi'

/obj/item/clothing/accessory/toggleable/burgundy_jacket
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_burgundy.dmi'

/obj/item/clothing/accessory/toggleable/checkered_jacket
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_checkered.dmi'

/obj/item/clothing/accessory/toggleable/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon = 'icons/clothing/accessories/clothing/hawaiian.dmi'

/obj/item/clothing/accessory/toggleable/hawaii/red
	icon = 'icons/clothing/accessories/clothing/hawaiian_alt.dmi'

/obj/item/clothing/accessory/toggleable/hawaii/random/Initialize()
	. = ..()
	icon = pick('icons/clothing/accessories/clothing/hawaiian.dmi', 'icons/clothing/accessories/clothing/hawaiian_alt.dmi')
	color = color_matrix_rotate_hue(rand(-11,12)*15)

/obj/item/clothing/accessory/toggleable/zhongshan
	name = "zhongshan suit jacket"
	desc = "A stylish Chinese tunic suit jacket."
	icon = 'icons/clothing/accessories/clothing/zhongshan.dmi'

/obj/item/clothing/accessory/toggleable/flannel
	name = "flannel shirt"
	desc = "A comfy, plaid flannel shirt."
	icon = 'icons/clothing/accessories/clothing/flannel.dmi'

/obj/item/clothing/accessory/toggleable/flannel/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons),
		GET_DECL(/decl/clothing_state_modifier/rolled_sleeves),
		GET_DECL(/decl/clothing_state_modifier/tucked_in)
	)
	return expected_state_modifiers
