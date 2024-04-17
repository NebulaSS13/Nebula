/obj/item/clothing/tie
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/clothing/accessories/ties/tie.dmi'
	slot_flags = SLOT_TIE
	w_class = ITEM_SIZE_SMALL
	accessory_slot = ACCESSORY_SLOT_NECK

/obj/item/clothing/tie/get_fallback_slot(var/slot)
	if(slot != BP_L_HAND && slot != BP_R_HAND)
		return slot_tie_str
