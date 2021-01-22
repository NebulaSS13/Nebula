//Cargo Technician

/datum/job/tradeship_cargo_technician
	title = "Cargo Technician"
	supervisors = "Executive Officer"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/supply/technician
	min_skill = list(   
		SKILL_LITERACY    = SKILL_ADEPT,
		SKILL_FINANCE     = SKILL_BASIC,
	    SKILL_HAULING     = SKILL_BASIC
	)
	max_skill = list(   
		SKILL_PILOT       = SKILL_MAX
	)
	skill_points = 16
	allowed_branches = list(
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/arm/e3,
		/datum/mil_rank/arm/e4
	)
	department_refs = list(DEPT_SUPPLY)
	total_positions = 3
	spawn_positions = 3
	selection_color = "#9e500b"
	hud_icon = "hudsupplytechnician"
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24

//Prospector

/datum/job/tradeship_prospector
	title = "Prospector"
	supervisors = "Quartermaster and your greed"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/supply/prospector
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_HAULING = SKILL_ADEPT,
	    SKILL_EVA     = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT       = SKILL_MAX
	)  
	skill_points = 18
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	department_refs = list(DEPT_SUPPLY)
	total_positions = 2
	spawn_positions = 2
	selection_color = "#9e500b"
	hud_icon = "hudprospector"
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24

//Quartermaster

/datum/job/tradeship_quartermaster
	title = "Quartermaster"
	supervisors = "Executive Officer"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/supply/quartermaster
	min_skill = list(   
					SKILL_LITERACY    = SKILL_ADEPT,
	                SKILL_FINANCE     = SKILL_BASIC,
	                SKILL_HAULING     = SKILL_BASIC,
	                SKILL_EVA         = SKILL_BASIC,
	                SKILL_PILOT       = SKILL_BASIC

	)
	max_skill = list(
		SKILL_PILOT       = SKILL_MAX
	)  
	skill_points = 18
	allowed_branches = list(
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/arm/e6
	)
	department_refs = list(DEPT_SUPPLY)
	total_positions = 2
	spawn_positions = 2
	selection_color = "#9e500b"
	hud_icon = "hudquartermaster"
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24
