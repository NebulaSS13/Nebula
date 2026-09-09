/datum/job/cynosure/paramedic
	title = "Paramedic"
	department_types = list(/decl/department/medical)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#013d3b"
	economic_power = 4
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_chemistry,
		access_virology,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks,
		access_psychiatrist
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_morgue, access_eva,
		access_maint_tunnels,
		access_external_airlocks
	)
	outfit_type = /decl/outfit/job/medical/cynosure_paramedic
	description = "A Paramedic is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their own. They may also be called upon to keep patients stable when Medical is busy or understaffed."
	alt_titles = list(
		/decl/alt_title/emt,
		/decl/alt_title/sar
	)

// Paramedic Alt Titles
/decl/alt_title/emt
	name = "Emergency Medical Technician"
	desc = "An Emergency Medical Technician is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their own. They are capable of keeping a patient stabilized until they reach the hands of someone with more training."
	outfit = /decl/outfit/job/medical/cynosure_paramedic/emt

/decl/alt_title/sar
	name = "Search and Rescue"
	desc = "A Search and Rescue operative recovers individuals who are injured or dead on the surface of Sif."
	outfit = /decl/outfit/job/medical/sar
