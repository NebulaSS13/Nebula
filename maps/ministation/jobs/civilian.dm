/datum/job/ministation/bartender
	title = "Bartender"
	alt_titles = list("Cook","Barista")
	supervisors = "the Lieutenant and the Captain"
	total_positions = 1
	spawn_positions = 1
	hud_icon = "hudbartender"
	outfit_type = /decl/hierarchy/outfit/job/ministation/bartender
	department_refs = list(DEPT_SERVICE)
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
	skill_points = 20

/datum/job/ministation/cargo
	title = "Cargo Technician"
	alt_titles = list("Shaft Miner","Drill Technician","Prospector")
	supervisors = "the Lieutenant and the Captain"
	total_positions = 2
	spawn_positions = 1
	hud_icon = "hudcargotechnician"
	outfit_type = /decl/hierarchy/outfit/job/ministation/cargo
	department_refs = list(DEPT_SERVICE)
	selection_color = "#8a7c00"
	economic_power = 5
	access = list(
		access_cargo,
		access_cargo_bot,
		access_mining,
		access_mailsorting,
		access_mining,
		access_mining_station,
		access_external_airlocks
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
	skill_points = 20
	software_on_spawn = list(
		/datum/computer_file/program/supply,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/datum/job/ministation/janitor
	title = "Janitor"
	department_refs = list(DEPT_SERVICE)
	total_positions = 1
	spawn_positions = 1
	hud_icon = "hudjanitor"
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
	outfit_type = /decl/hierarchy/outfit/job/ministation/janitor
	min_skill = list(
		SKILL_HAULING  = SKILL_BASIC
	)
	skill_points = 18