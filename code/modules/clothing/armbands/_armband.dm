/obj/item/clothing/armband
	name = "red armband"
	desc = "A fancy red armband!"
	icon = 'icons/clothing/accessories/armbands/armband_security.dmi'
	bodytype_equip_flags = null
	slot_flags = SLOT_UPPER_BODY | SLOT_TIE
	w_class = ITEM_SIZE_SMALL
	accessory_slot = ACCESSORY_SLOT_ARMBAND
	accessory_removable = TRUE

/obj/item/clothing/armband/get_fallback_slot(var/slot)
	if(slot != BP_L_HAND && slot != BP_R_HAND)
		return slot_w_uniform_str

/obj/item/clothing/armband/get_initial_accessory_hide_on_states()
	var/static/list/initial_accessory_hide_on_states = list(
		/decl/clothing_state_modifier/rolled_down,
		/decl/clothing_state_modifier/rolled_sleeves
	)
	return initial_accessory_hide_on_states
