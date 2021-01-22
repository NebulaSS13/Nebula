//Bridge Staff
/datum/job/tradeship_commanding_officer
	title = "Captain"
	supervisors = "your profit margin, your conscience, and the Trademaster"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/command/commanding_officer
	hud_icon = "hudcaptain"
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
	allowed_branches = list(
		/datum/mil_branch/ntsfod
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee
	)
	department_refs = list(DEPT_COMMAND)
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
	forced_spawnpoint = "Captain Compartment"

/datum/job/tradeship_commanding_officer/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H)
		H.verbs |= /mob/proc/tradehouse_rename_ship
		H.verbs |= /mob/proc/tradehouse_rename_company

/datum/job/tradeship_commanding_officer/get_access()
	return get_all_station_access()

/mob/proc/tradehouse_rename_ship()
	set name = "Rename Tradeship"
	set category = "Captain's Powers"

	var/ship = sanitize(input(src, "What is your ship called? Don't add the vessel prefix, 'Tradeship' will be attached automatically.", "Ship Name", GLOB.using_map.station_short), MAX_NAME_LEN)
	if(!ship)
		return
	GLOB.using_map.station_short = ship
	GLOB.using_map.station_name = "Tradeship [ship]"
	var/obj/effect/overmap/visitable/ship/tradeship/B = locate() in world
	if(B)
		B.SetName(GLOB.using_map.station_name)
	command_announcement.Announce("Attention all hands on [GLOB.using_map.station_name]! Thank you for your attention.", "Ship re-Christened")
	verbs -= /mob/proc/tradehouse_rename_ship

/mob/proc/tradehouse_rename_company()
	set name = "Rename Tradehouse"
	set category = "Captain's Powers"
	var/company = sanitize(input(src, "What should your enterprise be called?", "Company name", GLOB.using_map.company_name), MAX_NAME_LEN)
	if(!company)
		return
	var/company_s = sanitize(input(src, "What's the short name for it?", "Company name", GLOB.using_map.company_short), MAX_NAME_LEN)
	if(company != GLOB.using_map.company_name)
		if (company)
			GLOB.using_map.company_name = company
		if(company_s)
			GLOB.using_map.company_short = company_s
		command_announcement.Announce("Congratulations to all members of [capitalize(GLOB.using_map.company_name)] on the new name. Their rebranding has changed the [GLOB.using_map.company_short] market value by [0.01*rand(-10,10)]%.", "Tradehouse Name Change")
	verbs -= /mob/proc/tradehouse_rename_company

/datum/job/tradeship_executive_officer
	title = "First Mate"
	supervisors = "the Commanding Officer"
	skill_points = 30
	alt_titles = list()
	hud_icon = "hudcommander"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/command/executive_officer
	head_position = 1
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
	department_refs = list(
		DEPT_COMMAND,
		DEPT_CIVILIAN
	)
	total_positions = 1
	spawn_positions = 1
	allowed_branches = list(
		/datum/mil_branch/ntsfod
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee
	)
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

/datum/job/tradeship_bridge_officer
	title = "Bridge Officer"
	supervisors = "The entirety of command."
	selection_color = "#2f2f7f"
	department_refs = list(DEPT_COMMAND)
	hud_icon = "hudbridgeofficer"
	total_positions = 2
	spawn_positions = 2	
	minimal_player_age = 5
	ideal_character_age = 25
	not_random_selectable = 1
	min_skill = list(   SKILL_LITERACY    = SKILL_ADEPT,
	                    SKILL_PILOT       = SKILL_ADEPT
	)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX
	)
	skill_points = 20
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/o1
	)
	alt_titles = list("Tactical Officer")
	outfit_type = /decl/hierarchy/outfit/job/tradeship/command/bridge_officer
	access = list()
	minimal_access = list()

/datum/job/tradeship_enlisted_advisor
	title = "Senior Enlisted Advisor"
	supervisors = "Solarian Code of Law and Heads"
	selection_color = "#2f2f7f"
	department_refs = list(DEPT_COMMAND)
	hud_icon = "hudenlistedadvisor"
	total_positions = 1
	spawn_positions = 1	
	minimal_player_age = 5
	ideal_character_age = 40
	not_random_selectable = 1
	min_skill = list(   SKILL_EVA        = SKILL_BASIC,
	                    SKILL_COMBAT     = SKILL_BASIC,
						SKILL_LITERACY   = SKILL_ADEPT,
	                    SKILL_WEAPONS    = SKILL_ADEPT)

	max_skill = list(	SKILL_PILOT        = SKILL_ADEPT,
	                    SKILL_COMBAT       = SKILL_MAX,
	                    SKILL_WEAPONS      = SKILL_MAX,
	                    SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX)
	skill_points = 24
	allowed_branches = list(
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/arm/e7,
		/datum/mil_rank/arm/e8
	)
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/command/enlisted_advisor
	access = list()
	minimal_access = list()
