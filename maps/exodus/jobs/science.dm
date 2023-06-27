/datum/job/rd
	title = "Chief Science Officer"
	head_position = 1
	department_types = list(
		/decl/department/science,
		/decl/department/command
	)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ad6bad"
	req_admin_notify = 1
	economic_power = 15
	access = list(
		access_rd,
		access_bridge,
		access_tox,
		access_morgue,
		access_tox_storage,
		access_teleporter,
		access_sec_doors,
		access_heads,
		access_research,
		access_robotics,
		access_xenobiology,
		access_ai_upload,
		access_tech_storage,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_gateway,
		access_xenoarch,
		access_network
	)
	minimal_access = list(access_rd,
		access_bridge,
		access_tox,
		access_morgue,
		access_tox_storage,
		access_teleporter,
		access_sec_doors,
		access_heads,
		access_research,
		access_robotics,
		access_xenobiology,
		access_ai_upload,
		access_tech_storage,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_gateway,
		access_xenoarch,
		access_network
	)
	minimal_player_age = 14
	ideal_character_age = 50
	guestbanned = 1
	must_fill = 1
	not_random_selectable = 1
	outfit_type = /decl/hierarchy/outfit/job/science/rd
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_FINANCE  = SKILL_ADEPT,
		SKILL_BOTANY   = SKILL_BASIC,
		SKILL_ANATOMY  = SKILL_BASIC,
		SKILL_DEVICES  = SKILL_BASIC,
		SKILL_SCIENCE  = SKILL_ADEPT)
	max_skill = list(
		SKILL_ANATOMY  = SKILL_MAX,
		SKILL_DEVICES  = SKILL_MAX,
		SKILL_SCIENCE  = SKILL_MAX
	)
	skill_points = 30
	event_categories = list(ASSIGNMENT_SCIENTIST)

/datum/job/scientist
	title = "Scientist"
	department_types = list(/decl/department/science)
	total_positions = 6
	spawn_positions = 4
	supervisors = "the Chief Science Officer"
	selection_color = "#633d63"
	economic_power = 7
	access = list(
		access_robotics,
		access_tox,
		access_tox_storage,
		access_research,
		access_xenobiology,
		access_xenoarch,
		access_hydroponics
	)
	minimal_access = list(
		access_tox,
		access_tox_storage,
		access_research,
		access_xenoarch,
		access_xenobiology,
		access_hydroponics
	)
	alt_titles = list(
		"Xenobiologist",
		"Xenobotanist",
		"Xenoarcheologist",
		"Anomalist",
		"High Energy Researcher"
	)
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_DEVICES  = SKILL_BASIC,
		SKILL_SCIENCE  = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_ANATOMY  = SKILL_MAX,
	    SKILL_DEVICES  = SKILL_MAX,
	    SKILL_SCIENCE  = SKILL_MAX
	)
	skill_points = 20
	event_categories = list(ASSIGNMENT_SCIENTIST)

/datum/job/roboticist
	title = "Roboticist"
	department_types = list(/decl/department/science)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Science Officer"
	selection_color = "#633d63"
	economic_power = 5
	access = list(
		access_robotics,
		access_tox,
		access_tox_storage,
		access_tech_storage,
		access_morgue,
		access_research
	)
	minimal_access = list(
		access_robotics,
		access_tech_storage,
		access_morgue,
		access_research
	)
	alt_titles = list(
		"Biomechanical Engineer",
		"Mechatronic Engineer")
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/science/roboticist
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_COMPUTER = SKILL_ADEPT,
		SKILL_DEVICES  = SKILL_ADEPT,
		SKILL_EVA      = SKILL_ADEPT,
		SKILL_ANATOMY  = SKILL_ADEPT,
		SKILL_MECH     = HAS_PERK
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
	    SKILL_ELECTRICAL   = SKILL_MAX,
	    SKILL_ATMOS        = SKILL_EXPERT,
	    SKILL_ENGINES      = SKILL_EXPERT,
	    SKILL_DEVICES      = SKILL_MAX,
	    SKILL_MEDICAL      = SKILL_EXPERT,
	    SKILL_ANATOMY      = SKILL_EXPERT
	)
	skill_points = 20

/obj/item/card/id/science
	name = "identification card"
	desc = "A card issued to science staff."
	detail_color = COLOR_PALE_PURPLE_GRAY

/obj/item/card/id/science/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	extra_details = list("goldstripe")
