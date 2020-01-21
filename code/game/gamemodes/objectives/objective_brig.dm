/datum/objective/anti_revolution/brig
	var/already_completed = 0

/datum/objective/anti_revolution/brig/find_target()
	..()
	if(target && target.current)
		explanation_text = "Brig [target.current.real_name], the [target.assigned_role] for 20 minutes to set an example."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/brig/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Brig [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] for 20 minutes to set an example."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/brig
	var/already_completed = 0

/datum/objective/brig/find_target()
	..()
	if(target && target.current)
		explanation_text = "Have [target.current.real_name], the [target.assigned_role] brigged for 10 minutes."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/brig/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Have [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] brigged for 10 minutes."
	else
		explanation_text = "Free Objective"
	return target