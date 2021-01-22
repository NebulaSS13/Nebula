/datum/job/tradeship_scientist
	title = "Scientist"
	supervisors = "Chief Science Officer"
	total_positions = 2
	spawn_positions = 2
	hud_icon = "hudscientist"
	alt_titles = list(
		"Researcher"
	)
	min_skill = list(   
		SKILL_LITERACY    = SKILL_ADEPT,
		SKILL_COMPUTER    = SKILL_BASIC,
	    SKILL_DEVICES     = SKILL_BASIC,
		SKILL_BOTANY      = SKILL_BASIC,
	    SKILL_SCIENCE     = SKILL_ADEPT
	)
	max_skill = list(   
		SKILL_ANATOMY     = SKILL_MAX,
		SKILL_DEVICES     = SKILL_MAX,
	    SKILL_SCIENCE     = SKILL_MAX
	)
	skill_points = 24
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/civ/contractor
	)
	outfit_type = /decl/hierarchy/outfit/job/tradeship/science/scientist
	department_refs = list(DEPT_SCIENCE)
	selection_color = "#9966cc"
	economic_power = 7
	minimal_player_age = 7
	access = list(
		access_tox, 
		access_tox_storage, 
		access_research, 
		access_xenobiology, 
		access_xenoarch
	)
	minimal_access = list(
		access_tox,
		access_tox_storage,
		access_research,
		access_xenobiology,
		access_xenoarch
	)


/datum/job/tradeship_roboticist
	title = "Roboticist"
	supervisors = "Chief Science Officer"
	spawn_positions = 1
	total_positions = 1
	hud_icon = "hudroboticist"
	alt_titles = list()
	allowed_branches = list(
		/datum/mil_branch/ntsfod
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee
	)
	outfit_type = /decl/hierarchy/outfit/job/tradeship/science/roboticist
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_COMPUTER = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_ADEPT,
		SKILL_ANATOMY  = SKILL_ADEPT,
		SKILL_DEVICES  = SKILL_ADEPT,
		SKILL_SCIENCE  = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_ANATOMY  = SKILL_MAX,
		SKILL_DEVICES  = SKILL_MAX,
		SKILL_SCIENCE  = SKILL_MAX
	)
	skill_points = 20
	department_refs = list(DEPT_SCIENCE)
	selection_color = "#9966cc"
	economic_power = 15
	minimal_player_age = 7

	access = list(
		access_robotics, 
		access_tox, 
		access_tox_storage, 
		access_research, 
		access_xenobiology, 
		access_xenoarch
	)
	minimal_access = list(
		access_robotics,
		access_tox,
		access_tox_storage,
		access_research,
		access_xenobiology,
		access_xenoarch
	)
