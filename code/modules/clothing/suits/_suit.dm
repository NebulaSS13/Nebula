/obj/item/clothing/suit
	name = "suit"
	abstract_type = /obj/item/clothing/suit
	icon_state = ICON_STATE_WORLD
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS
	allowed = list(/obj/item/tank/emergency)
	slot_flags = SLOT_OVER_BODY
	blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_OVER)
	fallback_slot = slot_wear_suit_str
	var/protects_against_weather = FALSE
	var/fire_resist = T0C+100

/obj/item/clothing/suit/gives_weather_protection()
	return protects_against_weather

/obj/item/clothing/suit/get_associated_equipment_slots()
	. = ..()
	LAZYDISTINCTADD(., slot_wear_suit_str)

/obj/item/clothing/suit/preserve_in_cryopod(var/obj/machinery/cryopod/pod)
	return TRUE

/obj/item/clothing/suit/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && item_state)
		overlay.icon_state = item_state
	. = ..()

/obj/item/clothing/suit/handle_shield()
	return FALSE

/obj/item/clothing/suit/proc/get_collar()
	var/icon/C = new('icons/mob/collar.dmi')
	if(icon_state in C.IconStates())
		var/image/I = image(C, icon_state)
		I.color = color
		return I
