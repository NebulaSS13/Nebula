/datum/job/tradeship_explorer
	title = "Explorer"
	supervisors = "Chief Science Officer and Pathfinder with Pilot"
	selection_color = "#7c0068"
	department_refs = list(DEPT_EXPLORATION)
	hud_icon = "hudexplorer"
	total_positions = 3
	spawn_positions = 3
	minimal_player_age = 2
	ideal_character_age = 27
	economic_power = 5
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_LITERACY    = SKILL_ADEPT,
	)
	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,

	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT
	)
	skill_points = 22
	allowed_branches = list(
		/datum/mil_branch/ntsfod
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee
	)
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/exploration/explorer
	access = list()
	minimal_access = list()

/datum/job/tradeship_pilot
	title = "Pilot"
	supervisors = "Pathfinder"
	selection_color = "#7c0068"
	department_refs = list(DEPT_EXPLORATION)
	hud_icon = "hudpilot"
	total_positions = 3
	spawn_positions = 3
	minimal_player_age = 2
	ideal_character_age = 27
	economic_power = 5
	min_skill = list(	SKILL_EVA      = SKILL_BASIC,
						SKILL_LITERACY = SKILL_ADEPT,
						SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX
	)
	skill_points = 22
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/e5
	)
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/exploration/pilot
	access = list()
	minimal_access = list()

/datum/job/tradeship_pathfinder
	title = "Pathfinder"
	supervisors = "Chief Science Officer"
	selection_color = "#7c0068"
	department_refs = list(DEPT_EXPLORATION)
	hud_icon = "hudpathfinder"
	total_positions = 3
	spawn_positions = 3
	minimal_player_age = 2
	ideal_character_age = 27
	economic_power = 5
	min_skill = list(   SKILL_LITERACY    = SKILL_ADEPT,
	                    SKILL_EVA         = SKILL_ADEPT,
	                    SKILL_SCIENCE     = SKILL_ADEPT,
	                    SKILL_PILOT       = SKILL_BASIC
	)
	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT
	)
	skill_points = 22
	allowed_branches = list(
		/datum/mil_branch/ntsfod
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee
	)
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/exploration/pathfinder
	access = list()
	minimal_access = list()