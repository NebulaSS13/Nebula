/datum/job/ministation/town
	title = "Town Template"
	supervisors = "absolutely everyone"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/town
	department_types = list(/decl/department/town)
	selection_color = "#88b3b0"
	skill_points = 20


/datum/job/ministation/town/alderman
	title = "Alderman"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the will of the people"
	outfit_type = /decl/outfit/job/town/alderman

	min_skill = list(SKILL_LITERACY	= SKILL_EXPERT)
	skill_points = 32


/datum/job/ministation/town/merchant
	title = "Merchant"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the alderman"
	economic_power = 1
	access = list()
	minimal_access = list()

	min_skill = list(SKILL_LITERACY	= SKILL_ADEPT)
	skill_points = 30


/datum/job/ministation/town/provost
	title = "Provost"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the alderman"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/town/provost

	min_skill = list(SKILL_LITERACY	= SKILL_ADEPT)
	skill_points = 30


/datum/job/ministation/town/citizen
	title = "Inner Wall Citizen"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the alderman"
	economic_power = 1
	access = list()
	minimal_access = list()

	min_skill = list(SKILL_LITERACY	= SKILL_ADEPT)
	skill_points = 30
