/obj/item/clothing/suit/jacket/zhongshan
	name = "zhongshan suit jacket"
	desc = "A stylish Chinese tunic suit jacket."
	icon = 'icons/clothing/accessories/clothing/zhongshan.dmi'

/obj/item/clothing/suit/jacket/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon = 'icons/clothing/suits/jackets/bomber.dmi'
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7
	material = /decl/material/solid/organic/leather

/obj/item/clothing/suit/jacket/bomber/pilot
	name = "pilot jacket"
	desc = "A thick, blue bomber jacket."
	icon = 'icons/clothing/suits/jackets/pilot.dmi'
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/jacket/leather
	name = "black leather jacket"
	desc = "A black leather coat."
	icon = 'icons/clothing/suits/jackets/black.dmi'

//This one has buttons for some reason
/obj/item/clothing/suit/jacket/brown
	name = "leather jacket"
	desc = "A brown leather coat."
	icon = 'icons/clothing/suits/jackets/brown.dmi'

/obj/item/clothing/suit/jacket/agent
	name = "agent jacket"
	desc = "A black leather jacket belonging to an agent of the Sol Federal Police."
	icon = 'icons/clothing/suits/jackets/agent.dmi'

/obj/item/clothing/suit/jacket/captain
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon = 'icons/clothing/suits/jackets/captain.dmi'

/obj/item/clothing/suit/jacket/vest
	name = "vest"
	desc = "A slick suit vest."
	icon = 'icons/clothing/accessories/clothing/vest.dmi'

/obj/item/clothing/suit/jacket/vest/gray
	color = "#818181"

/obj/item/clothing/suit/jacket/vest/black
	name = "black vest"
	color = COLOR_GRAY15

/obj/item/clothing/suit/jacket/vest/blue
	color = "#2b65a8"

/obj/item/clothing/suit/jacket/tangzhuang
	name = "tangzhuang jacket"
	desc = "A traditional Chinese coat tied together with straight, symmetrical knots."
	icon = 'icons/clothing/accessories/clothing/tangzuhang.dmi'

/obj/item/clothing/suit/jacket/tangzhuang/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/rolled_sleeves)
	)
	return expected_state_modifiers
