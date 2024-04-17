/obj/structure
	var/datum/lock/lock

/obj/structure/proc/try_key_unlock(obj/item/I, mob/user)
	if(!lock)
		return FALSE
	if(istype(I, /obj/item/key))
		if(lock.toggle(I))
			to_chat(user, SPAN_NOTICE("You [lock.status ? "lock" : "unlock"] \the [src] with \the [I]."))
		else
			to_chat(user, SPAN_WARNING("\The [I] does not fit in the lock!"))
		return TRUE
	if(istype(I, /obj/item/keyring))
		for(var/obj/item/key/key in I)
			if(lock.toggle(key))
				to_chat(user, SPAN_NOTICE("You [lock.status ? "lock" : "unlock"] \the [src] with \the [key]."))
				return TRUE
		to_chat(user, SPAN_WARNING("\The [I] has no keys that fit in the lock!"))
		return TRUE
	if(lock.pick_lock(I,user))
		return TRUE
	if(lock.isLocked())
		to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		return TRUE
	return FALSE

/obj/structure/proc/can_install_lock()
	return FALSE

/obj/structure/proc/try_install_lock(obj/item/I, mob/user)
	if(!istype(I, /obj/item/lock_construct) || !can_install_lock())
		return FALSE
	if(lock)
		to_chat(user, SPAN_WARNING("\The [src] already has a lock."))
	else
		var/obj/item/lock_construct/L = I
		lock = L.create_lock(src,user)
	return TRUE

/obj/structure/proc/try_unlock(mob/user, obj/item/held)
	if(!istype(user) || !istype(held) || !lock)
		return FALSE
	if(!lock.isLocked())
		return TRUE
	if(user?.a_intent == I_HELP && (istype(held, /obj/item/key) || istype(held, /obj/item/keyring)))
		try_key_unlock(held, user)
	if(!lock.isLocked())
		return TRUE
	return FALSE
