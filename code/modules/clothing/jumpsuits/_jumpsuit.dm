/obj/item/clothing/jumpsuit
	name = "jumpsuit"
	desc = "The latest in space fashion."
	icon = 'icons/clothing/jumpsuits/jumpsuit.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY | SLOT_OVER_BODY
	w_class = ITEM_SIZE_NORMAL
	fallback_slot = slot_w_uniform_str
	valid_accessory_slots = UNIFORM_DEFAULT_ACCESSORIES

/obj/item/clothing/jumpsuit/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/rolled_down),
		GET_DECL(/decl/clothing_state_modifier/rolled_sleeves)
	)
	return expected_state_modifiers

/obj/item/clothing/costume/get_associated_equipment_slots()
	. = ..()
	var/static/list/under_slots = list(slot_w_uniform_str, slot_wear_id_str)
	LAZYDISTINCTADD(., under_slots)
