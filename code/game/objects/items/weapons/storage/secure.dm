/*
 *	Absorbs /obj/item/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
/obj/item/storage/secure
	name = "secstorage"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE
	var/lock_type = /datum/extension/lockable/storage
	var/icon_locking = "secureb"
	var/icon_opened = "secure0"

/obj/item/storage/secure/Initialize()
	. = ..()
	set_extension(src, lock_type)

/obj/item/storage/secure/attackby(var/obj/item/W, var/mob/user)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	if(lock.attackby(W, user))
		return

	// -> storage/attackby() what with handle insertion, etc
	if(!lock.locked)
		. = ..()


/obj/item/storage/secure/handle_mouse_drop(atom/over, mob/user)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	if(lock.locked)
		add_fingerprint(user)
		return TRUE
	. = ..()

/obj/item/storage/secure/AltClick(mob/user)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	if(lock.locked)
		src.add_fingerprint(user)
		return
	..()

/obj/item/storage/secure/attack_self(var/mob/user)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	lock.ui_interact(user)

/obj/item/storage/secure/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
		to_chat(user, text("The service panel is [lock.open ? "open" : "closed"]."))

/obj/item/storage/secure/emag_act(var/remaining_charges, var/mob/user, var/feedback)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	.= lock.emag_act(remaining_charges, user, feedback)
	update_icon()

/obj/item/storage/secure/on_update_icon()
	. = ..()

	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	if(!istype(lock))
		return

	overlays.Cut()
	if(lock.emagged)
		overlays += image(icon, icon_locking)
	else if(lock.open)
		overlays += image(icon, icon_opened)


// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/items/storage/briefcase.dmi'
	icon_state = "secure"
	item_state = "sec-case"
	desc = "A large briefcase with a digital locking system."
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	use_sound = 'sound/effects/storage/briefcase.ogg'

/obj/item/storage/secure/briefcase/attack_hand(mob/user as mob)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	if (loc == user && lock.locked)
		to_chat(user, SPAN_WARNING("[src] is locked and cannot be opened!"))
	else if (loc == user && !lock.locked)
		src.open(user)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/items/storage/safe.dmi'
	icon_state = "safe"
	force = 8
	w_class = ITEM_SIZE_STRUCTURE
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = 56
	anchored = 1
	density = 0
	cant_hold = list(/obj/item/storage/secure/briefcase)
	lock_type = /datum/extension/lockable/storage/safe
	icon_locking = "safeb"
	icon_opened = "safe0"

/obj/item/storage/secure/safe/Initialize()
	. = ..()
	new /obj/item/paper(src)
	new /obj/item/pen(src)

/obj/item/storage/secure/safe/attack_hand(mob/user)
	return attack_self(user)
