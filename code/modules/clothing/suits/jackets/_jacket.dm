/obj/item/clothing/suit/jacket
	name                = "suit jacket"
	desc                = "A snappy dress jacket."
	icon                = 'icons/clothing/suits/jackets/jacket.dmi'
	blood_overlay_type  = "coat"
	body_parts_covered  = SLOT_UPPER_BODY | SLOT_ARMS
	cold_protection     = SLOT_UPPER_BODY | SLOT_ARMS
	slot_flags          = SLOT_OVER_BODY
	w_class             = ITEM_SIZE_NORMAL
	accessory_slot      = ACCESSORY_SLOT_DECOR
	valid_accessory_slots = list(
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_OVER
	)

/obj/item/clothing/suit/jacket/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons)
	)
	return expected_state_modifiers

/obj/item/clothing/suit/jacket/blue
	name = "blue suit jacket"
	color = "#00326e"

/obj/item/clothing/suit/jacket/purple
	name = "purple suit jacket"
	color = "#6c316c"

/obj/item/clothing/suit/jacket/black
	name = "black suit jacket"
	color = "#1f1f1f"

/obj/item/clothing/suit/jacket/tan
	name = "tan suit jacket"
	desc = "A cozy suit jacket."
	icon = 'icons/clothing/suits/jackets/tan.dmi'

/obj/item/clothing/suit/jacket/charcoal
	name = "charcoal suit jacket"
	desc = "A strict suit jacket."
	icon = 'icons/clothing/suits/jackets/charcoal.dmi'

/obj/item/clothing/suit/jacket/navy
	name = "navy suit jacket"
	desc = "An official suit jacket."
	icon = 'icons/clothing/suits/jackets/navy.dmi'

/obj/item/clothing/suit/jacket/burgundy
	name = "burgundy suit jacket"
	desc = "An expensive suit jacket."
	icon = 'icons/clothing/suits/jackets/burgundy.dmi'

/obj/item/clothing/suit/jacket/checkered
	name = "checkered suit jacket"
	desc = "A lucky suit jacket."
	icon = 'icons/clothing/suits/jackets/checkered.dmi'

/obj/item/clothing/suit/jacket/blazer
	name = "blue blazer"
	desc = "A bold yet conservative navy blazer."
	icon = 'icons/clothing/suits/jackets/blazer.dmi'
