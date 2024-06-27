/obj/item/clothing/shirt
	abstract_type = /obj/item/clothing/shirt
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY
	accessory_slot = ACCESSORY_SLOT_DECOR
	fallback_slot = slot_w_uniform_str

/obj/item/clothing/shirt/get_associated_equipment_slots()
	. = ..()
	var/static/list/shirt_slots = list(slot_w_uniform_str, slot_wear_id_str)
	LAZYDISTINCTADD(., shirt_slots)
