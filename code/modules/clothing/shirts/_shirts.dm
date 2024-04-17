/obj/item/clothing/shirt
	abstract_type = /obj/item/clothing/shirt
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY | SLOT_TIE
	w_class = ITEM_SIZE_SMALL
	accessory_slot = ACCESSORY_SLOT_DECOR
	accessory_removable = TRUE
	force = 0

/obj/item/clothing/shirt/get_associated_equipment_slots()
	. = ..()
	var/static/list/shirt_slots = list(slot_w_uniform_str, slot_wear_id_str)
	LAZYDISTINCTADD(., shirt_slots)

/obj/item/clothing/shirt/get_fallback_slot(var/slot)
	if(slot != BP_L_HAND && slot != BP_R_HAND)
		return slot_w_uniform_str
