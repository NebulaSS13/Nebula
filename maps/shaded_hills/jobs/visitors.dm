/decl/department/shaded_hills/visitors
	name                    = "Visitors"
	colour                  = "#685b40"
	display_color           = "#c4bc8c"

/datum/job/shaded_hills/visitor
	abstract_type           = /datum/job/shaded_hills/visitor
	department_types        = list(/decl/department/shaded_hills/visitors)

/datum/job/shaded_hills/visitor/traveller
	title                   = "Traveller"
	supervisors             = "your conscience"
	description             = "You have travelled to this area from elsewhere. You may be a vagabond, a wastrel, a nomad, or just passing through on your way to somewhere else. How long you're staying and where you're headed is up to you entirely."
	spawn_positions         = -1
	total_positions         = -1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/traveller
	skill_points            = 20

/obj/abstract/landmark/start/shaded_hills/traveller
	name                    = "Traveller"

/datum/job/shaded_hills/visitor/traveller/learned
	title                   = "Itinerant Scholar"
	// todo: outfits for alt-titles?
	alt_titles              = list("Itinerant Monk", "Travelling Doctor", "Dilettante")
	supervisors             = "your conscience"
	description             = "You are a skilled professional who has travelled to this area from elsewhere. You may be a doctor, a scholar, a monk, or some other highly-educated individual with rare skills. Whatever your reason for coming here, you are likely one of the only individuals in the area to possess your unique skillset."
	spawn_positions         = 2
	total_positions         = 2
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/traveller/scholar
	skill_points            = 26
	min_skill               = list(
		SKILL_LITERACY      = SKILL_ADEPT
	)
	max_skill               = list(
		SKILL_CHEMISTRY     = SKILL_MAX,
		SKILL_MEDICAL       = SKILL_MAX,
		SKILL_ANATOMY       = SKILL_MAX,
	)

/obj/abstract/landmark/start/shaded_hills/traveller/learned
	name                    = "Itinerant Scholar"

/datum/job/shaded_hills/visitor/beggar_knight
	title                   = "Beggar Knight"
	supervisors             = "your vows"
	description             = "You are a wandering swordmaster sworn to a vow of poverty, with nothing to your name but the armour on your back and the blade at your hip. Beggar knights are tolerated due to their martial prowess, and are usually paid with food or new equipment as they are avowed against carrying coin."
	spawn_positions         = 2
	total_positions         = 2
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/beggar_knight
	min_skill               = list(
		SKILL_COMBAT        = SKILL_ADEPT,
		SKILL_WEAPONS       = SKILL_ADEPT,
		SKILL_ATHLETICS     = SKILL_ADEPT
	)
	max_skill               = list(
		SKILL_COMBAT        = SKILL_MAX,
		SKILL_WEAPONS       = SKILL_MAX,
		SKILL_CARPENTRY     = SKILL_BASIC,
		SKILL_METALWORK     = SKILL_BASIC,
		SKILL_TEXTILES      = SKILL_BASIC,
		SKILL_STONEMASONRY  = SKILL_BASIC,
		SKILL_SCULPTING     = SKILL_BASIC,
		SKILL_ARTIFICE      = SKILL_BASIC,
		SKILL_FINANCE       = SKILL_NONE
	)

/obj/abstract/landmark/start/shaded_hills/beggar_knight
	name                    = "Beggar Knight"


/datum/job/shaded_hills/visitor/traveller/cleric
	title                   = "Travelling Cleric"
	supervisors             = "your vows, and your faith"
	description             = "You are an ordained person of faith, travelling the lands on the business of your order, to preach, or simply to experience new people and cultures. You are battle-trained, but are also a healer."
	spawn_positions         = 2
	total_positions         = 2
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/traveller/cleric
	min_skill               = list(
		SKILL_COMBAT        = SKILL_ADEPT,
		SKILL_WEAPONS       = SKILL_ADEPT,
		SKILL_ATHLETICS     = SKILL_ADEPT,
		SKILL_MEDICAL       = SKILL_ADEPT,
		SKILL_ANATOMY       = SKILL_ADEPT
	)
	max_skill               = list(
		SKILL_COMBAT        = SKILL_MAX,
		SKILL_WEAPONS       = SKILL_MAX,
		SKILL_MEDICAL       = SKILL_MAX,
		SKILL_ANATOMY       = SKILL_MAX
	)
	skill_points            = 22

/obj/abstract/landmark/start/shaded_hills/cleric
	name                    = "Travelling Cleric"

