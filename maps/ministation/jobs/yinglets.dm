/datum/job/yinglet/yinglet_rep
	title = "Enclave Representative"
	alt_titles = list("Patriarch","Enclave Diplomat", "Enclave Ambassador", "Matriarch" = /decl/hierarchy/outfit/job/yinglet/yinglet_rep/matriarch)
	hud_icon = "hudyingmatriarch"
	spawn_positions = 1
	total_positions = 1
	supervisors = "the needs and wants of your Enclave"
	outfit_type = /decl/hierarchy/outfit/job/yinglet/yinglet_rep
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
	skill_points = 25
	department_types = list(/decl/department/enclave)
	selection_color = "#2f2f7f"
	access = list(access_lawyer)
	minimal_access = list(access_lawyer)