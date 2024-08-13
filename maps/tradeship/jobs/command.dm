/datum/job/tradeship_captain
	title = "Captain"
	supervisors = "your profit margin, your conscience, and the Trademaster"
	outfit_type = /decl/outfit/job/tradeship/captain
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
	skill_points = 30
	head_position = 1
	department_types = list(/decl/department/command)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#1d1d4f"
	req_admin_notify = 1
	access = list()
	minimal_access = list()
	minimal_player_age = 14
	economic_power = 20
	ideal_character_age = 70
	guestbanned = 1
	must_fill = 1
	not_random_selectable = 1
	forced_spawnpoint = /decl/spawnpoint/cryo/captain

/datum/job/tradeship_captain/equip_job(var/mob/living/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	. = ..()
	if(H)
		H.verbs |= /mob/proc/tradehouse_rename_ship
		H.verbs |= /mob/proc/tradehouse_rename_company

/datum/job/tradeship_captain/get_access()
	return get_all_station_access()

/mob/proc/tradehouse_rename_ship()
	set name = "Rename Tradeship"
	set category = "Captain's Powers"

	var/ship = sanitize(input(src, "What is your ship called? Don't add the vessel prefix, 'Tradeship' will be attached automatically.", "Ship Name", global.using_map.station_short), MAX_NAME_LEN)
	if(!ship)
		return
	global.using_map.station_short = ship
	global.using_map.station_name = "Tradeship [ship]"

	for(var/sz in global.overmap_sectors)
		var/obj/effect/overmap/visitable/ship/tradeship/B = global.overmap_sectors[sz]
		if(istype(B))
			B.SetName(global.using_map.station_name)
			command_announcement.Announce("Attention all hands on [global.using_map.station_name]! Thank you for your attention.", "Ship Re-Christened")
			verbs -= /mob/proc/tradehouse_rename_ship
			return

	to_chat(src, SPAN_WARNING("Could not find an appropriate overmap object for this verb to rename, sorry."))

/mob/proc/tradehouse_rename_company()
	set name = "Rename Tradehouse"
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
		command_announcement.Announce("Congratulations to all members of [capitalize(global.using_map.company_name)] on the new name. Their rebranding has changed the [global.using_map.company_short] market value by [0.01*rand(-10,10)]%.", "Tradehouse Name Change")
	verbs -= /mob/proc/tradehouse_rename_company

/datum/job/tradeship_first_mate
	title = "First Mate"
	supervisors = "the Captain"
	outfit_type = /decl/outfit/job/tradeship/mate
	head_position = 1
	department_types = list(
		/decl/department/command,
		/decl/department/civilian
	)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#2f2f7f"
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
		access_heads,
		access_medical,
		access_engine,
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
		access_gateway
	)
	minimal_access = list(
		access_security,
		access_sec_doors,
		access_brig,
		access_forensics_lockers,
		access_heads,
		access_medical,
		access_engine,
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
		access_gateway
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_BASIC,
		SKILL_FINANCE  = SKILL_EXPERT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT =   SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX
	)
	skill_points = 30
	alt_titles = list()
