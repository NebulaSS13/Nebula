/datum/job/ministation/ncr
	title = "NCR Recruit"
	total_positions = 4
	spawn_positions = 4
	supervisors = "absolutely everyone"
	economic_power = 1
	access = list()
	minimal_access = list()
	alt_titles = list("NCR Private", "NCR Conscript")
	outfit_type = /decl/outfit/job/ncr
	department_types = list(/decl/department/ncr)
	selection_color = "#cc8c5c"

	min_skill = list(SKILL_WEAPONS	= SKILL_BASIC)
	max_skill = list(SKILL_WEAPONS	= SKILL_EXPERT)
	skill_points = 20


/datum/job/ministation/ncr/trooper
	title = "NCR Trooper"
	total_positions = 4
	spawn_positions = 4
	alt_titles = list("NCR Soldier", "NCR Infantry")
	outfit_type = /decl/outfit/job/ncr

	min_skill = list(SKILL_WEAPONS	= SKILL_BASIC)
	max_skill = list(SKILL_WEAPONS	= SKILL_MAX)
	skill_points = 24



//NCO Roles
/datum/job/ministation/ncr/nco
	title = "NCR Corporal"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/outfit/job/ncr/nco
	alt_titles = list()

	min_skill = list(
		SKILL_LITERACY 	= SKILL_BASIC,
		SKILL_HAULING 	= SKILL_BASIC,
		SKILL_WEAPONS	= SKILL_ADEPT
	)
	max_skill = list(
		SKILL_COMBAT	= SKILL_EXPERT,
		SKILL_WEAPONS	= SKILL_MAX
	)
	skill_points = 28	//Higher ranks get more skills.


/datum/job/ministation/ncr/nco/sergeant
	title = "NCR Sergeant"
	outfit_type = /decl/outfit/job/ncr/sergeant
	alt_titles = list()

	skill_points = 30	//Higher ranks get more skills.


/datum/job/ministation/ncr/nco/firstsergeant
	title = "NCR First Sergeant"
	outfit_type = /decl/outfit/job/ncr/first
	alt_titles = list()

	skill_points = 32	//Higher ranks get more skills.

//Officers
/datum/job/ministation/ncr/co
	title = "NCR Commanding Officer"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/outfit/job/ncr/co
	alt_titles = list("NCR Lieutenant")
	selection_color = "#a3714b"

	min_skill = list(
		SKILL_LITERACY 	= SKILL_ADEPT,
		SKILL_HAULING 	= SKILL_ADEPT,
		SKILL_WEAPONS	= SKILL_ADEPT
	)

	max_skill = list(
		SKILL_MEDICAL   = SKILL_ADEPT,
		SKILL_COMBAT	= SKILL_EXPERT,
		SKILL_WEAPONS	= SKILL_MAX
	)
	skill_points = 36	//Higher ranks get more skills.


//Specialist jobs
/datum/job/ministation/ncr/osi
	title = "OSI Researcher"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/outfit/job/ncr/osi
	alt_titles = list()

	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_HAULING 	= SKILL_ADEPT,
		SKILL_WEAPONS	= SKILL_BASIC,
		SKILL_MEDICAL   = SKILL_EXPERT,
		SKILL_ANATOMY   = SKILL_EXPERT,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL   = SKILL_MAX,
		SKILL_ANATOMY   = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)
	skill_points = 32	//Higher ranks get more skills.


/datum/job/ministation/ncr/supply
	title = "OSI Cadet"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/outfit/job/ncr/support
	alt_titles = list()

	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_HAULING 	= SKILL_ADEPT,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	skill_points = 20	//Higher ranks get more skills.


/datum/job/ministation/ncr/offduty
	title = "NCR Off-Duty"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/outfit/job/ncr/support
	alt_titles = list()

	min_skill = list()
	skill_points = 20


/datum/job/ministation/ncr/specialist
	title = "NCR Specialist"
	total_positions = 2
	spawn_positions = 2
	alt_titles = list()
	outfit_type = /decl/outfit/job/ncr/support

	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_WEAPONS	= SKILL_BASIC,

	// Due to the lack of books we have to give them basic medical and engineering to let them know that they really should be
		SKILL_MEDICAL   = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_BASIC,
		SKILL_ELECTRICAL   = SKILL_BASIC,
	)
	max_skill = list(
		SKILL_MEDICAL   = SKILL_MAX,
		SKILL_ANATOMY   = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX,
	)
	skill_points = 32	//Higher ranks get more skills.



//Rangers
/datum/job/ministation/ncr/ranger
	title = "NCR Ranger"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/outfit/job/ncr/ranger
	alt_titles = list("NCR Patrol Ranger", "NCR Trail Ranger", "NCR Recon Ranger")
	selection_color = "#7a5233"

	min_skill = list(
		SKILL_LITERACY 	= SKILL_BASIC,
		SKILL_HAULING	= SKILL_ADEPT,
		SKILL_WEAPONS	= SKILL_ADEPT,
		SKILL_COMBAT	= SKILL_BASIC,
	)

	max_skill = list(
		SKILL_COMBAT	= SKILL_EXPERT,
		SKILL_HAULING 	= SKILL_EXPERT,
		SKILL_WEAPONS	= SKILL_MAX
	)
	skill_points = 30	//Higher ranks get more skills.


/datum/job/ministation/ncr/sgtranger
	title = "NCR Ranger Sergeant"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/outfit/job/ncr/sgtranger
	alt_titles = list()
	selection_color = "#7a5233"

	min_skill = list(
		SKILL_LITERACY 	= SKILL_BASIC,
		SKILL_HAULING 	= SKILL_ADEPT,
		SKILL_WEAPONS	= SKILL_ADEPT,
		SKILL_COMBAT	= SKILL_ADEPT,
	)

	max_skill = list(
		SKILL_COMBAT	= SKILL_MAX,
		SKILL_WEAPONS	= SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
	)
	skill_points = 32	//Higher ranks get more skills.


/datum/job/ministation/ncr/vetranger
	title = "NCR Veteran Ranger"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/outfit/job/ncr/vetranger
	alt_titles = list()
	selection_color = "#593d26"

	min_skill = list(
		SKILL_LITERACY 	= SKILL_ADEPT,
		SKILL_HAULING 	= SKILL_EXPERT,
		SKILL_WEAPONS	= SKILL_EXPERT,
		SKILL_COMBAT	= SKILL_EXPERT,
	)

	max_skill = list(
		SKILL_COMBAT	= SKILL_MAX,
		SKILL_WEAPONS	= SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
	)
	skill_points = 36	//Higher ranks get more skills.


