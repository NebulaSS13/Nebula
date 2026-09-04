/decl/special_role/traitor/Initialize()
	. = ..()
	LAZYINITLIST(protected_jobs)
	protected_jobs   |= list(/datum/job/standard/officer, /datum/job/standard/warden, /datum/job/standard/detective, /datum/job/standard/captain, /datum/job/standard/lawyer, /datum/job/standard/hos)

/decl/special_role/cultist/Initialize()
	. = ..()
	LAZYINITLIST(restricted_jobs)
	restricted_jobs  |= list(/datum/job/standard/lawyer, /datum/job/standard/captain, /datum/job/standard/hos)
	LAZYINITLIST(protected_jobs)
	protected_jobs   |= list(/datum/job/standard/officer, /datum/job/standard/warden, /datum/job/standard/detective)
	LAZYINITLIST(blacklisted_jobs)
	blacklisted_jobs |= list(/datum/job/standard/chaplain, /datum/job/standard/counselor)

/decl/special_role/loyalist
	command_department_id = /decl/department/command

/decl/special_role/revolutionary
	command_department_id = /decl/department/command
