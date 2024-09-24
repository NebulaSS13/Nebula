/datum/objective/anti_revolution/execute/find_target()
	..()
	if(target && target.current)
		var/decl/pronouns/pronouns = target.current.get_pronouns(ignore_coverings = TRUE)
		explanation_text = "[target.current.real_name], the [target.assigned_role] has extracted confidential information above their clearance. Execute [pronouns.him]."
	else
		explanation_text = "Free Objective"
	return target
