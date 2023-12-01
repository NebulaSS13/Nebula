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

/obj/item/clothing/under/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay && slot == slot_w_uniform_str)
		var/decl/bodytype/root_bodytype = user_mob.get_bodytype()
		if(istype(root_bodytype) && root_bodytype.uniform_state_modifier && check_state_in_icon("[overlay.icon_state]-[root_bodytype.uniform_state_modifier]", overlay.icon))
			overlay.icon_state = "[overlay.icon_state]-[root_bodytype.uniform_state_modifier]"
	. = ..()

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
