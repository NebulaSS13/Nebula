/obj/item/clothing
	var/accessory_slot
	var/accessory_removable = FALSE
	/// if it should appear on examine without detailed view
	var/accessory_high_visibility
	/// used when an accessory is meant to slow the wearer down when attached to clothing
	var/accessory_slowdown
	var/accessory_hide_on_uniform_rolldown = FALSE
	var/accessory_hide_on_uniform_rollsleeves = FALSE


/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory)
	if(valid_accessory_slots && istype(accessory) && !isnull(accessory.accessory_slot) && (accessory.accessory_slot in valid_accessory_slots))
		. = 1
	else
		return 0
	if(LAZYLEN(accessories) && restricted_accessory_slots && (accessory.accessory_slot in restricted_accessory_slots))
		for(var/obj/item/clothing/other_accessory in accessories)
			if (other_accessory.accessory_slot == accessory.accessory_slot)
				return 0

// Override for action buttons.
/obj/item/clothing/attack_self(mob/user)
	if(loc == user && user.get_active_held_item() != src)
		return attack_hand_with_interaction_checks(user)
	return ..()

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing))

		var/obj/item/clothing/accessory = I
		if(!isnull(accessory.accessory_slot))

			if(!valid_accessory_slots || !valid_accessory_slots.len)
				to_chat(usr, SPAN_WARNING("You cannot attach accessories of any kind to \the [src]."))
				return TRUE

			if(can_attach_accessory(accessory))
				if(user.try_unequip(accessory))
					attach_accessory(user, accessory)
			else
				to_chat(user, SPAN_WARNING("You cannot attach more accessories of this type to [src]."))
			return TRUE

	if(length(accessories))
		for(var/obj/item/clothing/accessory in accessories)
			accessory.attackby(I, user)
		return

	. = ..()

/obj/item/clothing/proc/update_accessory_slowdown()
	slowdown_accessory = 0
	for(var/obj/item/clothing/accessory in accessories)
		slowdown_accessory += accessory.accessory_slowdown

/**
 *  Attach accessory A to src
 *
 *  user is the user doing the attaching. Can be null, such as when attaching
 *  items on spawn
 */
/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory)
	if(accessory in accessories)
		return
	LAZYADD(accessories, accessory)
	accessory.on_attached(src, user)
	if(accessory.accessory_removable)
		src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_accessory_slowdown()
	update_icon()
	update_clothing_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory)
	if(!accessory || !(accessory in accessories) || !accessory.accessory_removable || !accessory.canremove)
		return

	accessory.on_removed(user)
	LAZYREMOVE(accessories, accessory)
	update_accessory_slowdown()
	update_icon()
	update_clothing_icon()

/obj/item/clothing/proc/removetie_verb()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr

	if(!isliving(usr))
		return

	var/mob/living/M = usr

	if(M.stat)
		return

	if(!LAZYLEN(accessories))
		return

	var/list/removable_accessories = list()
	for(var/obj/item/clothing/accessory in accessories)
		if(accessory.canremove && accessory.accessory_removable)
			removable_accessories += accessory

	if(!length(removable_accessories))
		to_chat(usr, SPAN_WARNING("You have no removable accessories."))
		verbs -= /obj/item/clothing/proc/removetie_verb
		return

	var/obj/item/clothing/accessory
	if(LAZYLEN(removable_accessories) > 1)
		accessory = show_radial_menu(M, M, make_item_radial_menu_choices(removable_accessories), radius = 42, tooltips = TRUE)
	else
		accessory = removable_accessories[1]

	remove_accessory(usr, accessory)

	if(!LAZYLEN(accessories))
		verbs -= /obj/item/clothing/proc/removetie_verb

/obj/item/clothing/emp_act(severity)
	if(length(accessories))
		for(var/obj/item/clothing/accessory in accessories)
			accessory.emp_act(severity)
	..()

/obj/item/clothing/attack_hand(var/mob/user)
	if(istype(loc, /obj/item/clothing))
		return TRUE //we aren't an object on the ground so don't call parent
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(!length(accessories) || loc != user)
		return ..()
	for(var/obj/item/clothing/accessory in accessories)
		. = accessory.attack_hand(user) || .
	return TRUE

/obj/item/clothing/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(istype(S))
		forceMove(S)
		if(user)
			to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [S]."))
			src.add_fingerprint(user)

/obj/item/clothing/proc/on_removed(var/mob/user)
	var/obj/item/clothing/suit = loc
	if(istype(suit))
		if(user)
			usr.put_in_hands(src)
			src.add_fingerprint(user)
		else
			dropInto(loc)

/obj/item/clothing/proc/should_overlay()
	. = istype(loc, /obj/item/clothing)
	if(. && istype(loc, /obj/item/clothing/under))
		var/obj/item/clothing/under/uniform = loc
		if(uniform.rolled_down && accessory_hide_on_uniform_rolldown)
			return FALSE
		if(uniform.rolled_sleeves && accessory_hide_on_uniform_rollsleeves)
			return FALSE

/obj/item/clothing/proc/get_attached_overlay_state()
	return "attached"

/obj/item/clothing/proc/get_attached_inventory_overlay(var/base_state)
	var/find_state = "[base_state]-[get_attached_overlay_state()]"
	if(find_state && check_state_in_icon(find_state, icon))
		var/image/ret = image(icon, find_state)
		ret.color = color
		return ret
