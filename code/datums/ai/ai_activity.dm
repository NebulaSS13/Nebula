/datum/mob_controller
	/// What are we busy with currently?
	var/current_activity = AI_ACTIVITY_NORMAL

/datum/mob_controller/proc/is_busy()
	return get_activity() != AI_ACTIVITY_NORMAL

/datum/mob_controller/proc/get_activity()
	return current_activity

/datum/mob_controller/proc/set_activity(new_activity)
	if(current_activity != new_activity)
		current_activity = new_activity
		if(current_activity == AI_ACTIVITY_NORMAL)
			stance?.resume_activity(body, src)
		else
			stop_wandering()
			if(body)
				body.stop_automove()
			stance?.suspend_activity(body, src)
		return TRUE
	return FALSE
