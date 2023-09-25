// Cannot be removed or replaced.
/datum/extension/loaded_cell/unremovable/try_load(var/mob/user, var/obj/item/cell/cell)
	to_chat(user, SPAN_WARNING("\The [holder]'s power supply cannot be replaced."))
	return TRUE

/datum/extension/loaded_cell/unremovable/try_unload(var/mob/user, var/obj/item/tool)
	if(tool)
		to_chat(user, SPAN_WARNING("\The [holder]'s power supply cannot be removed."))
		return TRUE // Tool interactions should get a warning, inhand interactions should just default to regular attack_hand.
	return FALSE
