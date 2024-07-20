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
/obj/item/secure_storage
	name = "secure storage (abstract)"
	w_class = ITEM_SIZE_NORMAL
	storage = /datum/storage/secure
	material = /decl/material/solid/metal/steel
	abstract_type = /obj/item/secure_storage
	///The type of lockable extension to use for this secure storage.
	var/lock_type = /datum/extension/lockable/storage
	///An overlay displayed while the thing is being hacked
	var/overlay_hack       = "overlay-hack"
	///An overlay displayed after the thing has been emagged
	var/overlay_emagged    = "overlay-emagged"
	///An overlay displayed while it's locked
	var/overlay_locked     = "overlay-locked"
	///An overlay displayed while it's unlocked
	var/overlay_unlocked   = "overlay-unlocked"
	///An overlay displayed while the service panel is opened
	var/overlay_panel_open = "overlay-panel-open"

/obj/item/secure_storage/Initialize(ml, material_key)
	var/datum/extension/lockable/mylock = get_or_create_extension(src, lock_type)
	events_repository.register(/decl/observ/lock_state_changed, mylock, src, /obj/item/secure_storage/proc/on_lock_state_changed)
	. = ..()

/obj/item/secure_storage/Destroy()
	var/datum/extension/lockable/mylock = get_extension(src, lock_type)
	events_repository.unregister(/decl/observ/lock_state_changed, mylock, src, /obj/item/secure_storage/proc/on_lock_state_changed)
	. = ..()

/obj/item/secure_storage/proc/on_lock_state_changed(datum/extension/lockable/L, old_locked, new_locked)
	if(new_locked == old_locked)
		return
	//Make sure we close all uis when we turn the lock on
	if(new_locked)
		storage?.close_all()

/obj/item/secure_storage/attackby(obj/item/W, mob/user)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	if(lock.attackby(W, user))
		return

	// -> storage/attackby() what with handle insertion, etc
	if(!lock.locked)
		. = ..()

/obj/item/secure_storage/handle_mouse_drop(atom/over, mob/user, params)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	if(lock.locked)
		add_fingerprint(user)
		return TRUE
	. = ..()

/obj/item/secure_storage/attack_self(mob/user)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	lock.ui_interact(user)

/obj/item/secure_storage/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
		to_chat(user, SPAN_INFO("The service panel is [lock.open ? "open" : "closed"]."))

/obj/item/secure_storage/emag_act(remaining_charges, mob/user, feedback)
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	. = lock.emag_act(remaining_charges, user, feedback)
	update_icon()

/obj/item/secure_storage/on_update_icon()
	. = ..()
	var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
	//If update icon is called and the lock hasn't been initialized yet for whatever reasons, just skip
	if(!istype(lock))
		return

	//Add sevice panel overlay if service panel is opened
	if(lock.open && length(overlay_panel_open))
		add_overlay("[icon_state]-[overlay_panel_open]")

	//Pick and add the right LED panel overlay
	if(lock.l_hacking && length(overlay_hack))
		add_overlay("[icon_state]-[overlay_hack]")
	else if(lock.emagged && length(overlay_emagged))
		add_overlay("[icon_state]-[overlay_emagged]")
	else if(!lock.locked && length(overlay_unlocked))
		add_overlay("[icon_state]-[overlay_unlocked]")
	else if(length(overlay_locked))
		add_overlay("[icon_state]-[overlay_locked]")

// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/secure_storage/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/items/storage/briefcase_secure.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "A large briefcase with a digital locking system."
	_base_attack_force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	storage = /datum/storage/secure/briefcase
	matter = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/secure_storage/briefcase/attack_hand(mob/user as mob)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	var/datum/extension/lockable/lock   = get_extension(src, /datum/extension/lockable)
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

//#TODO: Move to a structure, so we don't have to deal with the item pickup code.
/obj/item/secure_storage/safe
	name = "secure safe"
	icon = 'icons/obj/items/storage/safe.dmi'
	icon_state = ICON_STATE_WORLD
	overlay_panel_open = null //TODO: Add service panel open overlay
	_base_attack_force = 8
	w_class = ITEM_SIZE_STRUCTURE
	anchored = TRUE
	density = FALSE
	lock_type = /datum/extension/lockable/storage/safe
	storage = /datum/storage/secure/safe

/obj/item/secure_storage/safe/WillContain()
	return list(
		/obj/item/pen,
		/obj/item/paper
	)

/obj/item/secure_storage/safe/attack_hand(mob/user)
	//The safe acts kinda weird because it's an item that cannot be picked up by default, and we need a way to open the ui.
	// I added this so if it can be picked up at all, it'll behave like any items. And otherwise it'll open the UI.
	// The storage extension will cause the base item class to automatically add an alt-interaction to open the storage.
	if(!can_be_picked_up(user))
		var/datum/extension/lockable/lock = get_extension(src, /datum/extension/lockable)
		lock.ui_interact(user)
		return TRUE
	. = ..()

/obj/item/secure_storage/safe/empty/WillContain()
	return
