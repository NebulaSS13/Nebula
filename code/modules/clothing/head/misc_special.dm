/*
 * Contents:
 *		Welding mask
 *		Cakehat
 *		Ushanka
 *		Pumpkin head
 *		Kitty ears
 *
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/welding/default.dmi'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT
	)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
	)
	flags_inv = (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	action_button_name = "Flip Welding Mask"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY
	replaced_in_loadout = FALSE
	var/up = 0
	var/base_state

/obj/item/clothing/head/welding/attack_self()
	if(!base_state)
		base_state = icon_state
	toggle()

/obj/item/clothing/head/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding mask"
	set src in usr

	if(CanPhysicallyInteract(usr))
		if(src.up)
			src.up = !src.up
			body_parts_covered |= (SLOT_EYES|SLOT_FACE)
			flags_inv |= (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You flip the [src] down to protect your eyes.")
		else
			src.up = !src.up
			body_parts_covered &= ~(SLOT_EYES|SLOT_FACE)
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			flags_inv &= ~(HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			to_chat(usr, "You push the [src] up out of your face.")
		update_icon()
		update_wearer_vision()
		usr.update_action_buttons()

/obj/item/clothing/head/welding/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(up && check_state_in_icon("[icon_state]_up", icon))
		icon_state = "[icon_state]_up"
	update_clothing_icon()	//so our mob-overlays

/obj/item/clothing/head/welding/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && up && check_state_in_icon("[overlay.icon_state]_up", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]_up"
	. = ..()

/obj/item/clothing/head/welding/demon
	name = "demonic welding helmet"
	desc = "A painted welding helmet, this one has a demonic face on it."
	icon = 'icons/clothing/head/welding/demon.dmi'

/obj/item/clothing/head/welding/knight
	name = "knightly welding helmet"
	desc = "A painted welding helmet, this one looks like a knights helmet."
	icon = 'icons/clothing/head/welding/knight.dmi'

/obj/item/clothing/head/welding/fancy
	name = "fancy welding helmet"
	desc = "A painted welding helmet, the black and gold make this one look very fancy."
	icon = 'icons/clothing/head/welding/fancy.dmi'

/obj/item/clothing/head/welding/engie
	name = "engineering welding helmet"
	desc = "A painted welding helmet, this one has been painted the engineering colours."
	icon = 'icons/clothing/head/welding/engie.dmi'

/obj/item/clothing/head/welding/carp
	name = "carp welding helmet"
	desc = "A painted welding helmet, this one has a carp face on it."
	icon = 'icons/clothing/head/welding/carp.dmi'

/*
 * Ushanka
 */
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/ushanka.dmi'
	flags_inv = HIDEEARS|BLOCK_HEAD_HAIR
	cold_protection = SLOT_HEAD | SLOT_EARS
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	var/up = FALSE

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	..()
	up = !up
	to_chat(user, "You [up ? "raise" : "lower"] the ear flaps on the ushanka.")
	update_icon()

/obj/item/clothing/head/ushanka/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(up && check_state_in_icon("[icon_state]_up", icon))
		icon_state = "[icon_state]_up"
	update_clothing_icon()

/obj/item/clothing/head/ushanka/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && up && check_state_in_icon("[overlay.icon_state]_up", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]_up"
	. = ..()

/*
 * Pumpkin head
 */
/obj/item/clothing/head/pumpkinhead
	name = "carved pumpkin"
	desc = "A jack o' lantern! Believed to ward off evil spirits."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/pumpkin.dmi'
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCK_ALL_HAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	brightness_on = 2
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/organic/plantmatter
	var/plant_type = "pumpkin"

// Duplicated from growns for now. TODO: move sliceability down to other objects like clay.
/obj/item/clothing/head/pumpkinhead/attackby(obj/item/W, mob/user)
	if(IS_KNIFE(W) && user.a_intent != I_HURT)
		var/datum/seed/plant = SSplants.seeds[plant_type]
		if(!plant)
			return ..()
		var/slice_amount = plant.slice_amount
		if(W.w_class > ITEM_SIZE_NORMAL || !user.skill_check(SKILL_COOKING, SKILL_BASIC))
			user.visible_message(
				SPAN_NOTICE("\The [user] crudely slices \the [src] with \the [W]!"),
				SPAN_NOTICE("You crudely slice \the [src] with your [W.name]!")
			)
			slice_amount = rand(1, max(1, round(slice_amount*0.5)))
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] slices \the [src]!"),
				SPAN_NOTICE("You slice \the [src]!")
			)
		for(var/i = 1 to slice_amount)
			new /obj/item/food/processed_grown/chopped(loc, null, TRUE, plant)
		qdel(src)
		return TRUE
	return ..()

/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/cat.dmi'
	body_parts_covered = 0
	siemens_coefficient = 1.5
	flags_inv = 0
	armor = null

/obj/item/clothing/head/richard
	name = "chicken mask"
	desc = "You can hear the distant sounds of rhythmic electronica."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/richard.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_FACE
	flags_inv = BLOCK_ALL_HAIR

// Return of the cake hat.
/obj/item/clothing/head/cakehat
	name = "cake-hat"
	desc = "It's tasty looking!"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/cakehat.dmi'
	body_parts_covered = SLOT_HEAD
	item_flags = null
	var/is_on_fire = FALSE

/obj/item/clothing/head/cakehat/equipped(mob/user, slot)
	. = ..()
	update_icon()

/obj/item/clothing/head/cakehat/dropped(mob/user)
	. = ..()
	update_icon()

/obj/item/clothing/head/cakehat/on_update_icon(mob/user)
	. = ..()
	z_flags &= ~ZMM_MANGLE_PLANES
	if(is_on_fire && check_state_in_icon("[icon_state]-flame", icon))
		if(plane == HUD_PLANE)
			add_overlay("[icon_state]-flame")
		else
			add_overlay(emissive_overlay(icon, "[icon_state]-flame"))
			z_flags |= ZMM_MANGLE_PLANES

// Overidable so species with limited headspace in the sprite bounding area can offset it (scavs)
/obj/item/clothing/head/cakehat/proc/get_mob_flame_overlay(var/image/overlay, var/bodytype)
	if(overlay && check_state_in_icon("[overlay.icon_state]-flame", overlay.icon))
		return emissive_overlay(overlay.icon, "[overlay.icon_state]-flame")

/obj/item/clothing/head/cakehat/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && is_on_fire)
		var/image/I = get_mob_flame_overlay(overlay, bodytype)
		if(I)
			overlay.overlays += I
	return ..()

/obj/item/clothing/head/cakehat/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/head/cakehat/Process()
	if(!is_on_fire)
		STOP_PROCESSING(SSobj, src)
		return
	var/turf/location = loc
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_equipped_item(slot_head_str) == src || (src in M.get_held_items()))
			location = M.loc
	if(istype(location))
		location.hotspot_expose(700, 1)

/obj/item/clothing/head/cakehat/attack_self(mob/user)
	. = ..()
	if(!.)
		is_on_fire = !is_on_fire
		update_icon()
		if(is_on_fire)
			atom_damage_type = BURN
			START_PROCESSING(SSobj, src)
		else
			force = null
			atom_damage_type = BRUTE
			STOP_PROCESSING(SSobj, src)
		return TRUE
