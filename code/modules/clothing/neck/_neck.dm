/obj/item/clothing/neck
	abstract_type = /obj/item/clothing/neck
	slot_flags = SLOT_TIE
	w_class = ITEM_SIZE_SMALL
	accessory_slot = ACCESSORY_SLOT_NECK

/obj/item/clothing/neck/get_fallback_slot(var/slot)
	if(slot != BP_L_HAND && slot != BP_R_HAND)
		return slot_tie_str
