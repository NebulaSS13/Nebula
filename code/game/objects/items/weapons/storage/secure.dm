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
	storage_type = /datum/extension/storage/secure
	material = /decl/material/solid/metal/steel
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


/obj/item/storage/secure/handle_mouse_drop(atom/over, mob/user, params)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	if(lock.locked)
		add_fingerprint(user)
		return TRUE
	. = ..()

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
	if(lock.emagged)
		add_overlay(icon_locking)
	else if(lock.open)
		add_overlay(icon_opened)

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
	storage_type = /datum/extension/storage/secure/briefcase
	matter = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/storage/secure/briefcase/attack_hand(mob/user as mob)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	var/datum/extension/lockable/lock   = get_extension(src, /datum/extension/lockable)
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	if(lock && storage)
		if (loc == user && lock.locked)
			to_chat(user, SPAN_WARNING("\The [src] is locked and cannot be opened!"))
			return TRUE
		if (loc == user && !lock.locked)
			storage.open(user)
			add_fingerprint(user)
			return TRUE
	return ..()

// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/items/storage/safe.dmi'
	icon_state = "safe"
	force = 8
	w_class = ITEM_SIZE_STRUCTURE
	anchored = TRUE
	density = FALSE
	lock_type = /datum/extension/lockable/storage/safe
	icon_locking = "safeb"
	icon_opened = "safe0"
	storage_type = /datum/extension/storage/secure/safe

/obj/item/storage/secure/safe/WillContain()
	return list(
		/obj/item/pen,
		/obj/item/paper
	)
