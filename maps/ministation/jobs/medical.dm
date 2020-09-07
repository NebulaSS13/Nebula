/datum/job/ministation/doctor
	title = "Medical Doctor"
	department_refs = list(DEPT_MEDICAL)
	head_position = 0
	supervisors = "the Lieutenant and the Captain"
	total_positions = 2
	spawn_positions = 2
	alt_titles = list("Surgeon","Chemist","Nurse")
	skill_points = 24
	hud_icon = "hudmedicaldoctor"
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
	selection_color = "#013d3b"
	economic_power = 7
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
		access_morgue,
		access_surgery,
		access_virology
	)
	outfit_type = /decl/hierarchy/outfit/job/ministation/doctor
	minimal_player_age = 3