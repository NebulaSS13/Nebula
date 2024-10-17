/obj/item/clothing/head
	name                = "head"
	icon_state          = ICON_STATE_WORLD
	icon                = 'icons/clothing/head/softcap.dmi'
	blood_overlay_type  = "helmetblood"
	w_class             = ITEM_SIZE_SMALL
	slot_flags          = SLOT_HEAD
	body_parts_covered  = SLOT_HEAD
	accessory_slot      = ACCESSORY_SLOT_OVER_HELMET
	fallback_slot       = slot_head_str

	var/protects_against_weather = FALSE
	var/light_applied
	var/brightness_on
	var/on = 0

/obj/item/clothing/head/gives_weather_protection()
	return protects_against_weather

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc].")
			return
		on = !on
		to_chat(user, "You [on ? "enable" : "disable"] the helmet light.")
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()

/obj/item/clothing/head/on_update_icon(var/mob/user)
	. = ..()
	update_clothing_icon()
	if(on)
		var/light_state = "[icon_state]_light"
		if(check_state_in_icon(light_state, icon))
			var/image/light_overlay = image(icon, light_state)
			light_overlay.appearance_flags |= RESET_COLOR
			add_overlay(light_overlay)

/obj/item/clothing/head/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && on && check_state_in_icon("[overlay.icon_state]_light", overlay.icon))
		var/light_overlay
		if(user_mob?.get_bodytype_category() != bodytype)
			light_overlay = user_mob?.get_bodytype()?.get_offset_overlay_image(user_mob, overlay.icon, "[overlay.icon_state]_light", null, slot)
		if(!light_overlay)
			light_overlay = image(overlay.icon, "[overlay.icon_state]_light")
		overlay.overlays += light_overlay
	. = ..()

/obj/item/clothing/head/get_associated_equipment_slots()
	. = ..()
	LAZYDISTINCTADD(., slot_head_str)
