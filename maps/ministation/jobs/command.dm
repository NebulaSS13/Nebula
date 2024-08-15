/datum/job/ministation/captain
	title = "Captain"
	supervisors = "your profit margin, your conscience, and the watchful eye of the Tradehouse Rep"
	outfit_type = /decl/outfit/job/ministation/captain
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_ADEPT,
		SKILL_SCIENCE  = SKILL_ADEPT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT   = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX
	)
	skill_points = 40
	head_position = 1
	department_types = list(/decl/department/command)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#1d1d4f"
	hud_icon = "hudcaptain"
	req_admin_notify = 1
	access = list()
	minimal_access = list()
	minimal_player_age = 14
	economic_power = 20
	ideal_character_age = 70
	guestbanned = 1
	must_fill = 1
	not_random_selectable = 1

/datum/job/ministation/captain/equip_job(var/mob/living/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	. = ..()
	if(H)
		H.verbs |= /mob/proc/freetradeunion_rename_company

/datum/job/ministation/captain/get_access()
	return get_all_station_access()

/mob/proc/freetradeunion_rename_company()
	set name = "Defect from Tradehouse"
	set category = "Captain's Powers"
	var/company = sanitize(input(src, "What should your enterprise be called?", "Company name", global.using_map.company_name), MAX_NAME_LEN)
	if(!company)
		return
	var/company_s = sanitize(input(src, "What's the short name for it?", "Company name", global.using_map.company_short), MAX_NAME_LEN)
	if(company != global.using_map.company_name)
		if (company)
			global.using_map.company_name = company
		if(company_s)
			global.using_map.company_short = company_s
		command_announcement.Announce("Congratulations to all members of [capitalize(global.using_map.company_name)] on the new name. Their rebranding has changed the [global.using_map.company_short] market value by [0.01*rand(-10,10)]%.", "Trade Union Name Change")
	verbs -= /mob/proc/freetradeunion_rename_company

/datum/job/ministation/hop
	title = "Lieutenant"
	supervisors = "the Captain"
	outfit_type = /decl/outfit/job/ministation/hop
	head_position = 1
	department_types = list(
		/decl/department/command,
		/decl/department/civilian
	)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#2f2f7f"
	hud_icon = "hudlieutenant"
	req_admin_notify = 1
	minimal_player_age = 14
	economic_power = 10
	ideal_character_age = 50
	guestbanned = 1
	not_random_selectable = 1
	access = list(
		access_security,
		access_sec_doors,
		access_brig,
		access_forensics_lockers,
		access_armory,
		access_heads,
		access_medical,
		access_engine,
		access_atmospherics,
		access_change_ids,
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
		access_mining,
		access_xenobiology,
		access_robotics,
		access_engine_equip,
		access_cargo,
		access_cargo_bot,
		access_mailsorting,
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
		access_security,
		access_sec_doors,
		access_brig,
		access_forensics_lockers,
		access_armory,
		access_heads,
		access_medical,
		access_engine,
		access_atmospherics,
		access_change_ids,
		access_ai_upload,
		access_eva,
		access_bridge,
		access_all_personal_lockers,
		access_maint_tunnels,
		access_bar,
		access_janitor,
		access_construction,
		access_mining,
		access_xenobiology,
		access_robotics,
		access_engine_equip,
		access_morgue,
		access_crematorium,
		access_kitchen,
		access_cargo,
		access_cargo_bot,
		access_mailsorting,
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
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_BASIC,
		SKILL_FINANCE  = SKILL_EXPERT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_LITERACY = SKILL_MAX,
		SKILL_PILOT =   SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX
	)
	skill_points = 40
