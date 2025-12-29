/datum/job/ministation/legion
	title = "Legion Template"
	supervisors = "absolutely everyone"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/legion
	department_types = list(/decl/department/legion)
	selection_color = "#99091f"
	skill_points = 20


/datum/job/ministation/legion/centurion
	title = "Centurion"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Caesar's will"
	outfit_type = /decl/outfit/job/legion/centurion

	min_skill = list(
		SKILL_WEAPONS	= SKILL_EXPERT,
		SKILL_HAULING 	= SKILL_BASIC,
		SKILL_LITERACY	= SKILL_EXPERT,
		)
	max_skill = list(SKILL_WEAPONS	= SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX)

	min_skill = list()
	skill_points = 32


/datum/job/ministation/legion/dec
	title = "Recruit Decanus"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the centurion"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/legion/decanus/recruit

	min_skill = list(
		SKILL_LITERACY 	= SKILL_BASIC,
		SKILL_HAULING 	= SKILL_BASIC,
		SKILL_WEAPONS	= SKILL_ADEPT
	)
	max_skill = list(
		SKILL_COMBAT	= SKILL_MAX,
		SKILL_WEAPONS	= SKILL_EXPERT,
		SKILL_CONSTRUCTION = SKILL_EXPERT
	)
	skill_points = 28

/datum/job/ministation/legion/dec/vet
	title = "Veteran Decanus"
	outfit_type = /decl/outfit/job/legion/decanus/vet
	skill_points = 32


/datum/job/ministation/legion/dec/prime
	title = "Prime Decanus"
	outfit_type = /decl/outfit/job/legion/decanus/prime
	skill_points = 30



/datum/job/ministation/legion/vet
	title = "Veteran Legionnaire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the centurion and the veteran decanus"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/legion/veteran

	min_skill = list(SKILL_COMBAT	= SKILL_ADEPT,
		SKILL_HAULING 	= SKILL_BASIC)
	max_skill = list(SKILL_COMBAT	= SKILL_MAX,
		SKILL_WEAPONS	= SKILL_EXPERT,
		SKILL_CONSTRUCTION = SKILL_EXPERT)

	skill_points = 26

/datum/job/ministation/legion/prime
	title = "Prime Legionnaire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the centurion and the prime decanus"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/legion/prime

	min_skill = list(SKILL_COMBAT	= SKILL_BASIC)
	max_skill = list(SKILL_COMBAT	= SKILL_EXPERT,
		SKILL_WEAPONS	= SKILL_EXPERT,
		SKILL_CONSTRUCTION = SKILL_EXPERT)

	skill_points = 24

/datum/job/ministation/legion/recruit
	title = "Recruit Legionnaire"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the centurion and the recruit decanus"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/legion/recruit

	min_skill = list(SKILL_COMBAT	= SKILL_BASIC)
	max_skill = list(SKILL_COMBAT	= SKILL_EXPERT)

	skill_points = 20

/datum/job/ministation/legion/camp
	title = "Camp Follower"
	total_positions = -1
	spawn_positions = -1
	alt_titles = list()
	outfit_type = /decl/outfit/job/legion/camp

	max_skill = list(
		SKILL_MEDICAL   = SKILL_MAX,
		SKILL_ANATOMY   = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX,
	)
	skill_points = 32	//Needs plenty of points to specialize

/datum/job/ministation/legion/camp/auxilia
	title = "Legion Auxillia"
	total_positions = -1
	spawn_positions = -1
	alt_titles = list()
	outfit_type = /decl/outfit/job/legion/auxilia
	skill_points = 32	//Needs plenty of points to specialize

/datum/job/ministation/legion/scout
	title = "Legion Scout"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the centurion"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/legion/prime

	min_skill = list(SKILL_COMBAT	= SKILL_ADEPT,
		SKILL_HAULING 	= SKILL_BASIC)

	max_skill = list(SKILL_COMBAT	= SKILL_MAX,
		SKILL_WEAPONS	= SKILL_EXPERT)

	skill_points = 20

