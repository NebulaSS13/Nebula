/datum/objective/anti_revolution/demote/find_target()
	..()
	if(target && target.current)
		explanation_text = "[target.current.real_name], the [target.assigned_role]  has been classified as harmful to [GLOB.using_map.company_name]'s goals. Demote \him[target.current] to assistant."
	else
		explanation_text = "Free Objective"
	return target
