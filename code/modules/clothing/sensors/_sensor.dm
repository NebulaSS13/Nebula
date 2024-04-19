/obj/item/clothing/sensor
	name = "sensor"
	abstract_type = /obj/item/clothing/sensor
	slot_flags = SLOT_TIE
	icon_state = ICON_STATE_WORLD
	accessory_slot = ACCESSORY_SLOT_SENSORS

/obj/item/clothing/sensor/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)
	return new /image

/obj/item/clothing/sensor/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	return overlay
