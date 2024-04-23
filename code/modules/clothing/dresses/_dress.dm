/obj/item/clothing/dress
	name = "flame dress"
	desc = "A small black dress with blue flames print on it."
	icon = 'icons/clothing/under/dresses/dress_fire.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY
	w_class = ITEM_SIZE_NORMAL
	force = 0

	valid_accessory_slots = list(
		ACCESSORY_SLOT_SENSORS,
		ACCESSORY_SLOT_UTILITY,
		ACCESSORY_SLOT_HOLSTER,
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_DEPT,
		ACCESSORY_SLOT_DECOR,
		ACCESSORY_SLOT_NECK,
		ACCESSORY_SLOT_MEDAL,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_OVER
		)

	restricted_accessory_slots = list(
		ACCESSORY_SLOT_UTILITY,
		ACCESSORY_SLOT_HOLSTER,
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_DEPT,
		ACCESSORY_SLOT_OVER
	)

/obj/item/clothing/dress/get_associated_equipment_slots()
	. = ..()
	var/static/list/under_slots = list(slot_w_uniform_str, slot_wear_id_str)
	LAZYDISTINCTADD(., under_slots)

/obj/item/clothing/dress/get_fallback_slot(slot)
	return slot_w_uniform_str
