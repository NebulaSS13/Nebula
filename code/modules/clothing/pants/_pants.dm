/obj/item/clothing/pants
	name = "pants"
	icon = 'icons/clothing/pants/pants.dmi'
	icon_state = ICON_STATE_WORLD
	gender = PLURAL
	body_parts_covered = SLOT_LOWER_BODY|SLOT_LEGS
	permeability_coefficient = 0.90
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_NORMAL
	fallback_slot = slot_lower_body_str
	valid_accessory_slots = UNIFORM_DEFAULT_ACCESSORIES

/obj/item/clothing/pants/get_associated_equipment_slots()
	. = ..()
	var/static/list/pants_slots = list(slot_lower_body_str)
	LAZYDISTINCTADD(., pants_slots)
