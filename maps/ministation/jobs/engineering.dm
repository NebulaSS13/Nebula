/datum/job/standard/engineer/ministation
	title = "Station Engineer"
	supervisors = "the Head Engineer"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/outfit/job/ministation/engineer
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
	skill_points = 30
	alt_titles = list("Atmospheric Technician", "Electrician", "Maintenance Technician")

/datum/job/standard/chief_engineer/ministation
	title = "Head Engineer"
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
	outfit_type = /decl/outfit/job/ministation/chief_engineer
	skill_points = 40
	alt_titles = list("Chief of Engineering")
