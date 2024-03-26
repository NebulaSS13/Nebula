/datum/storage/tray
	max_storage_space = DEFAULT_BOX_STORAGE
	use_to_pickup = 1
	allow_quick_gather = 1
	use_sound = null

/datum/storage/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	. = ..()
	W.vis_flags = initial(W.vis_flags)
	W.appearance_flags = initial(W.appearance_flags)
	W.update_icon() // in case it updates vis_flags

/datum/storage/tray/gather_all(var/turf/T, var/mob/user)
	..()
	if(isatom(holder))
		var/atom/atom_holder = holder
		atom_holder.update_icon()
