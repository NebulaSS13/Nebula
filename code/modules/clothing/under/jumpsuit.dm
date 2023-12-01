/obj/item/clothing/jumpsuit
	name = "jumpsuit"
	desc = "The latest in space fashion."
	icon = 'icons/clothing/under/jumpsuits/jumpsuit.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_LOWER_BODY
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
	var/rolled_down = FALSE

/obj/item/clothing/jumpsuit/Initialize()
	. = ..()
	use_alt_layer = !rolled_down
	if(check_state_in_icon("[BODYTYPE_HUMANOID]-[slot_lower_body_str]-rolled", icon))
		verbs |= /obj/item/clothing/jumpsuit/proc/roll_down_clothes

/obj/item/clothing/jumpsuit/get_accessory_overlay_state_modifier(obj/item/clothing/accessory/accessory, slot)
	return (slot == slot_lower_body_str && rolled_down) ? "rolled" : ..()

/obj/item/clothing/jumpsuit/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && slot == slot_lower_body_str && rolled_down && check_state_in_icon("[overlay.icon_state]-rolled", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-rolled"
	. = ..()

/obj/item/clothing/jumpsuit/get_associated_equipment_slots()
	. = ..()
	var/static/list/jumpsuit_slots = list(slot_w_uniform_str, slot_lower_body_str, slot_belt_str)
	LAZYDISTINCTADD(., jumpsuit_slots)

/obj/item/clothing/jumpsuit/update_clothing_icon()
	use_alt_layer = !rolled_down
	. = ..()

/obj/item/clothing/jumpsuit/proc/roll_down_clothes()

	set name = "Roll Down Jumpsuit"
	set category = "IC"
	set src in usr

	if(!rolled_down && check_state_in_icon("[icon_state]-rolled", icon))
		to_chat(usr, SPAN_WARNING("You cannot roll down \the [src]."))
		verbs -= /obj/item/clothing/jumpsuit/proc/roll_down_clothes
	else
		rolled_down = !rolled_down
		if(rolled_down)
			body_parts_covered &= ~SLOT_UPPER_BODY
		else
			body_parts_covered |= SLOT_UPPER_BODY
		to_chat(usr, SPAN_NOTICE("You roll [rolled_down ? "down" : "up"] \the [src]."))
		update_clothing_icon()
