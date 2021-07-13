/datum/map/exodus
	default_job_type = /datum/job/assistant
	default_department_type = /decl/department/civilian
	id_hud_icons = 'maps/exodus/hud.dmi'
	allowed_jobs = list(
		/datum/job/captain,
		/datum/job/hop,
		/datum/job/chaplain,
		/datum/job/bartender,
		/datum/job/chef,
		/datum/job/hydro,
		/datum/job/qm,
		/datum/job/cargo_tech,
		/datum/job/mining,
		/datum/job/janitor,
		/datum/job/librarian,
		/datum/job/lawyer,
		/datum/job/chief_engineer,
		/datum/job/engineer,
		/datum/job/cmo,
		/datum/job/doctor,
		/datum/job/chemist,
		/datum/job/counselor,
		/datum/job/rd,
		/datum/job/scientist,
		/datum/job/roboticist,
		/datum/job/hos,
		/datum/job/detective,
		/datum/job/warden,
		/datum/job/officer,
		/datum/job/robot,
		/datum/job/computer
	)

	species_to_job_whitelist = list(
		/decl/species/adherent = list(
			/datum/job/computer, 
			/datum/job/robot, 
			/datum/job/assistant, 
			/datum/job/janitor, 
			/datum/job/chef, 
			/datum/job/bartender, 
			/datum/job/cargo_tech,
			/datum/job/engineer, 
			/datum/job/roboticist, 
			/datum/job/chemist,
			/datum/job/scientist, 
			/datum/job/mining
		),
		/decl/species/utility_frame = list(
			/datum/job/computer, 
			/datum/job/robot, 
			/datum/job/assistant, 
			/datum/job/janitor, 
			/datum/job/chef, 
			/datum/job/bartender, 
			/datum/job/cargo_tech,
			/datum/job/engineer, 
			/datum/job/roboticist, 
			/datum/job/chemist,
			/datum/job/scientist, 
			/datum/job/mining
		),
		/decl/species/serpentid = list(
			/datum/job/computer, 
			/datum/job/robot, 
			/datum/job/assistant, 
			/datum/job/janitor, 
			/datum/job/chef, 
			/datum/job/bartender, 
			/datum/job/cargo_tech,
			/datum/job/roboticist,
			/datum/job/chemist
		)
	)

#define HUMAN_ONLY_JOBS /datum/job/captain, /datum/job/hop, /datum/job/hos
	species_to_job_blacklist = list(
		/decl/species/lizard = list(
			HUMAN_ONLY_JOBS
		),
		/decl/species/tajaran = list(
			HUMAN_ONLY_JOBS
		)
	)

#undef HUMAN_ONLY_JOBS
