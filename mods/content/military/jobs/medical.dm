/datum/job/tradeship_medical_technician
	title = "Medical Technician"
	supervisors = "Chief Medical Officer and ethics"
	selection_color = "#5a96bb"
	department_refs = list(DEPT_MEDICAL)
	hud_icon = "hudmedtech"
	total_positions = 3
	spawn_positions = 3
	minimal_player_age = 2
	ideal_character_age = 27
	economic_power = 5
	skill_points = 16	
	min_skill = list(   
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_EVA     = SKILL_BASIC,
	    SKILL_MEDICAL = SKILL_BASIC,
	    SKILL_ANATOMY = SKILL_BASIC
	)
	max_skill = list(   
		SKILL_MEDICAL     = SKILL_MAX,
	    SKILL_CHEMISTRY   = SKILL_MAX
	)
	skill_points = 22
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen,
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/e5,
		/datum/mil_rank/arm/e6,
		/datum/mil_rank/civ/contractor
	)
	alt_titles = list(
		"Corpsman",
		"Paramedic"
	)
	outfit_type = /decl/hierarchy/outfit/job/tradeship/medical/technician
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_chemistry,
		access_virology
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
	)


/datum/job/tradeship_physician
	title = "Physician"
	supervisors = "Chief Medical Officer and ethics"
	selection_color = "#5a96bb"
	department_refs = list(DEPT_MEDICAL)
	hud_icon = "hudphysician"
	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 2
	ideal_character_age = 27
	economic_power = 5
	min_skill = list(   
		SKILL_LITERACY    = SKILL_ADEPT,
	    SKILL_MEDICAL     = SKILL_EXPERT,
	    SKILL_ANATOMY     = SKILL_EXPERT,
	    SKILL_CHEMISTRY   = SKILL_BASIC,
		SKILL_DEVICES     = SKILL_ADEPT
	)
	max_skill = list(   
		SKILL_MEDICAL     = SKILL_MAX,         
		SKILL_ANATOMY     = SKILL_MAX,
	    SKILL_CHEMISTRY   = SKILL_MAX
	)
	skill_points = 20
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen,
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/o2,
		/datum/mil_rank/arm/o3,
		/datum/mil_rank/civ/contractor
	)
	alt_titles = list(
		"Military Doctor",
		"Surgeon"
	)
	outfit_type = /decl/hierarchy/outfit/job/tradeship/medical/physician
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_chemistry,
		access_virology
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_virology
	)
