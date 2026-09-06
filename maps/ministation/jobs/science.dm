/datum/job/standard/scientist/ministation
	title = "Researcher"
	alt_titles = list("Scientist","Xenobiologist","Roboticist","Xenobotanist")
	supervisors = "the Head Researcher"
	spawn_positions = 1
	total_positions = 2
	outfit_type = /decl/outfit/job/ministation/scientist
	skill_points = 34

/datum/job/standard/rd/ministation
	title = "Research Director"
	alt_titles = list("Head Researcher", "Chief Researcher")
	outfit_type = /decl/outfit/job/ministation/scientist/head
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_FINANCE  = SKILL_ADEPT,
		SKILL_BOTANY   = SKILL_BASIC,
		SKILL_ANATOMY  = SKILL_BASIC,
		SKILL_DEVICES  = SKILL_BASIC,
		SKILL_SCIENCE  = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_ANATOMY  = SKILL_MAX,
		SKILL_DEVICES  = SKILL_MAX,
		SKILL_SCIENCE  = SKILL_MAX
	)
	skill_points = 40
	access = list(
		access_rd,
		access_bridge,
		access_tox,
		access_morgue,
		access_tox_storage,
		access_teleporter,
		access_sec_doors,
		access_heads,
		access_eva,
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
		access_engine_equip,
		access_mining,
		access_kitchen,
		access_hydroponics,
		access_network,
		access_cameras
	)
	minimal_access = list(
		access_rd,
		access_bridge,
		access_tox,
		access_morgue,
		access_tox_storage,
		access_teleporter,
		access_sec_doors,
		access_heads,
		access_eva,
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
		access_engine_equip,
		access_mining,
		access_kitchen,
		access_hydroponics,
		access_network,
		access_cameras
	)
