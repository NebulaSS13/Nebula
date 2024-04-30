/mob/living/carbon/get_organ(var/organ_tag, var/expected_type = /obj/item/organ)
	RETURN_TYPE(expected_type)
	var/obj/item/organ = LAZYACCESS(organs_by_tag, organ_tag)
	if(!expected_type || istype(organ, expected_type))
		return organ

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

/mob/living/carbon/get_organs_by_categories(var/list/categories)
	for(var/organ_cat in categories)
		if(organ_cat in organs_by_category)
			LAZYDISTINCTADD(., organs_by_category[organ_cat])

//Deletes all references to organs
/mob/living/carbon/delete_organs()
	..()
	organs_by_tag      = null
	internal_organs    = null
	external_organs    = null
	organs_by_category = null

/mob/living/carbon/add_organ(obj/item/organ/O, obj/item/organ/external/affected, in_place, update_icon, detached, skip_health_update = FALSE)
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

	// Update our organ category lists, if neeed.
	if(O.organ_category)
		LAZYINITLIST(organs_by_category)
		LAZYDISTINCTADD(organs_by_category[O.organ_category], O)

	. = ..()

/mob/living/carbon/remove_organ(var/obj/item/organ/O, var/drop_organ = TRUE, var/detach = TRUE, var/ignore_children = FALSE,  var/in_place = FALSE, var/update_icon = TRUE, var/skip_health_update = FALSE)
	if(istype(O) && !in_place && O.is_vital_to_owner() && usr)
		admin_attack_log(usr, src, "Removed a vital organ ([src]).", "Had a vital organ ([src]) removed.", "removed a vital organ ([src]) from")
	if(!(. = ..()))
		return
	LAZYREMOVE(organs_by_tag, O.organ_tag)
	if(O.is_internal())
		LAZYREMOVE(internal_organs, O)
	else
		LAZYREMOVE(external_organs, O)

	// Update our organ category lists, if neeed.
	if(O.organ_category && islist(organs_by_category))
		organs_by_category[O.organ_category] -= O
		if(LAZYLEN(organs_by_category[O.organ_category]) <= 0)
			LAZYREMOVE(organs_by_category, O.organ_category)

/mob/living/carbon/get_bodytype()
	RETURN_TYPE(/decl/bodytype)
	// If the root organ ever changes/isn't always the chest, this will need to be changed.
	return get_organ(BP_CHEST, /obj/item/organ)?.bodytype