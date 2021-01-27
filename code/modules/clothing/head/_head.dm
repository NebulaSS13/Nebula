/obj/item/clothing/head
	name = "head"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/softcap.dmi'
	body_parts_covered = SLOT_HEAD
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_SMALL
	blood_overlay_type = "helmetblood"

	var/image/light_overlay_image
	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

/obj/item/clothing/head/equipped(var/mob/user, var/slot)
	light_overlay_image = null
	..(user, slot)

/obj/item/clothing/head/get_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(light_overlay_image)
		ret.overlays -= light_overlay_image
	if(on && slot == slot_head_str)
		if(!light_overlay_image)
			if(ishuman(user_mob))
				var/mob/living/carbon/human/user_human = user_mob
				var/use_icon = LAZYACCESS(sprite_sheets, user_human.species.get_bodytype(user_human))
				if(use_icon)
					light_overlay_image = user_human.species.get_offset_overlay_image(TRUE, use_icon, "[light_overlay]", color, slot)
				else
					light_overlay_image = user_human.species.get_offset_overlay_image(FALSE, 'icons/mob/light_overlays.dmi', "[light_overlay]", color, slot)
			else
				light_overlay_image = overlay_image('icons/mob/light_overlays.dmi', "[light_overlay]", null, RESET_COLOR)
		ret.overlays |= light_overlay_image
	return ret

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc]")
			return
		on = !on
		to_chat(user, "You [on ? "enable" : "disable"] the helmet light.")
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on, 1, 3)
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
	..()
	if(on)
		add_light_overlay()
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_head()

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

/obj/item/clothing/head/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	var/image/ret = ..()
	if(on && check_state_in_icon("[ret.icon_state]_light", ret.icon))
		var/image/light_overlay = image(ret.icon, "[ret.icon_state]_light")
		if(ishuman(user_mob))
			var/mob/living/carbon/human/H = user_mob
			if(H.species.get_bodytype(H) != bodytype)
				light_overlay = H.species.get_offset_overlay_image(FALSE, light_overlay.icon, light_overlay.icon_state, null, slot)
		ret.overlays += light_overlay
	return ret

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()