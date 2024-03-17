/obj/item/clothing/suit/jacket
	name = "Jacket"
	abstract_type = /obj/item/clothing/suit/jacket

/obj/item/clothing/suit/jacket/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons)
	)
	return expected_state_modifiers

/obj/item/clothing/suit/jacket/tan
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_tan.dmi'

/obj/item/clothing/suit/jacket/charcoal
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_charcoal.dmi'

/obj/item/clothing/suit/jacket/navy
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_navy.dmi'

/obj/item/clothing/suit/jacket/burgundy
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_burgundy.dmi'

/obj/item/clothing/suit/jacket/checkered
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_checkered.dmi'

/obj/item/clothing/suit/jacket/zhongshan
	name = "zhongshan suit jacket"
	desc = "A stylish Chinese tunic suit jacket."
	icon = 'icons/clothing/accessories/clothing/zhongshan.dmi'

/obj/item/clothing/suit/jacket/black_vest
	name = "black vest"
	desc = "A neat, formal black vest."
	color = COLOR_GRAY15
