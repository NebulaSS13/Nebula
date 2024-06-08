/datum/storage/secure
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE

///Helper proc for getting the locked state of the secure storage
/datum/storage/secure/proc/is_locked()
	var/datum/extension/lockable/lock = get_extension(holder, /datum/extension/lockable)
	return lock?.locked

/datum/storage/secure/open(mob/user)
	if(is_locked())
		if(isatom(holder))
			var/atom/atom_holder = holder
			atom_holder.add_fingerprint(user)
		return
	. = ..()

//Must be overriden to prevent gathering from tile and using on items when locked!
/datum/storage/secure/can_be_inserted(obj/item/W, mob/user, stop_messages)
	if(is_locked())
		if(!stop_messages)
			to_chat(user, SPAN_WARNING("\The [holder] is locked, you cannot put anything inside."))
		return FALSE
	return ..()

//Must be overriden to prevent the quick empty verb from bypassing the lock
/datum/storage/secure/quick_empty(mob/user, turf/dump_loc)
	if(is_locked())
		to_chat(user, SPAN_WARNING("\The [holder] is locked, you cannot empty it."))
		return
	return ..()

/datum/storage/secure/briefcase
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	use_sound = 'sound/effects/storage/briefcase.ogg'
	open_sound = 'sound/items/containers/briefcase_unlock.ogg'
	close_sound = 'sound/items/containers/briefcase_lock.ogg'

/datum/storage/secure/safe
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = 56
	cant_hold = list(/obj/item/secure_storage/briefcase)
	use_sound = 'sound/effects/storage/box.ogg'
	open_sound = 'sound/effects/closet_open.ogg'
	close_sound = 'sound/effects/closet_close.ogg'
