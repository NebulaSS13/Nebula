/*
	This state always returns STATUS_INTERACTIVE
*/
var/datum/topic_state/interactive/interactive_state = new

/datum/topic_state/interactive/can_use_topic(var/src_object, var/mob/user)
	return STATUS_INTERACTIVE
