// Returns how many characters are currently active(not logged out, not AFK for more than 10 minutes)
// with a specific role.
// Note that this isn't sorted by department, because e.g. having a roboticist shouldn't make meteors spawn.
/proc/number_active_with_role()

	. = list()
	for(var/mob/M in global.player_list)

		if(!M.mind || !M.client || M.client.is_afk(10 MINUTES))
			continue

		.["Any"]++

		if(isrobot(M))
			var/mob/living/silicon/robot/R = M
			if(R.module?.associated_department)
				var/decl/department/dept = GET_DECL(R.module.associated_department)
				.[dept.name] = .[dept.name] + 1
		else
			for(var/dtype in M.mind?.assigned_job?.department_types)
				var/decl/department/dept = GET_DECL(dtype)
				.[dept.name] = .[dept.name] + 1
				for(var/job_category in M.mind.assigned_job.event_categories)
					.[job_category] = .[job_category] + 1
