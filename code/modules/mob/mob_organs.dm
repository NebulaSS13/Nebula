/mob/proc/has_organ(organ_tag)
	return !!get_organ(organ_tag, /obj/item/organ)

/mob/proc/get_organ(var/organ_tag, var/expected_type)
	RETURN_TYPE(/obj/item/organ)
	return

/mob/proc/get_injured_organs()
	return

/mob/proc/get_external_organs()
	return

/mob/proc/get_internal_organs()
	return

/mob/proc/get_organs()
	var/list/external_organs = get_external_organs()
	if(external_organs)
		LAZYADD(., external_organs)
	var/list/internal_organs = get_internal_organs()
	if(internal_organs)
		LAZYADD(., internal_organs)
