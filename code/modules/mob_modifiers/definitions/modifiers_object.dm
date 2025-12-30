/datum/mob_modifier/object
	var/obj/object = /obj/abstract/follower

/datum/mob_modifier/object/Destroy(force)
	if(istype(object))
		if(owner)
			events_repository.unregister(/decl/observ/moved,   owner, object)
			events_repository.unregister(/decl/observ/dir_set, owner, object)
		QDEL_NULL(object)
	return ..()

/datum/mob_modifier/object/on_modifier_added(skip_update = FALSE)
	. = ..()
	if(istype(owner))
		if(ispath(object))
			object = new object(get_turf(owner))
		if(istype(object))
			events_repository.register(/decl/observ/moved,   owner, object, TYPE_PROC_REF(/obj/abstract/follower, follow_owner))
			events_repository.register(/decl/observ/dir_set, owner, object, TYPE_PROC_REF(/obj/abstract/follower, follow_owner))
