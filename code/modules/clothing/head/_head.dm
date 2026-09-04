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
	var/headlamp_range
	var/headlamp_on = FALSE

/obj/item/clothing/head/gives_weather_protection()
	return protects_against_weather

/obj/item/clothing/head/attack_self(mob/user)
	if(headlamp_range)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn \the [src]'s light on while in this [user.loc].")
			return
		headlamp_on = !headlamp_on
		to_chat(user, "You [headlamp_on ? "enable" : "disable"] the light on \the [src].")
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	set_light(headlamp_on ? headlamp_range : 0)
	update_icon()
	user.update_action_buttons()

/obj/item/clothing/head/on_update_icon()
	. = ..()
	update_clothing_icon()
	if(headlamp_on)
		var/light_state = "[icon_state]_light"
		if(check_state_in_icon(light_state, icon))
			var/image/light_overlay = image(icon, light_state)
			light_overlay.appearance_flags |= RESET_COLOR
			add_overlay(light_overlay)

/obj/item/clothing/head/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && headlamp_on && check_state_in_icon("[overlay.icon_state]_light", overlay.icon))
		overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]_light", COLOR_WHITE, RESET_COLOR)
	. = ..()
