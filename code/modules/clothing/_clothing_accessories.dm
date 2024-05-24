/obj/item/clothing
	/// If not-null, this clothing can be equipped as an accessory.
	var/accessory_slot
	/// Can this accessory be removed? Defaults to TRUE.
	var/accessory_removable
	/// How should this accessory behave on mob examine?
	var/accessory_visibility = ACCESSORY_VISIBILITY_ENSEMBLE
	/// Used when an accessory is meant to slow the wearer down when attached to clothing
	var/accessory_slowdown
	/// What clothing states should hide this accessory?
	var/list/accessory_hide_on_states

/obj/item/clothing/proc/get_initial_accessory_hide_on_states()
	return null

/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory, mob/user)
	if(!length(valid_accessory_slots))
		to_chat(user, SPAN_WARNING("You cannot attach accessories of any kind to \the [src]."))
		return FALSE
	if(!istype(accessory) || isnull(accessory.accessory_slot) || !(accessory.accessory_slot in valid_accessory_slots))
		to_chat(user, SPAN_WARNING("You cannot attach accessories of this kind to \the [src]."))
		return FALSE
	if(LAZYLEN(accessories) && restricted_accessory_slots && (accessory.accessory_slot in restricted_accessory_slots))
		for(var/obj/item/clothing/other_accessory in accessories)
			if (other_accessory.accessory_slot == accessory.accessory_slot)
				to_chat(user, SPAN_WARNING("You cannot attach more accessories of this kind to \the [src]."))
				return FALSE
	return TRUE

// Override for action buttons.
/obj/item/clothing/attack_self(mob/user)
	if(loc == user)
		if(user.get_active_held_item() != src)
			return attack_hand_with_interaction_checks(user)
		// Adjust our clothing state.
		if(length(clothing_state_modifiers))
			var/decl/clothing_state_modifier/modifier
			if(length(clothing_state_modifiers) == 1)
				modifier = GET_DECL(clothing_state_modifiers[1])
			else
				var/list/choices = list()
				for(var/modifier_type in clothing_state_modifiers)
					choices += GET_DECL(modifier_type)
				modifier = input(user, "How do you want to interact with \the [src]?", "Adjust Clothing") as null|anything in choices
				if(!modifier || QDELETED(src) || QDELETED(user) || !(modifier.type in clothing_state_modifiers) || (loc != user))
					return TRUE
			if(modifier)
				call(modifier.toggle_verb)()
			return TRUE
	return ..()

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)

	if(istype(I, /obj/item/clothing))

		var/obj/item/clothing/accessory = I
		if(!isnull(accessory.accessory_slot))
			if(can_attach_accessory(accessory, user))
				if(user.try_unequip(accessory))
					attach_accessory(user, accessory)
			else
				to_chat(user, SPAN_WARNING("You cannot attach \the [I] to \the [src]."))
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
 *  Attach accessory accessory to src
 *
 *  user is the user doing the attaching. Can be null, such as when attaching
 *  items on spawn
 */
/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory)
	if(accessory in accessories)
		return
	accessory.on_attached(src, user)
	if(accessory.accessory_removable)
		src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory)
	if(!accessory || !(accessory in accessories) || !accessory.accessory_removable || !accessory.canremove)
		return
	accessory.on_removed(user)
	update_icon()

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

// Make 'strict' a bit less strict, for accessories.
// If we're checking strictly and our parent is an accessory,
// This will need to be handled differently if we ever allow non-clothing accessories!
/obj/item/clothing/can_interact_with_storage(user, strict = FALSE)
	if(!istype(loc, /obj/item/clothing) || !strict)
		return ..()
	. = ..(user, FALSE) // Ignore the parent strictness check.
	if(.)
		return .
	if(istype(loc, /obj/item/clothing))
		var/obj/item/clothing/parent = loc
		return (src in parent.accessories) && loc.can_interact_with_storage(user, strict)
	return user == loc // Same as in parent, since we pass strict = FALSE to it.

/obj/item/clothing/can_be_picked_up(mob/user)
	. = ..()
	var/obj/item/clothing/parent = loc
	return . && (!istype(parent) || !(src in parent.accessories))

/obj/item/clothing/attack_hand(var/mob/user)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(!length(accessories) || loc != user)
		return ..()
	for(var/obj/item/clothing/accessory in accessories)
		. = accessory.attack_hand(user) || .
	return TRUE

/obj/item/clothing/proc/on_attached(var/obj/item/clothing/holder, var/mob/user)
	if(istype(holder))
		forceMove(holder)
		if(user)
			to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [holder]."))
			add_fingerprint(user)
		LAZYADD(holder.accessories, src)
		holder.update_clothing_toggle_verbs()
		holder.update_accessory_slowdown()
		holder.update_icon()
		holder.update_clothing_icon()
		return TRUE
	return FALSE

/obj/item/clothing/proc/on_removed(var/mob/user)
	var/obj/item/clothing/holder = loc
	if(istype(holder))
		if(user)
			to_chat(user, SPAN_NOTICE("You remove \the [src] from \the [holder]."))
			user.put_in_hands(src)
			add_fingerprint(user)
		else
			dropInto(loc)
		LAZYREMOVE(holder.accessories, src)
		update_clothing_toggle_verbs()
		holder.update_clothing_toggle_verbs()
		holder.update_accessory_slowdown()
		holder.update_icon()
		holder.update_clothing_icon()
		return TRUE
	return FALSE

/obj/item/clothing/proc/should_overlay()
	. = is_accessory()
	if(. && istype(loc, /obj/item/clothing))
		var/obj/item/clothing/uniform = loc
		if(uniform.should_hide_accessory(accessory_hide_on_states))
			return FALSE

/obj/item/clothing/OnDisguise(obj/item/copy, mob/user)
	. = ..()
	if(!QDELETED(copy))
		fallback_slot = copy.get_fallback_slot()

	if(istype(copy, /obj/item/clothing))
		var/obj/item/clothing/clothes = copy
		accessory_hide_on_states  = clothes.accessory_hide_on_states?.Copy()
		accessory_slot            = clothes.accessory_slot
		accessory_removable       = clothes.accessory_removable
		accessory_visibility      = clothes.accessory_visibility
		accessory_slowdown        = clothes.accessory_slowdown
		mimicking_state_modifiers = TRUE
		clothing_state_modifiers = clothes.clothing_state_modifiers?.Copy()
	else
		accessory_hide_on_states  = get_initial_accessory_hide_on_states()
		accessory_slot            = initial(accessory_slot)
		accessory_removable       = initial(accessory_removable)
		accessory_visibility      = initial(accessory_visibility)
		accessory_slowdown        = initial(accessory_slowdown)
		mimicking_state_modifiers = FALSE
		clothing_state_modifiers  = null

	update_clothing_state_toggles()
