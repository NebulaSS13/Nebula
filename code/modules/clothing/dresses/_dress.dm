/obj/item/clothing/dress
	name = "flame dress"
	desc = "A small black dress with blue flames print on it."
	icon = 'icons/clothing/dresses/dress_fire.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY
	w_class = ITEM_SIZE_NORMAL
	valid_accessory_slots = UNIFORM_DEFAULT_ACCESSORIES
	fallback_slot = slot_w_uniform_str

/obj/item/clothing/dress/get_associated_equipment_slots()
	. = ..()
	var/static/list/under_slots = list(slot_w_uniform_str, slot_wear_id_str)
	LAZYDISTINCTADD(., under_slots)
