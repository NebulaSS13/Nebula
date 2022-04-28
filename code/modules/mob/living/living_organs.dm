/mob/living/get_organs()
	for(var/organ in get_external_organs())
		LAZYADD(., organ)
	for(var/organ in get_internal_organs())
		LAZYADD(., organ)

/mob/living/proc/get_external_organs()
	return

/mob/living/proc/get_internal_organs()
	return

//Those are meant to be overriden with optimizations
/mob/living/proc/has_organs()
	return LAZYLEN(get_organs()) > 0

/mob/living/proc/has_external_organs()
	return LAZYLEN(get_external_organs()) > 0

/mob/living/proc/has_internal_organs()
	return LAZYLEN(get_internal_organs()) > 0

//Can be called when we want to add an organ in a detached state or an attached state. 
/mob/living/proc/add_organ(var/obj/item/organ/O, var/obj/item/organ/external/affected = null, var/in_place = FALSE, var/update_icon = TRUE, var/detached = FALSE)
	. = O.do_install(src, affected, in_place, update_icon, detached)
	//Only run install effects if we're not detached and we're not adding in place
	if(!in_place && !(O.status & ORGAN_CUT_AWAY)) 
		on_gained_organ(O)
		updatehealth()
	return TRUE

//Can be called when the organ is detached or attached. 
/mob/living/proc/remove_organ(var/obj/item/organ/O, var/drop_organ = TRUE, var/detach = FALSE, var/ignore_children = FALSE, var/in_place = FALSE, var/update_icon = TRUE)
	//Only run effects if we're not already detached, and we're not doing a in-place removal
	if(!in_place && !(O.status & ORGAN_CUT_AWAY)) //Gotta check the flag here, because of prosthetics handling detached state differently
		on_lost_organ(O)
		
	. = O.do_uninstall(in_place, detach, ignore_children, update_icon)

	if(!in_place)
		updatehealth()
	
	//Shall not drop undroppable things
	if(drop_organ)
		if(O.is_droppable())
			O.dropInto(get_turf(src))
		else
			qdel(O)

//Should handle vital organ checks, icon updates, events
/mob/living/proc/on_lost_organ(var/obj/item/organ/O)
	if(QDELETED(src))
		return FALSE //When deleting don't bother running effects
	events_repository.raise_event(/decl/observ/dismembered, src, O)
	O.on_remove_effects(src)
	return TRUE

/mob/living/proc/on_gained_organ(var/obj/item/organ/O)
	if(QDELETED(src))
		return FALSE //When deleting don't bother running effects
	O.on_add_effects(src)
	return TRUE
