/obj/item/clothing/head
	name                = "head"
	icon_state          = ICON_STATE_WORLD
	icon                = 'icons/clothing/head/softcap.dmi'
	blood_overlay_type  = "helmetblood"
	w_class             = ITEM_SIZE_SMALL
	slot_flags          = SLOT_HEAD
	body_parts_covered  = SLOT_HEAD

	var/protects_against_weather = FALSE
	var/image/light_overlay_image
	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

/obj/item/clothing/head/equipped(var/mob/user, var/slot)
	light_overlay_image = null
	..(user, slot)

/obj/item/clothing/head/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && on && slot == slot_head_str)
		overlay.overlays += overlay_image('icons/mob/light_overlays.dmi', "[light_overlay]", null, RESET_COLOR)
	. = ..()

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

/obj/item/clothing/head/attack_ai(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/attack_animal(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	var/datum/extension/hattable/hattable = get_extension(user, /datum/extension/hattable)
	if(Adjacent(user) && hattable)
		if(hattable.hat)
			to_chat(user, SPAN_WARNING("You are already wearing a hat."))
			return TRUE
		if(hattable.wear_hat(user, src))
			to_chat(user, SPAN_NOTICE("You are now wearing \the [src]."))
			return TRUE
	return FALSE

/obj/item/clothing/head/on_update_icon(var/mob/user)
	. = ..()
	if(on)
		add_light_overlay()
	update_clothing_icon()

/obj/item/clothing/head/proc/add_light_overlay()
	if(use_single_icon)
		var/cache_key = "[icon]-[get_world_inventory_state()]_icon"
		if(!light_overlay_cache[cache_key])
			light_overlay_cache[cache_key] = image(icon, "[get_world_inventory_state()]_light")
		overlays |= light_overlay_cache[cache_key]
		return

	if(!light_overlay_cache["[light_overlay]_icon"])
		light_overlay_cache["[light_overlay]_icon"] = image("icon" = 'icons/obj/light_overlays.dmi', "icon_state" = "[light_overlay]")
	overlays |= light_overlay_cache["[light_overlay]_icon"]

/obj/item/clothing/head/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && on && check_state_in_icon("[overlay.icon_state]_light", overlay.icon))
		var/image/light_overlay = image(overlay.icon, "[overlay.icon_state]_light")
		if(ishuman(user_mob))
			var/mob/living/carbon/human/H = user_mob
			if(H.get_bodytype_category() != bodytype)
				light_overlay = H.get_bodytype().get_offset_overlay_image(FALSE, light_overlay.icon, light_overlay.icon_state, null, slot)
		overlay.overlays += light_overlay
	. = ..()

/obj/item/clothing/head/get_associated_equipment_slots()
	. = ..()
	LAZYDISTINCTADD(., slot_head_str)