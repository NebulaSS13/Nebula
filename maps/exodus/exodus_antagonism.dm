/decl/special_role/traitor/Initialize()
	. = ..()
	LAZYINITLIST(protected_jobs)
	protected_jobs   |= list(/datum/job/officer, /datum/job/warden, /datum/job/detective, /datum/job/captain, /datum/job/lawyer, /datum/job/hos)

/decl/special_role/godcultist/Initialize()
	. = ..()
	LAZYINITLIST(restricted_jobs)
	restricted_jobs  |= list(/datum/job/lawyer, /datum/job/captain, /datum/job/hos)
	LAZYINITLIST(protected_jobs)
	protected_jobs   |= list(/datum/job/officer, /datum/job/warden, /datum/job/detective)
	LAZYINITLIST(blacklisted_jobs)
	blacklisted_jobs |= /datum/job/chaplain

/decl/special_role/cultist/Initialize()
	. = ..()
	LAZYINITLIST(restricted_jobs)
	restricted_jobs  |= list(/datum/job/lawyer, /datum/job/captain, /datum/job/hos)
	LAZYINITLIST(protected_jobs)
	protected_jobs   |= list(/datum/job/officer, /datum/job/warden, /datum/job/detective)
	LAZYINITLIST(blacklisted_jobs)
	blacklisted_jobs |= list(/datum/job/chaplain, /datum/job/counselor)

/decl/special_role/loyalist
	command_department_id = /decl/department/command

/decl/special_role/revolutionary
	command_department_id = /decl/department/command
