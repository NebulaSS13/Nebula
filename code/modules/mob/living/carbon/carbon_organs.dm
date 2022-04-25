/mob/living/carbon/get_organ(var/organ_tag)
	return LAZYACCESS(organs_by_tag, organ_tag)

/mob/living/carbon/get_external_organs()
	return external_organs

/mob/living/carbon/get_internal_organs()
	return internal_organs

/mob/living/carbon/has_organs()
	return (LAZYLEN(external_organs) + LAZYLEN(internal_organs)) > 0

/mob/living/carbon/has_external_organs()
	return LAZYLEN(external_organs) > 0

/mob/living/carbon/has_internal_organs()
	return LAZYLEN(internal_organs) > 0

//Deletes all references to organs
/mob/living/carbon/proc/delete_organs()
	for(var/obj/item/organ/O in get_organs())
		qdel(O)
	organs_by_tag = null
	internal_organs = null
	external_organs = null

/mob/living/carbon/add_organ(obj/item/organ/O, obj/item/organ/external/affected, in_place, update_icon, detached)
	var/obj/item/organ/existing = LAZYACCESS(organs_by_tag, O.organ_tag)
	if(existing && O != existing)
		CRASH("mob/living/carbon/add_organ(): '[O]' tried to overwrite [src]'s existing organ '[existing]' in slot '[O.organ_tag]'!")
	if(O.parent_organ && !LAZYACCESS(organs_by_tag, O.parent_organ))
		CRASH("mob/living/carbon/add_organ(): Tried to add an internal organ to a non-existing parent external organ!")

	//We don't add internal organs to the lists if we're detached
	if(O.is_internal() && !detached)
		LAZYSET(organs_by_tag, O.organ_tag, O)
		LAZYDISTINCTADD(internal_organs, O)
	//External organs must always be in the organ list even when detached. Otherwise icon updates won't show the limb, and limb attach surgeries won't work
	else if(!O.is_internal())
		LAZYSET(organs_by_tag, O.organ_tag, O)
		LAZYDISTINCTADD(external_organs, O)
	. = ..()

/mob/living/carbon/remove_organ(var/obj/item/organ/O, var/drop_organ = TRUE, var/detach = TRUE, var/ignore_children = FALSE,  var/in_place = FALSE, var/update_icon = TRUE)
	if(!in_place && species.is_vital_organ(src, O) && usr)
		admin_attack_log(usr, src, "Removed a vital organ ([src]).", "Had a vital organ ([src]) removed.", "removed a vital organ ([src]) from")

	if(!(. = ..()))
		return

	if(client)
		client.screen -= O
	
	LAZYREMOVE(organs_by_tag, O.organ_tag)
	if(O.is_internal())
		LAZYREMOVE(internal_organs, O)
	else
		LAZYREMOVE(external_organs, O)

//Should handle vital organ checks, icon updates, events
/mob/living/carbon/on_lost_organ(var/obj/item/organ/O)
	if(!(. = ..()))
		return

	//Check if we should die
	if(species.is_vital_organ(src, O))
		death()
