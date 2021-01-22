/datum/job/tradeship_engineer
	title = "Engineer"
	supervisors = "Chief Engineer and your tools"
	selection_color = "#f39e27"
	department_refs = list(DEPT_ENGINEERING)
	hud_icon = "hudengineer"
	total_positions = 3
	spawn_positions = 3
	minimal_player_age = 2
	ideal_character_age = 27
	economic_power = 5
	min_skill = list(   SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_EVA          = SKILL_BASIC,
						SKILL_LITERACY     = SKILL_ADEPT,
	                    SKILL_CONSTRUCTION = SKILL_ADEPT,
	                    SKILL_ELECTRICAL   = SKILL_BASIC,
	                    SKILL_ATMOS        = SKILL_BASIC,
	                    SKILL_ENGINES      = SKILL_BASIC
	)
	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 20
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen,
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/e4,
		/datum/mil_rank/arm/e5,
		/datum/mil_rank/civ/contractor
	)
	alt_titles = list("Ship Technician")
	outfit_type = /decl/hierarchy/outfit/job/tradeship/engineering/engineer
	access = list(
		access_eva, 
		access_engine, 
		access_engine_equip, 
		access_tech_storage, 
		access_maint_tunnels, 
		access_external_airlocks, 
		access_construction, 
		access_atmospherics, 
		access_emergency_storage
	)
	minimal_access = list(
		access_eva, 
		access_engine, 
		access_engine_equip, 
		access_tech_storage, 
		access_maint_tunnels, 
		access_external_airlocks, 
		access_construction, 
		access_atmospherics, 
		access_emergency_storage
	)
