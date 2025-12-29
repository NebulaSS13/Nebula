/datum/job/ministation/bos
	title = "Initiate"
	total_positions = 3
	spawn_positions = 3
	supervisors = "absolutely everyone"
	economic_power = 1
	access = list()
	minimal_access = list()
	alt_titles = list("Knight Initiate", "Scribe Initiate")
	outfit_type = /decl/outfit/job/bos
	department_types = list(/decl/department/bos)
	selection_color = "#727d7c"
	skill_points = 32		//They can spec into combat or non-combat, need high skill points to compensate
	min_skill = list(SKILL_LITERACY = SKILL_BASIC)		//Still need to be able to read.
	max_skill = list(SKILL_WEAPONS	= SKILL_EXPERT)



/datum/job/ministation/bos/knight
	title = "Knight"
	total_positions = 3
	spawn_positions = 3
	alt_titles = list("Knight-Engineer", "Knight-Warden")
	outfit_type = /decl/outfit/job/bos/knight

	min_skill = list(
		SKILL_WEAPONS	= SKILL_ADEPT,
		SKILL_LITERACY 	= SKILL_BASIC,
		SKILL_HAULING 	= SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_BASIC,
		SKILL_ELECTRICAL   = SKILL_BASIC,
		)
	max_skill = list(SKILL_WEAPONS	= SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_EXPERT,
		SKILL_ELECTRICAL   = SKILL_EXPERT)
	skill_points = 24				//These guys are also engineers to they might need a few more skill points



/datum/job/ministation/bos/snrknight
	title = "Senior Knight"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()
	outfit_type = /decl/outfit/job/bos/knight/snr

	min_skill = list(
		SKILL_WEAPONS	= SKILL_ADEPT,
		SKILL_LITERACY 	= SKILL_ADEPT,
		SKILL_HAULING 	= SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_ADEPT,
		)

	max_skill = list(
		SKILL_WEAPONS	= SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX)

	skill_points = 26				//These guys are also engineers to they might need a few more skill points



/datum/job/ministation/bos/headknight
	title = "Knight-Captain"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()
	selection_color = "#5a6362"
	outfit_type = /decl/outfit/job/bos/knight/head


	min_skill = list(
		SKILL_WEAPONS	= SKILL_ADEPT,
		SKILL_LITERACY 	= SKILL_ADEPT,
		SKILL_HAULING 	= SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_ADEPT,
		)

	max_skill = list(
		SKILL_WEAPONS	= SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX)

	skill_points = 28				//These guys are also engineers to they might need a few more skill points


/datum/job/ministation/bos/scribe
	title = "Scribe"
	total_positions = 3
	spawn_positions = 3
	alt_titles = list("Scribe-Chemist", "Scribe-Archivist", "Scribe-Physician", "Field Scribe")
	outfit_type = /decl/outfit/job/bos/scribe

	min_skill = list(
		SKILL_LITERACY  = SKILL_EXPERT,
		SKILL_MEDICAL   = SKILL_ADEPT,
		SKILL_ANATOMY   = SKILL_ADEPT,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL   = SKILL_MAX,
		SKILL_ANATOMY   = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)

	max_skill = list()

	skill_points = 18			//They start with very high skills


/datum/job/ministation/bos/snrscribe
	title = "Proctor"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()
	outfit_type = /decl/outfit/job/bos/scribe/snr

	min_skill = list(
		SKILL_LITERACY  = SKILL_EXPERT,
		SKILL_MEDICAL   = SKILL_EXPERT,
		SKILL_ANATOMY   = SKILL_EXPERT,
		SKILL_CHEMISTRY = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_MEDICAL   = SKILL_MAX,
		SKILL_ANATOMY   = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)

	max_skill = list()

	skill_points = 18			//They start with very high skills


/datum/job/ministation/bos/headscribe
	title = "Head Scribe"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()
	selection_color = "#5a6362"
	outfit_type = /decl/outfit/job/bos/scribe/head

	min_skill = list(
		SKILL_WEAPONS	= SKILL_BASIC,
		SKILL_LITERACY  = SKILL_MAX,
		SKILL_MEDICAL   = SKILL_EXPERT,
		SKILL_ANATOMY   = SKILL_EXPERT,
		SKILL_CHEMISTRY = SKILL_EXPERT
	)
	max_skill = list(
		SKILL_MEDICAL   = SKILL_MAX,
		SKILL_ANATOMY   = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)

	max_skill = list()

	skill_points = 20			//They start with very high skills



/datum/job/ministation/bos/paladin
	title = "Paladin"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()
	outfit_type = /decl/outfit/job/bos/paladin

	min_skill = list(
		SKILL_WEAPONS	= SKILL_ADEPT,
		SKILL_LITERACY 	= SKILL_ADEPT,
		SKILL_HAULING 	= SKILL_ADEPT
		)
	max_skill = list(SKILL_WEAPONS	= SKILL_MAX)
	skill_points = 18	//They are JUST meant to kill and not much else


/datum/job/ministation/bos/snrpaladin
	title = "Senior Paladin"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list("Star Paladin")
	outfit_type = /decl/outfit/job/bos/paladin

	min_skill = list(
		SKILL_WEAPONS	= SKILL_EXPERT,
		SKILL_LITERACY 	= SKILL_EXPERT,
		SKILL_HAULING 	= SKILL_ADEPT
		)
	max_skill = list(SKILL_WEAPONS	= SKILL_MAX)
	skill_points = 18	//They are JUST meant to kill and not much else


/datum/job/ministation/bos/headpaladin
	title = "Head Paladin"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()
	selection_color = "#5a6362"
	outfit_type = /decl/outfit/job/bos/paladin/head

	min_skill = list(
		SKILL_WEAPONS	= SKILL_EXPERT,
		SKILL_LITERACY 	= SKILL_EXPERT,
		SKILL_HAULING 	= SKILL_ADEPT
		)
	max_skill = list(SKILL_WEAPONS	= SKILL_MAX)
	skill_points = 20	//They are JUST meant to kill and not much else
