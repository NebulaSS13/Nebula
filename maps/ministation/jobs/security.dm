/datum/job/standard/officer/ministation
	title = "Security Officer"
	alt_titles = list("Warden")
	spawn_positions = 1
	total_positions = 2
	outfit_type = /decl/outfit/job/ministation/security
	economic_power = 7
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
	skill_points = 30

/datum/job/standard/detective/ministation
	alt_titles = list("Inspector")
	supervisors = "Justice... and the Trademaster"
	spawn_positions = 1
	total_positions = 1
	outfit_type = /decl/outfit/job/ministation/detective
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
	skill_points = 34

/datum/job/standard/hos/ministation
	outfit_type = /decl/outfit/job/ministation/security/head
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
	skill_points = 40
	alt_titles = list("Security Commander")
