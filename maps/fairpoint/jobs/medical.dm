/datum/job/cmo
	title = "Hospital Director"
	head_position = 1
	department_types = list(
		/decl/department/medical,
		/decl/department/command
	)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the district mayor"
	selection_color = "#026865"
	req_admin_notify = 1
	economic_power = 10
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
	minimal_player_age = 14
	ideal_character_age = 50
	guestbanned = 1
	must_fill = 1
	not_random_selectable = 1
	alt_titles = list("Chief of Medicine", "Hospital Administrator", "Medical Director")
	outfit_type = /decl/hierarchy/outfit/job/medical/cmo
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_MEDICAL   = SKILL_EXPERT,
		SKILL_ANATOMY   = SKILL_EXPERT,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL   = SKILL_MAX,
		SKILL_ANATOMY   = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)
	skill_points = 26
	software_on_spawn = list(
		/datum/computer_file/program/comm,
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/reports
	)
	event_categories = list(ASSIGNMENT_MEDICAL)

/datum/job/doctor
	title = "Doctor"
	department_types = list(/decl/department/medical)
	minimal_player_age = 3
	total_positions = 6
	spawn_positions = 3
	supervisors = "the hospital director"
	selection_color = "#013d3b"
	economic_power = 7
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_chemistry,
		access_virology,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks,
		access_psychiatrist
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks
	)
	alt_titles = list(
		"Surgeon" =             /decl/hierarchy/outfit/job/medical/doctor/surgeon,
		"Emergency Physician" = /decl/hierarchy/outfit/job/medical/doctor/emergency_physician,
		"Nurse" =               /decl/hierarchy/outfit/job/medical/doctor/nurse,
		"Coroner" =             /decl/hierarchy/outfit/job/medical/doctor/surgeon,
		"Physician", "Medical Intern")
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_EVA      = SKILL_BASIC,
		SKILL_MEDICAL  = SKILL_BASIC,
		SKILL_ANATOMY  = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL   = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor
	)
	skill_points = 22
	event_categories = list(ASSIGNMENT_MEDICAL)

/datum/job/chemist
	title = "Pharmacist"
	department_types = list(/decl/department/medical)
	minimal_player_age = 7
	total_positions = 2
	spawn_positions = 2
	supervisors = "the hospital director"
	selection_color = "#013d3b"
	economic_power = 5
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_chemistry,
		access_virology
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_chemistry
	)
	outfit_type = /decl/hierarchy/outfit/job/medical/chemist
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_MEDICAL   = SKILL_ADEPT,
		SKILL_CHEMISTRY = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_MEDICAL   = SKILL_ADEPT,
		SKILL_ANATOMY	= SKILL_ADEPT,
		SKILL_CHEMISTRY = SKILL_MAX
	)
	skill_points = 16

/datum/job/counselor
	title = "Counselor"
	alt_titles = list("Mentalist", "Psychiatrist", "Psychotherapist","Therapist", "Social Worker")
	department_types = list(/decl/department/medical)
	total_positions = 1
	spawn_positions = 1
	economic_power = 5
	minimal_player_age = 3
	supervisors = "the hospital director"
	selection_color = "#013d3b"
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_chemistry,
		access_virology,
		access_psychiatrist
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_psychiatrist
	)
	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_MEDICAL  = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL  = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor
	)

// Department-flavor IDs
/obj/item/card/id/medical
	name = "identification card"
	desc = "A card issued to medical staff."
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/card/id/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	extra_details = list("goldstripe")
