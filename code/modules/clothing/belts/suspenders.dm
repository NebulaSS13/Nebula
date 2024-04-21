/obj/item/clothing/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/clothing/belt/suspenders_red.dmi'
	slot_flags = SLOT_TIE | SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	accessory_slot = ACCESSORY_SLOT_DECOR
	accessory_removable = TRUE

/obj/item/clothing/suspenders/get_fallback_slot(slot)
	if(slot != BP_L_HAND && slot != BP_R_HAND)
		return slot_belt_str

/obj/item/clothing/suspenders/colorable
	icon = 'icons/clothing/belt/suspenders.dmi'
