//Basic Security Guard

/datum/job/tradeship_security_guard
	title = "Security Guard"
	supervisors = "Chief of Security, Brig Chief and Solarian Code of Law"
	min_skill = list(   
		SKILL_LITERACY    = SKILL_ADEPT,
	    SKILL_EVA         = SKILL_BASIC,
	    SKILL_COMBAT      = SKILL_BASIC,
	    SKILL_WEAPONS     = SKILL_ADEPT,
	    SKILL_FORENSICS   = SKILL_BASIC
	)
	max_skill = list(   
		SKILL_COMBAT      = SKILL_MAX,
	    SKILL_WEAPONS     = SKILL_MAX,
	    SKILL_FORENSICS   = SKILL_EXPERT
	)
	skill_points = 20
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/e3,
		/datum/mil_rank/arm/e4
	)
	department_refs = list(DEPT_SECURITY)
	total_positions = 4
	spawn_positions = 4
	selection_color = "#134975"
	hud_icon = "hudsecurityguard"
	alt_titles = list("Military Enforcer")
	outfit_type = /decl/hierarchy/outfit/job/tradeship/security/security_guard
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24

//Forensic Technician/Detective

/datum/job/tradeship_forensic_technician
	title = "Forensic Technician"
	supervisors = "Chief of Security, Brig Chief and Solarian Code of Law"
	min_skill = list(   
		SKILL_LITERACY    = SKILL_ADEPT,
	    SKILL_COMPUTER    = SKILL_BASIC,
	    SKILL_EVA         = SKILL_BASIC,
	    SKILL_COMBAT      = SKILL_BASIC,
	    SKILL_WEAPONS     = SKILL_BASIC,
	    SKILL_FORENSICS   = SKILL_ADEPT
	)
	max_skill = list(   
		SKILL_COMBAT      = SKILL_EXPERT,
	    SKILL_WEAPONS     = SKILL_EXPERT,
	    SKILL_FORENSICS   = SKILL_MAX
	)
	skill_points = 20
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/e5,
		/datum/mil_rank/arm/e6
	)
	department_refs = list(DEPT_SECURITY)
	alt_titles = list(
		"Criminal Investigator"
	)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#134975"
	hud_icon = "hudforensictechnician"	
	outfit_type = /decl/hierarchy/outfit/job/tradeship/security/forensic_technician
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24

//Brig Chief/Warden

/datum/job/tradeship_brig_chief
	title = "Brig Chief"
	supervisors = "Chief of Security and Solarian Code of Law"
	min_skill = list(   
		SKILL_LITERACY    = SKILL_ADEPT,
	    SKILL_EVA         = SKILL_BASIC,
	    SKILL_COMBAT      = SKILL_BASIC,
	    SKILL_WEAPONS     = SKILL_ADEPT,
	 	SKILL_FORENSICS   = SKILL_BASIC
	)
	max_skill = list(   
		SKILL_COMBAT      = SKILL_MAX,
	    SKILL_WEAPONS     = SKILL_MAX,
	    SKILL_FORENSICS   = SKILL_MAX
	)
	skill_points = 20
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/e6,
		/datum/mil_rank/arm/e7
	)
	department_refs = list(DEPT_SECURITY)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#134975"
	hud_icon = "hudbrigchief"	
	outfit_type = /decl/hierarchy/outfit/job/tradeship/security/brig_chief
	access = list()
	minimal_access = list()
	minimal_player_age = 5
	economic_power = 10
	ideal_character_age = 24