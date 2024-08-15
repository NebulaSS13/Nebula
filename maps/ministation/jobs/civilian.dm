/datum/job/ministation/assistant
	title = "Recruit"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	economic_power = 1
	access = list()
	minimal_access = list()
	hud_icon = "hudassistant"
	alt_titles = list("Technical Recruit","Medical Recruit","Research Recruit","Visitor")
	outfit_type = /decl/outfit/job/ministation_assistant
	department_types = list(/decl/department/civilian)
	event_categories = list(ASSIGNMENT_GARDENER)

/datum/job/ministation/assistant/get_access()
	if(get_config_value(/decl/config/toggle/assistant_maint))
		return list(access_maint_tunnels)
	return list()

/decl/outfit/job/ministation_assistant
	name = "Job - Ministation Assistant"

/datum/job/ministation/bartender
	title = "Bartender"
	alt_titles = list("Cook","Barista")
	supervisors = "the Lieutenant and the Captain"
	total_positions = 2
	spawn_positions = 1
	outfit_type = /decl/outfit/job/ministation/bartender
	department_types = list(/decl/department/service)
	selection_color = "#3fbe4a"
	economic_power = 5
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	min_skill = list(
		SKILL_COOKING	= SKILL_ADEPT,
		SKILL_BOTANY	= SKILL_BASIC,
		SKILL_CHEMISTRY	= SKILL_BASIC
	)
	max_skill = list(
		SKILL_COOKING	= SKILL_MAX,
		SKILL_BOTANY	= SKILL_MAX
	)
	skill_points = 30

/datum/job/ministation/cargo
	title = "Cargo Technician"
	alt_titles = list("Shaft Miner","Drill Technician","Prospector")
	supervisors = "the Lieutenant and the Captain"
	total_positions = 3
	spawn_positions = 1
	outfit_type = /decl/outfit/job/ministation/cargo
	department_types = list(/decl/department/service)
	selection_color = "#8a7c00"
	economic_power = 5
	access = list(
		access_cargo,
		access_cargo_bot,
		access_mining,
		access_mailsorting,
		access_mining,
		access_mining_station,
		access_external_airlocks,
		access_eva
	)
	minimal_access = list(
		access_cargo,
		access_cargo_bot,
		access_mining,
		access_mailsorting,
		access_eva,
		access_mining,
		access_mining_station,
		access_external_airlocks
	)
	min_skill = list(
		SKILL_FINANCE	= SKILL_BASIC,
		SKILL_HAULING	= SKILL_ADEPT,
		SKILL_EVA		= SKILL_BASIC,
		SKILL_COMPUTER	= SKILL_BASIC,
		SKILL_LITERACY	= SKILL_BASIC
	)
	max_skill = list(
		SKILL_HAULING	= SKILL_MAX,
		SKILL_EVA		= SKILL_MAX,
		SKILL_FINANCE	= SKILL_MAX
	)
	skill_points = 30
	software_on_spawn = list(
		/datum/computer_file/program/supply,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/datum/job/ministation/janitor
	title = "Janitor"
	event_categories = list(ASSIGNMENT_JANITOR)
	department_types = list(/decl/department/service)
	total_positions = 2
	spawn_positions = 1
	supervisors = "the Lieutenant and the Captain"
	economic_power = 3
	selection_color = "#940088"
	access = list(
		access_janitor,
		access_maint_tunnels,
		access_engine,
		access_research,
		access_sec_doors,
		access_medical
	)
	minimal_access = list(
		access_janitor,
		access_maint_tunnels,
		access_engine,
		access_research,
		access_sec_doors,
		access_medical
	)
	alt_titles = list(
		"Custodian",
		"Sanitation Technician"
	)
	outfit_type = /decl/outfit/job/ministation/janitor
	min_skill = list(
		SKILL_HAULING  = SKILL_BASIC
	)
	skill_points = 28

/datum/job/ministation/librarian
	title = "Librarian"
	department_types = list(/decl/department/service)
	total_positions = 1
	spawn_positions = 2
	supervisors = "the Lieutenant, the Captain, and the smell of old paper"
	economic_power = 5
	selection_color = "#008800"
	access = list(access_library)
	minimal_access = list(access_library)
	alt_titles = list(
		"Curator",
		"Archivist"
	)
	outfit_type = /decl/outfit/job/ministation/librarian
	min_skill = list(
		SKILL_LITERACY = SKILL_AVERAGE
	)
