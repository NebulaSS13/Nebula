/decl/department/planetside
	name = "Planetside"
	display_color = "#555555"
	display_priority = 2 // Same as cargo in importance.

/datum/map/cynosure
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
		/datum/job/cynosure/paramedic,
		/datum/job/standard/chemist,
		/datum/job/standard/counselor,
		/datum/job/standard/rd,
		/datum/job/standard/scientist,
		/datum/job/cynosure/explorer,
		/datum/job/cynosure/field_researcher,
		/datum/job/standard/roboticist,
		/datum/job/standard/hos,
		/datum/job/standard/detective,
		/datum/job/standard/warden,
		/datum/job/standard/officer,
		/datum/job/cynosure/survivalist,
		/datum/job/cynosure/trained_animal,
		/datum/job/standard/robot,
		/datum/job/standard/computer
	)
	species_to_job_whitelist = list(
		// Drakes sadly cannot work white collar jobs. They are automatically blacklisted from all other jobs.
		/decl/species/grafadreka = list (/datum/job/cynosure/trained_animal),
		/decl/species/vox = list (/datum/job/cynosure/survivalist)
	)

/datum/job/cynosure
	hud_icon = 'maps/cynosure/icons/hud.dmi'
