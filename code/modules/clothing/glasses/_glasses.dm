/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/clothing/eyes/glasses_prescription.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = SLOT_EYES
	slot_flags = SLOT_EYES
	fallback_slot = slot_glasses_str

	var/vision_flags =     0
	var/darkness_view =    0
	var/see_invisible =   -1
	var/light_protection = 0
	var/prescription =     FALSE
	var/toggleable =       FALSE
	var/active =           TRUE
	var/electric =         FALSE //if the glasses should be disrupted by EMP

	var/glasses_hud_type
	var/obj/screen/screen_overlay
	var/obj/item/clothing/glasses/hud/hud // Hud glasses, if any
	var/activation_sound =   'sound/items/goggles_charge.ogg'
	var/deactivation_sound // set this if you want a sound on deactivation
	var/toggle_on_message =  "You activate the optical matrix on $ITEM$."
	var/toggle_off_message = "You deactivate the optical matrix on $ITEM$."

/obj/item/clothing/glasses/Initialize()
	. = ..()
	if(toggleable)
		verbs |= /obj/item/clothing/glasses/proc/toggle
	if(ispath(hud))
		hud = new hud(src)

/obj/item/clothing/glasses/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && active && check_state_in_icon("[overlay.icon_state]-active", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-active"
	. = ..()

/obj/item/clothing/glasses/Destroy()
	qdel(hud)
	hud = null
	. = ..()

/obj/item/clothing/glasses/needs_vision_update()
	return ..() || screen_overlay || vision_flags || see_invisible || darkness_view

/obj/item/clothing/glasses/emp_act(severity)
	if(electric)
		if(ishuman(src.loc))
			var/mob/living/human/M = src.loc
			if(M.get_equipped_item(slot_glasses_str) != src)
				to_chat(M, SPAN_DANGER("\The [src] malfunction[gender != PLURAL ? "s":""], releasing a small spark."))
			else
				SET_STATUS_MAX(M, STAT_BLIND, 2)
				SET_STATUS_MAX(M, STAT_BLURRY, 4)
				to_chat(M, SPAN_DANGER("Your [name] malfunction[gender != PLURAL ? "s":""], blinding you!"))

				// Don't cure being nearsighted
				if(!M.has_genetic_condition(GENE_COND_NEARSIGHTED))
					M.add_genetic_condition(GENE_COND_NEARSIGHTED, 10 SECONDS)

		if(toggleable && active)
			set_active(FALSE)

/obj/item/clothing/glasses/proc/set_active(var/_active)
	if(active != _active)
		active = _active
		update_icon()
		update_clothing_icon()
		update_wearer_vision()

/obj/item/clothing/glasses/on_update_icon()
	. = ..()
	icon_state = ICON_STATE_WORLD
	if(active && check_state_in_icon("[icon_state]-active", icon))
		icon_state = "[icon_state]-active"

/obj/item/clothing/glasses/attack_self(mob/user)
	if(!toggleable || user.incapacitated())
		return TRUE
	set_active(!active)
	if(active)
		if(activation_sound)
			sound_to(user, activation_sound)
		set_active_values()
		to_chat(user, SPAN_NOTICE(capitalize(replacetext(toggle_on_message, "$ITEM$", "\the [src]"))))
	else
		if(deactivation_sound)
			sound_to(user, deactivation_sound)
		set_inactive_values()
		to_chat(user, SPAN_NOTICE(capitalize(replacetext(toggle_off_message, "$ITEM$", "\the [src]"))))
	return TRUE

/obj/item/clothing/glasses/proc/set_active_values()
	flash_protection = initial(flash_protection)
	tint = initial(tint)

/obj/item/clothing/glasses/proc/set_inactive_values()
	flash_protection = FLASH_PROTECTION_NONE
	tint = TINT_NONE

/obj/item/clothing/glasses/update_clothing_icon()
	. = ..()
	if(.)
		var/mob/M = loc
		M.update_action_buttons()

/obj/item/clothing/glasses/proc/toggle()
	set category = "Object"
	set name = "Adjust Eyewear"
	set src in usr
	attack_self(usr)

/obj/item/clothing/glasses/proc/network_setup()
	set name = "Setup HUD Network"
	set category = "Object"
	set src in usr

	var/datum/extension/network_device/D = get_extension(hud || src, /datum/extension/network_device)
	D.ui_interact(usr)
