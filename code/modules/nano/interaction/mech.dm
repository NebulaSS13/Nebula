var/global/datum/topic_state/default/mech/mech_topic_state = new

/datum/topic_state/default/mech/can_use_topic(var/mob/living/exosuit/src_object, var/mob/user)
	if(istype(src_object))
		if(user in src_object.pilots)
			return ..()
	else return STATUS_CLOSE
	return ..()