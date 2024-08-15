/datum/job/ministation/security
	title = "Security Officer"
	alt_titles = list("Warden")
	supervisors = "the Head of Security"
	spawn_positions = 1
	total_positions = 2
	outfit_type = /decl/outfit/job/ministation/security
	department_types = list(/decl/department/security)
	selection_color = "#990000"
	economic_power = 7
	minimal_player_age = 7
	access = list(
		access_security,
		access_brig,
		access_lawyer,
		access_maint_tunnels,
		access_cameras
	)
	minimal_access = list(
		access_security,
		access_forensics_lockers,
		access_maint_tunnels,
		access_lawyer,
		access_brig,
		access_cameras
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_BASIC,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_COMBAT	= SKILL_BASIC,
		SKILL_WEAPONS	= SKILL_BASIC
	)
	max_skill = list(
		SKILL_COMBAT	= SKILL_MAX,
		SKILL_WEAPONS	= SKILL_MAX
	)
	skill_points = 30
	event_categories = list(ASSIGNMENT_SECURITY)

/datum/job/ministation/detective
	title = "Detective"
	alt_titles = list("Inspector")
	supervisors = "Justice... and the Trademaster"
	spawn_positions = 1
	total_positions = 1
	outfit_type = /decl/outfit/job/ministation/detective
	department_types = list(/decl/department/security)
	selection_color = "#630000"
	economic_power = 7
	minimal_player_age = 3
	access = list(
		access_forensics_lockers,
		access_brig,
		access_security,
		access_lawyer,
		access_maint_tunnels,
		access_cameras
	)
	minimal_access = list(
		access_security,
		access_brig,
		access_lawyer,
		access_forensics_lockers,
		access_maint_tunnels,
		access_cameras
	)
	min_skill = list(
		SKILL_LITERACY	= SKILL_BASIC,
		SKILL_COMPUTER	= SKILL_BASIC,
		SKILL_COMBAT	= SKILL_BASIC,
		SKILL_WEAPONS	= SKILL_BASIC,
		SKILL_FORENSICS	= SKILL_ADEPT
	)
	max_skill = list(
		SKILL_COMBAT	= SKILL_MAX,
		SKILL_WEAPONS	= SKILL_MAX,
		SKILL_FORENSICS	= SKILL_MAX
	)
	skill_points = 34

/datum/job/ministation/security/head
	title = "Head of Security"
	supervisors = "the Captain"
	outfit_type = /decl/outfit/job/ministation/security/head
	head_position = 1
	department_types = list(
		/decl/department/security,
		/decl/department/command
	)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#9d2300"
	req_admin_notify = 1
	minimal_player_age = 14
	economic_power = 10
	ideal_character_age = 50
	guestbanned = 1
	not_random_selectable = 1
	hud_icon = "hudhos"
	access = list(
		access_security,
		access_sec_doors,
		access_brig,
		access_eva,
		access_forensics_lockers,
		access_heads,
		access_lawyer,
		access_maint_tunnels,
		access_armory,
		access_engine_equip,
		access_mining,
		access_kitchen,
		access_robotics,
		access_hydroponics,
		access_hos,
		access_cameras
	)
	minimal_access = list(
		access_security,
		access_sec_doors,
		access_brig,
		access_lawyer,
		access_eva,
		access_forensics_lockers,
		access_heads,
		access_maint_tunnels,
		access_armory,
		access_engine_equip,
		access_mining,
		access_kitchen,
		access_robotics,
		access_hydroponics,
		access_hos,
		access_cameras
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_BASIC,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_COMBAT	= SKILL_ADEPT,
		SKILL_WEAPONS	= SKILL_ADEPT
	)
	max_skill = list(
		SKILL_COMBAT	= SKILL_MAX,
		SKILL_WEAPONS	= SKILL_MAX
	)
	skill_points = 40
	alt_titles = list("Security Commander")
