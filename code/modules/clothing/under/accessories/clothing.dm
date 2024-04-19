/obj/item/clothing/accessory/tangzhuang
	name = "tangzhuang jacket"
	desc = "A traditional Chinese coat tied together with straight, symmetrical knots."
	icon = 'icons/clothing/accessories/clothing/tangzuhang.dmi'

/obj/item/clothing/accessory/tangzhuang/tangzhuang/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/rolled_sleeves)
	)
	return expected_state_modifiers

/obj/item/clothing/accessory/venter
	name = "venter assembly"
	desc = "A series of complex tubes, meant to dissipate heat from the skin passively."
	icon = 'icons/clothing/accessories/venter.dmi'
	accessory_slot = "over"

/obj/item/clothing/accessory/bracer
	name = "legbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's legs upright comfortably, protecting their bones from high levels of gravity."
	icon = 'icons/clothing/accessories/legbrace.dmi'

/obj/item/clothing/accessory/bracer/neckbrace
	name = "neckbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's neck upright comfortably, protecting their bones from high levels of gravity."
	icon = 'icons/clothing/accessories/neckbrace.dmi'
