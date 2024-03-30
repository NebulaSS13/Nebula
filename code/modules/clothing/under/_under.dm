/obj/item/clothing/under
	name = "under"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit.dmi'
	icon_state = ICON_STATE_WORLD
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
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

	var/displays_id = 1
	var/rolled_down = FALSE
	var/rolled_sleeves = FALSE

/obj/item/clothing/under/Initialize()
	. = ..()
	if(check_state_in_icon("[BODYTYPE_HUMANOID]-[slot_w_uniform_str]-rolled", icon))
		verbs |= /obj/item/clothing/under/proc/roll_down_clothes
	if(check_state_in_icon("[BODYTYPE_HUMANOID]-[slot_w_uniform_str]-sleeves", icon))
		verbs |= /obj/item/clothing/under/proc/roll_up_sleeves

/obj/item/clothing/under/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay && slot == slot_w_uniform_str)
		if(rolled_down && check_state_in_icon("[overlay.icon_state]-rolled", overlay.icon))
			overlay.icon_state = "[overlay.icon_state]-rolled"
		else if(rolled_sleeves && check_state_in_icon("[overlay.icon_state]-sleeves", overlay.icon))
			overlay.icon_state = "[overlay.icon_state]-sleeves"
	. = ..()

/obj/item/clothing/under/proc/roll_down_clothes()

	set name = "Roll Down Uniform"
	set category = "IC"
	set src in usr

	if(!rolled_down && check_state_in_icon("[icon_state]-rolled", icon))
		to_chat(usr, SPAN_WARNING("You cannot roll down \the [src]."))
		verbs -= /obj/item/clothing/under/proc/roll_down_clothes
	else
		rolled_down = !rolled_down
		to_chat(usr, SPAN_NOTICE("You roll [rolled_down ? "down" : "up"] \the [src]."))
		update_clothing_icon()

/obj/item/clothing/under/proc/roll_up_sleeves()

	set name = "Roll Up Sleeves"
	set category = "IC"
	set src in usr

	if(!rolled_sleeves && check_state_in_icon("[icon_state]-sleeves", icon))
		to_chat(usr, SPAN_WARNING("You cannot roll up the sleeves of \the [src]."))
		verbs -= /obj/item/clothing/under/proc/roll_up_sleeves
	else
		rolled_sleeves = !rolled_sleeves
		to_chat(usr, SPAN_NOTICE("You roll [rolled_sleeves ? "up" : "down"] the sleeves of \the [src]."))
		update_clothing_icon()

/obj/item/clothing/under/get_associated_equipment_slots()
	. = ..()
	var/static/list/under_slots = list(slot_w_uniform_str, slot_wear_id_str)
	LAZYDISTINCTADD(., under_slots)

// This stub is so the linter stops yelling about sleeping during Initialize()
// due to corpse props equipping themselves, which calls equip_to_slot, which
// calls attackby(), which sometimes sleeps due to input(). Yeah.
// Remove this if a better fix presents itself.
/obj/item/clothing/under/proc/try_attach_accessory(var/obj/item/accessory, var/mob/user)
	set waitfor = FALSE
	attackby(accessory, user)
