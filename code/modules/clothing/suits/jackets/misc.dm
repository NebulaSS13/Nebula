/obj/item/clothing/suit/jacket/zhongshan
	name = "zhongshan suit jacket"
	desc = "A stylish Chinese tunic suit jacket."
	icon = 'icons/clothing/accessories/clothing/zhongshan.dmi'

/obj/item/clothing/suit/jacket/zhongshan/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons)
	)
	return expected_state_modifiers
