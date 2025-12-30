/datum/job/standard/assistant/ministation
	title = "Recruit"
	supervisors = "absolutely everyone"
	alt_titles = list("Technical Recruit","Medical Recruit","Research Recruit","Visitor")
	outfit_type = /decl/outfit/job/ministation_assistant
	event_categories = list(ASSIGNMENT_GARDENER)

/decl/outfit/job/ministation_assistant
	name = "Job - Ministation Assistant"

/datum/job/standard/bartender/ministation
	title = "Bartender"
	alt_titles = list("Cook","Barista")
	supervisors = "the Lieutenant and the Captain"
	total_positions = 2
	spawn_positions = 1
	outfit_type = /decl/outfit/job/ministation/bartender
	department_types = list(/decl/department/service)
	selection_color = "#3fbe4a"
	economic_power = 5
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

/datum/job/standard/cargo_tech/ministation
	title = "Cargo Technician"
	alt_titles = list("Shaft Miner","Drill Technician","Prospector")
	supervisors = "the Lieutenant and the Captain"
	total_positions = 3
	spawn_positions = 1
	outfit_type = /decl/outfit/job/ministation/cargo
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

/datum/job/standard/janitor/ministation
	total_positions = 2
	supervisors = "the Lieutenant and the Captain"
	economic_power = 3
	selection_color = "#940088"
	outfit_type = /decl/outfit/job/ministation/janitor
	min_skill = list(
		SKILL_HAULING  = SKILL_BASIC
	)
	skill_points = 28

/datum/job/standard/librarian/ministation
	spawn_positions = 2
	supervisors = "the Lieutenant, the Captain, and the smell of old paper"
	economic_power = 5
	selection_color = "#008800"
	access = list(access_library)
	alt_titles = list(
		"Curator",
		"Archivist"
	)
	outfit_type = /decl/outfit/job/ministation/librarian
	min_skill = list(
		SKILL_LITERACY = SKILL_AVERAGE
	)
