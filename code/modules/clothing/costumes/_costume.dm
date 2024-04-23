/obj/item/clothing/costume
	abstract_type = /obj/item/clothing/costume
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY
	w_class = ITEM_SIZE_NORMAL
	fallback_slot = slot_w_uniform_str
	valid_accessory_slots = UNIFORM_DEFAULT_ACCESSORIES

/obj/item/clothing/costume/get_associated_equipment_slots()
	. = ..()
	var/static/list/under_slots = list(slot_w_uniform_str, slot_wear_id_str)
	LAZYDISTINCTADD(., under_slots)
