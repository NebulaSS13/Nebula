/datum/objective/anti_revolution/demote/find_target()
	..()
	if(target && target.current)
		var/decl/pronouns/G = target.current.get_pronouns(ignore_coverings = TRUE)
		explanation_text = "[target.current.real_name], the [target.assigned_role] has been classified as harmful to [global.using_map.company_name]'s goals. Demote [G.him] to assistant."
	else
		explanation_text = "Free Objective"
	return target
