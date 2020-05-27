/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/obj_head.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_hats.dmi',
		)
	body_parts_covered = HEAD
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

/obj/item/clothing/head/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(light_overlay_image)
		ret.overlays -= light_overlay_image
	if(on && slot == slot_head_str)
		if(!light_overlay_image)
			if(ishuman(user_mob))
				var/mob/living/carbon/human/user_human = user_mob
				var/use_icon
				if(sprite_sheets)
					use_icon = sprite_sheets[user_human.species.get_bodytype(user_human)]
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
	if(!Adjacent(user))
		return 0
	if(!is_drone(user))
		return 0
	var/success
	var/mob/living/silicon/robot/drone/D = user
	if(D.hat)
		success = 2
	else
		D.wear_hat(src)
		success = 1

	if(!success)
		return 0
	else if(success == 2)
		to_chat(user, "<span class='warning'>You are already wearing a hat.</span>")
	else if(success == 1)
		to_chat(user, "<span class='notice'>You crawl under \the [src].</span>")
	return 1

/obj/item/clothing/head/on_update_icon(var/mob/user)

	overlays.Cut()
	if(on)
		add_light_overlay()
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_head()

/obj/item/clothing/head/proc/add_light_overlay()
	if(!light_overlay_cache["[light_overlay]_icon"])
		light_overlay_cache["[light_overlay]_icon"] = image("icon" = 'icons/obj/light_overlays.dmi', "icon_state" = "[light_overlay]")
	overlays |= light_overlay_cache["[light_overlay]_icon"]

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()