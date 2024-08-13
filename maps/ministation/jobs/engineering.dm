/datum/job/ministation/engineer
	title = "Station Engineer"
	supervisors = "the Head Engineer"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/outfit/job/ministation/engineer
	department_types = list(/decl/department/engineering)
	selection_color = "#5b4d20"
	economic_power = 5
	minimal_player_age = 3
	access = list(
		access_eva,
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_construction,
		access_atmospherics,
		access_emergency_storage,
		access_cameras
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
		access_emergency_storage,
		access_cameras
	)
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_BASIC,
		SKILL_EVA          = SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_BASIC,
		SKILL_ATMOS        = SKILL_BASIC,
		SKILL_ENGINES      = SKILL_BASIC
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX,
		SKILL_ATMOS        = SKILL_MAX,
		SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 30
	alt_titles = list("Atmospheric Technician", "Electrician", "Maintenance Technician")
	event_categories = list(ASSIGNMENT_ENGINEER)

/datum/job/ministation/engineer/head
	title = "Head Engineer"
	head_position = 1
	department_types = list(
		/decl/department/engineering,
		/decl/department/command
	)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#7f6e2c"
	req_admin_notify = 1
	economic_power = 10
	ideal_character_age = 50
	guestbanned = 1
	must_fill = 1
	not_random_selectable = 1
	hud_icon = "hudchiefengineer"
	access = list(
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_heads,
		access_teleporter,
		access_external_airlocks,
		access_atmospherics,
		access_emergency_storage,
		access_eva,
		access_bridge,
		access_construction, access_sec_doors,
		access_ce,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_mining,
		access_kitchen,
		access_robotics,
		access_hydroponics,
		access_ai_upload,
		access_cameras
	)
	minimal_access = list(
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_heads,
		access_teleporter,
		access_external_airlocks,
		access_atmospherics,
		access_emergency_storage,
		access_eva,
		access_bridge,
		access_construction,
		access_sec_doors,
		access_ce, access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_mining,
		access_kitchen,
		access_robotics,
		access_hydroponics,
		access_ai_upload,
		access_cameras
	)
	minimal_player_age = 14
	supervisors = "the Captain"
	outfit_type = /decl/outfit/job/ministation/chief_engineer
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_ADEPT,
		SKILL_EVA          = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_ADEPT,
		SKILL_ATMOS        = SKILL_ADEPT,
		SKILL_ENGINES      = SKILL_EXPERT
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX,
		SKILL_ATMOS        = SKILL_MAX,
		SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 40
	alt_titles = list("Chief of Engineering")
	event_categories = list(ASSIGNMENT_ENGINEER)