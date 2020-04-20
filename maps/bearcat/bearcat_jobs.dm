/datum/map/bearcat
	allowed_jobs = list(
		/datum/job/bearcat_captain, 
		/datum/job/bearcat_first_mate,
		/datum/job/bearcat_chief_engineer,
		/datum/job/bearcat_engineer,
		/datum/job/bearcat_doctor,
		/datum/job/cyborg, 
		/datum/job/assistant
	)

/datum/job/bearcat_captain
	title = "Captain"
	head_position = 1
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
	supervisors = "the Merchant Code and your conscience"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/captain
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS =  SKILL_ADEPT,
		SKILL_SCIENCE =  SKILL_ADEPT,
		SKILL_PILOT =    SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT =   SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX
	)
	skill_points = 30

/datum/job/bearcat_captain/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(src)

/datum/job/bearcat_captain/get_access()
	return get_all_station_access()

/datum/job/bearcat_captain/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.client)
		H.client.verbs += /client/proc/rename_ship
		H.client.verbs += /client/proc/rename_company

/client/proc/rename_ship()
	set name = "Rename Ship"
	set category = "Captain's Powers"

	var/ship = sanitize(input(src, "What is your ship called? Don't add the vessel prefix, the FTV one will be attached automatically.", "Ship name", GLOB.using_map.station_short), MAX_NAME_LEN)
	if(!ship)
		return
	GLOB.using_map.station_short = ship
	GLOB.using_map.station_name = "FTV [ship]"
	var/obj/effect/overmap/visitable/ship/bearcat/B = locate() in world
	if(B)
		B.SetName(GLOB.using_map.station_name)
	command_announcement.Announce("Attention all hands on [GLOB.using_map.station_name]! Thank you for your attention.", "Ship re-christened")
	verbs -= /client/proc/rename_ship

/client/proc/rename_company()
	set name = "Rename Company"
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
		command_announcement.Announce("Congratulations to all employees of [capitalize(GLOB.using_map.company_name)] on the new name. Their rebranding has changed the [GLOB.using_map.company_short] market value by [0.01*rand(-10,10)]%.", "Company name change approved")
	verbs -= /client/proc/rename_company

/datum/job/bearcat_captain/get_access()
	return get_all_station_access()

/datum/job/bearcat_chief_engineer
	title = "Chief Engineer"
	supervisors = "the Captain"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/chief_engineer
	head_position = 1
	department_refs = list(DEPT_ENGINEERING, DEPT_COMMAND)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#7f6e2c"
	req_admin_notify = 1
	economic_power = 10
	ideal_character_age = 50
	guestbanned = 1	
	must_fill = 1
	not_random_selectable = 1
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_bridge, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_bridge, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_player_age = 14
	min_skill = list(
		SKILL_LITERACY =     SKILL_ADEPT,
		SKILL_BUREAUCRACY =  SKILL_BASIC,
		SKILL_COMPUTER =     SKILL_ADEPT,
		SKILL_EVA =          SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL =   SKILL_ADEPT,
		SKILL_ATMOS =        SKILL_ADEPT,
		SKILL_ENGINES =      SKILL_EXPERT
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL =   SKILL_MAX,
		SKILL_ATMOS =        SKILL_MAX,
		SKILL_ENGINES =      SKILL_MAX
	)
	skill_points = 30

/datum/job/bearcat_doctor
	title = "Doc"
	supervisors = "the Captain and your idea of Hippocratic Oath"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/doc
	alt_titles = list("Surgeon")
	total_positions = 1
	spawn_positions = 1
	hud_icon = "hudmedicaldoctor"
	department_refs = list(DEPT_MEDICAL)
	minimal_player_age = 3
	selection_color = "#013d3b"
	economic_power = 7
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology)
	min_skill = list(
		SKILL_LITERACY =    SKILL_ADEPT,
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_MEDICAL =     SKILL_EXPERT,
		SKILL_ANATOMY =     SKILL_EXPERT,
		SKILL_CHEMISTRY =   SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL =   SKILL_MAX,
		SKILL_ANATOMY =   SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)
	skill_points = 28

/datum/job/bearcat_first_mate
	title = "First Mate"
	supervisors = "the Captain and the Merchant Code"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/mate
	hud_icon = "hudheadofpersonnel"
	head_position = 1
	department_refs = list(DEPT_COMMAND, DEPT_CIVILIAN)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 14
	economic_power = 10
	ideal_character_age = 50
	guestbanned = 1	
	not_random_selectable = 1
	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)
	min_skill = list(
		SKILL_LITERACY =    SKILL_ADEPT,
		SKILL_WEAPONS =     SKILL_BASIC,
		SKILL_FINANCE =     SKILL_EXPERT,
		SKILL_BUREAUCRACY = SKILL_ADEPT,
		SKILL_PILOT =       SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT =       SKILL_MAX,
		SKILL_FINANCE =     SKILL_MAX,
		SKILL_BUREAUCRACY = SKILL_ADEPT
	)
	skill_points = 30

/datum/job/bearcat_engineer
	title = "Junior Engineer"
	supervisors = "the Chief Engineer"
	total_positions = 2
	spawn_positions = 2
	hud_icon = "hudengineer"
	department_refs = list(DEPT_ENGINEERING)
	selection_color = "#5b4d20"
	economic_power = 5
	minimal_player_age = 7
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_emergency_storage)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_emergency_storage)
	min_skill = list(
		SKILL_LITERACY =     SKILL_ADEPT,
		SKILL_COMPUTER =     SKILL_BASIC,
		SKILL_EVA =          SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL =   SKILL_BASIC,
		SKILL_ATMOS =        SKILL_BASIC,
		SKILL_ENGINES =      SKILL_BASIC
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL =   SKILL_MAX,
		SKILL_ATMOS =        SKILL_MAX,
		SKILL_ENGINES =      SKILL_MAX
	)
	skill_points = 20
	outfit_type = /decl/hierarchy/outfit/job/bearcat/hand/engine

/datum/job/cyborg
	supervisors = "your laws and the Captain"
	total_positions = 1
	spawn_positions = 1

/datum/job/assistant
	title = "Deck Hand"
	supervisors = "literally everyone, you bottom feeder"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/hand
	alt_titles = list(
		"Cook" = /decl/hierarchy/outfit/job/bearcat/hand/cook,
		"Cargo Hand",
		"Passenger")
	hud_icon = "hudcargotechnician"