//
//Department Heads
//
/datum/job/tradeship_cso
	title = "Chief Science Officer"
	supervisors = "Commanding and Executive Officer"
	selection_color = "#9966cc"
	department_refs = list(
		DEPT_SCIENCE,
		DEPT_COMMAND
	)
	hud_icon = "hudchiefscienceofficer"
	total_positions = 1
	spawn_positions = 1	
	head_position = 1
	minimal_player_age = 5
	ideal_character_age = 60
	req_admin_notify = 1
	economic_power = 10
	guestbanned = 1	
	must_fill = 1
	not_random_selectable = 1
	min_skill = list(   SKILL_LITERACY    = SKILL_ADEPT,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_FINANCE     = SKILL_ADEPT,
	                    SKILL_BOTANY      = SKILL_BASIC,
	                    SKILL_ANATOMY     = SKILL_BASIC,
	                    SKILL_DEVICES     = SKILL_BASIC,
	                    SKILL_SCIENCE     = SKILL_ADEPT
	)

	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX
	)
	skill_points = 30
	allowed_branches = list(
		/datum/mil_branch/ntsfod
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee
	)
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/command/cso
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
	minimal_access = list(
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
//
//
/datum/job/tradeship_ce
	title = "Chief Engineer"
	supervisors = "Commanding and Executive Officer"
	selection_color = "#f39e27"
	department_refs = list(
		DEPT_ENGINEERING,
		DEPT_COMMAND
	)
	hud_icon = "hudchiefengineer"
	total_positions = 1
	spawn_positions = 1	
	head_position = 1
	minimal_player_age = 5
	ideal_character_age = 40
	req_admin_notify = 1
	economic_power = 10
	guestbanned = 1	
	must_fill = 1
	not_random_selectable = 1
	min_skill = list(   SKILL_LITERACY     = SKILL_ADEPT,
	                    SKILL_COMPUTER     = SKILL_ADEPT,
	                    SKILL_EVA          = SKILL_ADEPT,
	                    SKILL_CONSTRUCTION = SKILL_ADEPT,
	                    SKILL_ELECTRICAL   = SKILL_ADEPT,
	                    SKILL_ATMOS        = SKILL_ADEPT,
	                    SKILL_ENGINES      = SKILL_EXPERT
	)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 30
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/o2,
		/datum/mil_rank/arm/o3
	)
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/command/ce
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
		access_ai_upload
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
		access_ai_upload
	)
//
//
/datum/job/tradeship_cmo
	title = "Chief Medical Officer"
	supervisors = "Commanding and Executive Officer"
	selection_color = "#5a96bb"
	department_refs = list(
		DEPT_MEDICAL,
		DEPT_COMMAND
	)
	hud_icon = "hudchiefmedicalofficer"
	total_positions = 1
	spawn_positions = 1	
	head_position = 1
	minimal_player_age = 5
	ideal_character_age = 35
	req_admin_notify = 1
	economic_power = 10
	guestbanned = 1	
	must_fill = 1
	not_random_selectable = 1
	min_skill = list(   SKILL_LITERACY    = SKILL_ADEPT,
	                    SKILL_MEDICAL     = SKILL_EXPERT,
	                    SKILL_ANATOMY     = SKILL_EXPERT,
	                    SKILL_CHEMISTRY   = SKILL_BASIC,
	                    SKILL_DEVICES     = SKILL_ADEPT
	)

	max_skill = list(   SKILL_MEDICAL     = SKILL_MAX,
	                    SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_CHEMISTRY   = SKILL_MAX
	)
	skill_points = 26
	allowed_branches = list(
		/datum/mil_branch/ntsfod
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee
	)
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/command/cmo
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_bridge,
		access_heads,
		access_chemistry,
		access_virology,
		access_cmo,
		access_surgery,
		access_RC_announce,
		access_keycard_auth,
		access_sec_doors,
		access_psychiatrist,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_bridge,
		access_heads,
		access_chemistry,
		access_virology,
		access_cmo,
		access_surgery,
		access_RC_announce,
		access_keycard_auth,
		access_sec_doors,
		access_psychiatrist,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks
	)
//
//
/datum/job/tradeship_cos
	title = "Chief of Security"
	supervisors = "Commanding and Executive Officer"
	selection_color = "#134975"
	department_refs = list(
		DEPT_SECURITY,
		DEPT_COMMAND
	)
	hud_icon = "hudchiefofsecurity"
	total_positions = 1
	spawn_positions = 1	
	head_position = 1
	minimal_player_age = 5
	ideal_character_age = 30
	req_admin_notify = 1
	economic_power = 10
	guestbanned = 1	
	must_fill = 1
	not_random_selectable = 1
	skill_points = 16	
	min_skill = list(   SKILL_LITERACY    = SKILL_ADEPT,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_ADEPT,
	                    SKILL_FORENSICS   = SKILL_BASIC
	)

	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_FORENSICS   = SKILL_MAX
	)
	skill_points = 28
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/o2,
		/datum/mil_rank/arm/o3
	)
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/command/cmo
	access = list()
	minimal_access = list()

//