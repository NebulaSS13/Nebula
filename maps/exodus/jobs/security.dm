/datum/job/hos
	title = "Head of Security"
	head_position = 1
	department_types = list(
		/decl/department/security,
		/decl/department/command
	)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#8e2929"
	req_admin_notify = 1
	economic_power = 10
	access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_heads,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels,
		access_all_personal_lockers,
		access_research,
		access_engine,
		access_mining,
		access_medical,
		access_construction,
		access_mailsorting,
		access_bridge,
		access_hos,
		access_RC_announce,
		access_keycard_auth,
		access_gateway,
		access_external_airlocks
	)
	minimal_access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_heads,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels,
		access_all_personal_lockers,
		access_research,
		access_engine,
		access_mining,
		access_medical,
		access_construction,
		access_mailsorting,
		access_bridge,
		access_hos,
		access_RC_announce,
		access_keycard_auth,
		access_gateway,
		access_external_airlocks
	)
	minimal_player_age = 14
	guestbanned = 1
	must_fill = 1
	not_random_selectable = 1
	outfit_type = /decl/outfit/job/security/hos
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC
	)
	max_skill = list(
		SKILL_COMBAT    = SKILL_MAX,
		SKILL_WEAPONS   = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX
	)
	skill_points = 28
	software_on_spawn = list(
		/datum/computer_file/program/comm,
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/reports
	)
	event_categories = list(ASSIGNMENT_SECURITY)

/datum/job/hos/equip_job(var/mob/living/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)

/datum/job/warden
	title = "Warden"
	department_types = list(/decl/department/security)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#601c1c"
	economic_power = 5
	access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_maint_tunnels,
		access_morgue,
		access_external_airlocks
	)
	minimal_access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_maint_tunnels,
		access_external_airlocks
	)
	minimal_player_age = 7
	outfit_type = /decl/outfit/job/security/warden
	guestbanned = 1
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC
	)
	max_skill = list(
		SKILL_COMBAT    = SKILL_MAX,
		SKILL_WEAPONS   = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX
	)
	skill_points = 20
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)

/datum/job/detective
	title = "Detective"
	department_types = list(/decl/department/security)

	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of security"
	selection_color = "#601c1c"
	alt_titles = list(
		"Forensic Technician" = /decl/outfit/job/security/detective/forensic
	)
	economic_power = 5
	access = list(
		access_security,
		access_sec_doors,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels
	)
	minimal_access = list(
		access_security,
		access_sec_doors,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels
	)
	minimal_player_age = 7
	outfit_type = /decl/outfit/job/security/detective
	guestbanned = 1
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COMPUTER  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_BASIC,
		SKILL_FORENSICS = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_COMBAT    = SKILL_MAX,
	    SKILL_WEAPONS   = SKILL_MAX,
	    SKILL_FORENSICS = SKILL_MAX
	)
	skill_points = 20
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)

/datum/job/officer
	title = "Security Officer"
	department_types = list(/decl/department/security)
	total_positions = 4
	spawn_positions = 4
	supervisors = "the head of security"
	selection_color = "#601c1c"
	alt_titles = list("Junior Officer")
	economic_power = 4
	access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_morgue,
		access_external_airlocks
	)
	minimal_access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_external_airlocks
	)
	minimal_player_age = 7
	outfit_type = /decl/outfit/job/security/officer
	guestbanned = 1
	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC
	)
	max_skill = list(
		SKILL_COMBAT    = SKILL_MAX,
	    SKILL_WEAPONS   = SKILL_MAX,
	    SKILL_FORENSICS = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)
	event_categories = list(ASSIGNMENT_SECURITY)

/obj/item/card/id/security
	name = "identification card"
	desc = "A card issued to security staff."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_MAROON

/obj/item/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	extra_details = list("goldstripe")
