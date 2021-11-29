/mob/proc/get_organs()
	for(var/organ in get_external_organs())
		LAZYADD(., organ)
	for(var/organ in get_internal_organs())
		LAZYADD(., organ)
/mob/proc/get_organ(var/zone)
	return
/mob/proc/get_external_organs()
	return
/mob/proc/get_internal_organs()
	return
