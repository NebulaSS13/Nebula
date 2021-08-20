/datum/job/ministation/security
	title = "Security Officer"
	alt_titles = list("Warden")
	supervisors = "the Lieutenant and the Captain"
	spawn_positions = 1
	total_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/ministation/security
	department_types = list(/decl/department/security)
	selection_color = "#990000"
	economic_power = 7
	minimal_player_age = 7
	access = list(
		access_security,
		access_brig
	)
	minimal_access = list(
		access_security,
		access_forensics_lockers,
		access_brig
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
	skill_points = 20
	event_categories = list(ASSIGNMENT_SECURITY)

/datum/job/ministation/detective
	title = "Detective"
	alt_titles = list("Inspector")
	supervisors = "Justice... and the Trademaster"
	spawn_positions = 1
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ministation/detective
	department_types = list(/decl/department/security)
	selection_color = "#630000"
	economic_power = 7
	minimal_player_age = 3
	access = list(
		access_forensics_lockers
	)
	minimal_access = list(
		access_security,
		access_forensics_lockers
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
	skill_points = 24