/datum/storage/secure
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE

/datum/storage/secure/open(mob/user)
	var/datum/extension/lockable/lock = get_extension(holder, /datum/extension/lockable)
	if(lock?.locked)
		if(isatom(holder))
			var/atom/atom_holder = holder
			atom_holder.add_fingerprint(user)
		return
	. = ..()

/datum/storage/secure/briefcase
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	use_sound = 'sound/effects/storage/briefcase.ogg'

/datum/storage/secure/safe
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = 56
	cant_hold = list(/obj/item/secure_storage/briefcase)
