/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory/A)
	if(valid_accessory_slots && istype(A) && (A.slot in valid_accessory_slots))
		.=1
	else
		return 0
	if(accessories.len && restricted_accessory_slots && (A.slot in restricted_accessory_slots))
		for(var/obj/item/clothing/accessory/AC in accessories)
			if (AC.slot == A.slot)
				return 0

// Override for action buttons.
/obj/item/clothing/attack_self(mob/user)
	if(loc == user && user.get_active_held_item() != src)
		return attack_hand_with_interaction_checks(user)
	return ..()

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing/accessory))

		if(!valid_accessory_slots || !valid_accessory_slots.len)
			to_chat(usr, "<span class='warning'>You cannot attach accessories of any kind to \the [src].</span>")
			return

		var/obj/item/clothing/accessory/A = I
		if(can_attach_accessory(A))
			if(!user.try_unequip(A))
				return
			attach_accessory(user, A)
			return
		else
			to_chat(user, "<span class='warning'>You cannot attach more accessories of this type to [src].</span>")
		return

	if(length(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attackby(I, user)
		return

	. = ..()

/obj/item/clothing/attack_hand(var/mob/user)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(!length(accessories) || loc != user)
		return ..()
	for(var/obj/item/clothing/accessory/A in accessories)
		. = A.attack_hand(user) || .
	return TRUE

/obj/item/clothing/proc/update_accessory_slowdown()
	slowdown_accessory = 0
	for(var/obj/item/clothing/accessory/A in accessories)
		slowdown_accessory += A.slowdown

/**
 *  Attach accessory A to src
 *
 *  user is the user doing the attaching. Can be null, such as when attaching
 *  items on spawn
 */
/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory/A)
	if(A in accessories)
		return
	accessories += A
	A.on_attached(src, user)
	if(A.removable)
		src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_accessory_slowdown()
	update_icon()
	update_clothing_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!A || !(A in accessories) || !A.removable || !A.canremove)
		return

	A.on_removed(user)
	accessories -= A
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
	for(var/obj/item/clothing/accessory/accessory in accessories)
		if(accessory.canremove && accessory.removable)
			removable_accessories += accessory

	if(!length(removable_accessories))
		to_chat(usr, SPAN_WARNING("You have no removable accessories."))
		verbs -= /obj/item/clothing/proc/removetie_verb
		return

	var/obj/item/clothing/accessory/A
	if(LAZYLEN(removable_accessories) > 1)
		A = show_radial_menu(M, M, make_item_radial_menu_choices(removable_accessories), radius = 42, tooltips = TRUE)
	else
		A = removable_accessories[1]

	remove_accessory(usr, A)

	if(!LAZYLEN(accessories))
		verbs -= /obj/item/clothing/proc/removetie_verb

/obj/item/clothing/emp_act(severity)
	if(length(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
	..()