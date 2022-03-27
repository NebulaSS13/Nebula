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

/mob/living/carbon/proc/delete_organs()
	for(var/obj/item/organ/O in get_organs())
		remove_organ(O, FALSE, FALSE, TRUE, TRUE, FALSE) //Remove them first so we don't trigger removal effects by just calling delete on them
		qdel(O)
	organs_by_tag = null
	internal_organs = null
	external_organs = null

/mob/living/carbon/add_organ(var/obj/item/organ/O, var/obj/item/organ/external/affected = null, var/in_place = FALSE, var/update_icon = TRUE)
	if(LAZYACCESS(organs_by_tag, O.organ_tag))
		CRASH("mob/living/carbon/add_organ(): '[O]' tried to overwrite [src]'s existing organ '[organs_by_tag[O.organ_tag]]' in slot '[O.organ_tag]'!")
	if(O.parent_organ && !LAZYACCESS(organs_by_tag, O.parent_organ))
		CRASH("mob/living/carbon/add_organ(): Tried to add an internal organ to a non-existing parent external organ!")

	LAZYSET(organs_by_tag, O.organ_tag, O)
	if(O.is_internal())
		LAZYDISTINCTADD(internal_organs, O)
	else
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

//Called by surgeries when detaching an organ during organ detach surgery
/mob/living/carbon/surgical_detach_organ(var/obj/item/organ/O, var/obj/item/organ/external/parent)
	remove_organ(O, FALSE, TRUE)
	O.forceMove(src)
	LAZYDISTINCTADD(parent.implants, O.get_detached_organ()) //#FIXME: get_detached_organ() is a placeholder for handling the weird behavior of the mmi_holder

//Called by surgery when placing an organ during organ attach surgery. Happens before attaching
/mob/living/carbon/surgical_place_organ(var/obj/item/organ/O, var/obj/item/organ/external/parent)
	LAZYDISTINCTADD(parent.implants, O)
	O.forceMove(src)
