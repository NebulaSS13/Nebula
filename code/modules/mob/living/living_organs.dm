/mob/living/proc/get_organs_by_categories(var/category)
	return

//Those are meant to be overriden with optimizations
/mob/living/proc/has_organs()
	return LAZYLEN(get_organs()) > 0

/mob/living/proc/has_external_organs()
	return LAZYLEN(get_external_organs()) > 0

/mob/living/proc/has_internal_organs()
	return LAZYLEN(get_internal_organs()) > 0

/mob/living/get_contained_matter(include_reagents = TRUE)
	. = ..()
	for(var/obj/item/organ in get_organs())
		. = MERGE_ASSOCS_WITH_NUM_VALUES(., organ.get_contained_matter(include_reagents))

//Can be called when we want to add an organ in a detached state or an attached state.
/mob/living/proc/add_organ(var/obj/item/organ/O, var/obj/item/organ/external/affected = null, var/in_place = FALSE, var/update_icon = TRUE, var/detached = FALSE, var/skip_health_update = FALSE)
	. = O.do_install(src, affected, in_place, update_icon, detached)
	//Only run install effects if we're not detached and we're not adding in place
	if(!in_place && !(O.status & ORGAN_CUT_AWAY))
		on_gained_organ(O)
		if(!skip_health_update)
			update_health()
	return TRUE

//Can be called when the organ is detached or attached.
/mob/living/proc/remove_organ(var/obj/item/organ/O, var/drop_organ = TRUE, var/detach = FALSE, var/ignore_children = FALSE, var/in_place = FALSE, var/update_icon = TRUE, var/skip_health_update = FALSE)
	//Only run effects if we're not already detached, and we're not doing a in-place removal
	if(!in_place && !(O.status & ORGAN_CUT_AWAY)) //Gotta check the flag here, because of prosthetics handling detached state differently
		on_lost_organ(O)

	. = O.do_uninstall(in_place, detach, ignore_children, update_icon)
	if(.)

		if(client)
			client.screen -= O

		if(!skip_health_update)
			update_health()

		if(drop_organ)
			var/drop_loc = get_turf(src)
			O.dropInto(drop_loc)
			if(!BP_IS_PROSTHETIC(O))
				playsound(drop_loc, 'sound/effects/squelch1.ogg', 15, 1)
			else
				playsound(drop_loc, 'sound/items/Ratchet.ogg', 50, 1)

//Should handle vital organ checks, icon updates, events
/mob/living/proc/on_lost_organ(var/obj/item/organ/O)
	if(QDELETED(src))
		return FALSE //When deleting don't bother running effects
	RAISE_EVENT(/decl/observ/dismembered, src, O)
	O.on_remove_effects(src)
	return TRUE

/mob/living/proc/on_gained_organ(var/obj/item/organ/O)
	if(QDELETED(src))
		return FALSE //When deleting don't bother running effects
	O.on_add_effects(src)
	return TRUE

/mob/living/proc/delete_organs()
	SHOULD_CALL_PARENT(TRUE)
	for(var/datum/organ in get_organs())
		if(istype(organ, /obj/item/organ/internal))
			var/obj/item/organ/internal/innard = organ
			innard.transfer_brainmob_with_organ = FALSE // Don't boot our current client.
		qdel(organ)
