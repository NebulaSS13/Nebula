/datum/map/exodus
	default_job_type = /datum/job/standard/assistant
	default_department_type = /decl/department/civilian
	allowed_jobs = list(
		/datum/job/standard/captain,
		/datum/job/standard/hop,
		/datum/job/standard/chaplain,
		/datum/job/standard/bartender,
		/datum/job/standard/chef,
		/datum/job/standard/hydro,
		/datum/job/standard/qm,
		/datum/job/standard/cargo_tech,
		/datum/job/standard/mining,
		/datum/job/standard/janitor,
		/datum/job/standard/librarian,
		/datum/job/standard/lawyer,
		/datum/job/standard/chief_engineer,
		/datum/job/standard/engineer,
		/datum/job/standard/cmo,
		/datum/job/standard/doctor,
		/datum/job/standard/chemist,
		/datum/job/standard/counselor,
		/datum/job/standard/rd,
		/datum/job/standard/scientist,
		/datum/job/standard/roboticist,
		/datum/job/standard/hos,
		/datum/job/standard/detective,
		/datum/job/standard/warden,
		/datum/job/standard/officer,
		/datum/job/standard/robot,
		/datum/job/standard/computer
	)

#define HUMAN_ONLY_JOBS /datum/job/standard/captain, /datum/job/standard/hop, /datum/job/standard/hos

	species_to_job_blacklist = list(
		/decl/species/unathi = list(
			HUMAN_ONLY_JOBS
		),
		/decl/species/tajaran = list(
			HUMAN_ONLY_JOBS
		)
	)

#undef HUMAN_ONLY_JOBS
