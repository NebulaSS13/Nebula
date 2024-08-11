#define LOCK_LOCKED 1
#define LOCK_BROKEN 2

/obj/abstract/landmark/lock_preset
	name = "locked door"
	var/lock_preset_id  = "default"
	var/lock_material   = /decl/material/solid/metal/iron
	var/lock_complexity = 1

/obj/abstract/landmark/lock_preset/Initialize()
	..()
	for(var/obj/structure/thing in loc)
		if(!thing.lock && thing.can_install_lock())
			thing.lock = new /datum/lock(thing, lock_preset_id, lock_material)
			thing.update_icon()
	return INITIALIZE_HINT_QDEL

/datum/lock
	var/status = 1 //unlocked, 1 == locked 2 == broken
	var/lock_data = "" //basically a randomized string. The longer the string the more complex the lock.
	var/atom/holder
	var/material

/datum/lock/New(var/atom/h, var/complexity = 1, var/mat)
	holder = h
	if(istext(complexity))
		lock_data = complexity
	else
		lock_data = generateRandomString(complexity)
	material = mat || /decl/material/solid/metal/iron

/datum/lock/Destroy()
	holder = null
	. = ..()

/datum/lock/proc/unlock(var/key = "", var/mob/user)
	if(!isLocked())
		to_chat(user, SPAN_WARNING("It's already unlocked!"))
		return FALSE
	key = get_key_data(key, user)
	if(cmptextEx(lock_data,key) && !(status & LOCK_BROKEN))
		status &= ~LOCK_LOCKED
		return TRUE
	return FALSE

/datum/lock/proc/lock(var/key = "", var/mob/user)
	if(isLocked())
		to_chat(user, SPAN_WARNING("It's already locked!"))
		return FALSE
	key = get_key_data(key, user)
	if(cmptextEx(lock_data,key) && !(status & LOCK_BROKEN))
		status |= LOCK_LOCKED
		return TRUE
	return FALSE

/datum/lock/proc/toggle(var/key = "", var/mob/user)
	return isLocked() ? unlock(key, user) : lock(key, user)

/datum/lock/proc/getComplexity()
	return length(lock_data)

/datum/lock/proc/get_key_data(var/key = "", var/mob/user)
	if(istype(key,/obj/item/key))
		var/obj/item/key/K = key
		return K.get_data(user)
	if(istext(key))
		return key
	return null

/datum/lock/proc/isLocked()
	return status & LOCK_LOCKED

/datum/lock/proc/pick_lock(var/obj/item/I, var/mob/user)
	if(!istype(I) || !isLocked())
		return FALSE
	var/unlock_power = I.lock_picking_level
	if(!unlock_power)
		return FALSE
	user.visible_message("<b>\The [user]</b> begins to pick \the [holder]'s lock with \the [I].", SPAN_NOTICE("You begin picking \the [holder]'s lock."))
	if(!do_after(user, 2 SECONDS, holder))
		return FALSE
	if(prob(20*(unlock_power/getComplexity())))
		to_chat(user, SPAN_NOTICE("You pick open \the [holder]'s lock!"))
		unlock(lock_data)
		return TRUE
	else if(prob(5 * unlock_power))
		to_chat(user, SPAN_WARNING("You accidentally break \the [I]!"))
		I.physically_destroyed()
	else
		to_chat(user, SPAN_WARNING("You fail to pick open \the [holder]."))
	return FALSE