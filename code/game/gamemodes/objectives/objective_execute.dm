/datum/objective/anti_revolution/execute/find_target()
	..()
	if(target && target.current)
		explanation_text = "[target.current.real_name], the [target.assigned_role] has extracted confidential information above their clearance. Execute \him[target.current]."
	else
		explanation_text = "Free Objective"
	return target
