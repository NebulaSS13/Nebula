/datum/job/ministation/tradehouse/rep
	title = "Tradehouse Representative"
	alt_titles = list("Narc")
	hud_icon = "hudnarc"
	spawn_positions = 1
	total_positions = 2
	req_admin_notify = 1
	guestbanned = 1
	supervisors = "the Trademaster"
	outfit_type = /decl/outfit/job/ministation/tradehouse
	min_skill = list(
		SKILL_WEAPONS  = SKILL_BASIC,
		SKILL_FINANCE  = SKILL_EXPERT,
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_PILOT    = SKILL_ADEPT,
		SKILL_MEDICAL  = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX,
		SKILL_FINANCE  = SKILL_MAX,
		SKILL_MEDICAL  = SKILL_MAX,
		SKILL_ANATOMY  = SKILL_EXPERT
	)
	skill_points = 35
	department_types = list(/decl/department/tradehouse)
	selection_color = "#a89004"
	access = list(
		access_lawyer,
		access_security,
		access_sec_doors,
		access_brig,
		access_heads,
		access_medical,
		access_engine,
		access_atmospherics,
		access_ai_upload,
		access_eva,
		access_bridge,
		access_all_personal_lockers,
		access_maint_tunnels,
		access_bar,
		access_janitor,
		access_construction,
		access_morgue,
		access_crematorium,
		access_kitchen,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_hydroponics,
		access_lawyer,
		access_chapel_office,
		access_library,
		access_research,
		access_mining,
		access_heads_vault,
		access_mining_station,
		access_hop,
		access_RC_announce,
		access_keycard_auth,
		access_gateway,
		access_cameras
		)

	minimal_access = list(
		access_lawyer,
		access_security,
		access_sec_doors,
		access_brig,
		access_medical,
		access_heads,
		access_engine,
		access_atmospherics,
		access_ai_upload,
		access_eva,
		access_bridge,
		access_maint_tunnels,
		access_bar,
		access_janitor,
		access_construction,
		access_morgue,
		access_crematorium,
		access_kitchen,
		access_cargo,
		access_cargo_bot,
		access_hydroponics,
		access_chapel_office,
		access_library,
		access_research,
		access_mining,
		access_heads_vault,
		access_mining_station,
		access_hop,
		access_RC_announce,
		access_keycard_auth,
		access_gateway,
		access_cameras
		)