/datum/job/standard/doctor/tradeship
	title = "Junior Doctor"
	supervisors = "the Head Doctor and the Captain"
	alt_titles = list()
	// Slightly beefier skills due to smaller crew.
	skill_points = 24
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
	outfit_type = /decl/outfit/job/tradeship/doc/junior
	event_categories = list(ASSIGNMENT_MEDICAL)

/datum/job/standard/cmo/tradeship
	title = "Head Doctor"
	supervisors = "the Captain and your own ethics"
	outfit_type = /decl/outfit/job/tradeship/doc
	alt_titles = list("Surgeon")
	// Slightly beefier skills due to smaller crew.
	skill_points = 28
