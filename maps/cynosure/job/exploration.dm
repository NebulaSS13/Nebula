/datum/job/cynosure/explorer
	title = "Explorer"
	department_types = list(
		/decl/department/science,
		/decl/department/planetside
	)
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director"
	selection_color =  "#633d63"
	economic_power = 4
	access = list(
		access_explorer,
		access_research
	)
	minimal_access = list(
		access_explorer,
		access_research
	)

	outfit_type = /decl/outfit/job/cynosure_explorer
	description = "An Explorer searches for interesting things on the surface of Sif, and returns them to the station."

	alt_titles = list(
		/decl/alt_title/pilot
	)

/decl/alt_title/pilot
	name = "Pilot"
	desc = "A pilot ferries crew around in Cynosure Station's shuttle, the NTC Calvera."
	outfit = /decl/outfit/job/pilot

/datum/job/cynosure/field_researcher
	title = "Field Researcher"
	department_types = list(
		/decl/department/science,
		/decl/department/planetside
	)
	total_positions = 3
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633d63"
	economic_power = 6
	access = list(
		access_robotics,
		access_tox,
		access_tox_storage,
		access_research,
		access_xenobiology,
		access_xenofauna,
		access_hydroponics
	)
	minimal_access = list(
		access_research,
		access_xenobiology,
		access_xenofauna,
		access_hydroponics,
		access_tox_storage
	)
	outfit_type = /decl/outfit/job/cynosure_field_researcher
	alt_titles = list(/decl/alt_title/xenovet)

/decl/alt_title/xenovet
	name = "Xenofauna Technician"
	desc = "A Xenofauna Technician works with the alien fauna living in the territory around the station, heading out in the field to tag and assess the local animal populations. They are also responsible for training and tending to the station's small drake population."
