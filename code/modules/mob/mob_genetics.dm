/mob/proc/get_genetic_conditions()
	RETURN_TYPE(/list)

/mob/proc/can_have_genetic_conditions()
	return FALSE

/mob/proc/has_genetic_condition(condition_type)
	return FALSE

/mob/proc/add_genetic_condition(condition_type, temporary_time)
	return FALSE

/mob/proc/remove_genetic_condition(condition_type)
	return FALSE

/mob/proc/reset_genetic_conditions()
	return
