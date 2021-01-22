//Bartender

/datum/job/tradeship_bartender
	title = "Bartender"
	supervisors = "Executive Officer"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/service/bartender
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING   = SKILL_BASIC,
		SKILL_BOTANY    = SKILL_BASIC,
	    SKILL_CHEMISTRY = SKILL_BASIC
	)
	max_skill = list()    
	skill_points = 16
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	department_refs = list(DEPT_SERVICE)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#7fb717"
	hud_icon = "hudbartender"
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24

//Cook

/datum/job/tradeship_cook
	title = "Cook"
	supervisors = "Executive Officer"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/service/cook
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING   = SKILL_ADEPT,
	    SKILL_BOTANY    = SKILL_BASIC,
	    SKILL_CHEMISTRY = SKILL_BASIC
	)
	max_skill = list()  
	skill_points = 16
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	department_refs = list(DEPT_SERVICE)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#7fb717"
	hud_icon = "hudcook"
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24

//Chaplain

/datum/job/tradeship_chaplain
	title = "Chaplain"
	supervisors = "Executive Officer"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/service/chaplain
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT
	)
	max_skill = list()  
	skill_points = 16
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	department_refs = list(DEPT_SERVICE)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#7fb717"
	hud_icon = "hudchaplain"
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24

//Janitor

/datum/job/tradeship_janitor
	title = "Janitor"
	supervisors = "Executive Officer"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/service/janitor
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT
	)
	max_skill = list()  
	skill_points = 16
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	department_refs = list(DEPT_SERVICE)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#7fb717"
	hud_icon = "hudjanitor"
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24
