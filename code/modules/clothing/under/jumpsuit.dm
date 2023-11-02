/obj/item/clothing/under/jumpsuit
	name = "jumpsuit"
	desc = "The latest in space fashion."
	icon = 'icons/clothing/under/jumpsuits/jumpsuit.dmi'
	body_parts_covered = SLOT_LOWER_BODY|SLOT_UPPER_BODY|SLOT_LEGS
	permeability_coefficient = 0.90
	slot_flags = SLOT_LOWER_BODY

/obj/item/clothing/under/jumpsuit/Initialize()
	. = ..()
	use_alt_layer = !rolled_down

/obj/item/clothing/under/jumpsuit/get_associated_equipment_slots()
	. = ..()
	var/static/list/jumpsuit_slots = list(slot_w_uniform_str, slot_lower_body_str, slot_belt_str)
	LAZYDISTINCTADD(., jumpsuit_slots)

/obj/item/clothing/under/jumpsuit/roll_down_clothes()
	. = ..()
	if(rolled_down)
		body_parts_covered &= ~SLOT_UPPER_BODY
	else
		body_parts_covered |= SLOT_UPPER_BODY

/obj/item/clothing/under/jumpsuit/update_clothing_icon()
	use_alt_layer = !rolled_down
	. = ..()
