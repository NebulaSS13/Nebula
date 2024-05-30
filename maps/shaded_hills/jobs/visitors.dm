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
	alt_titles              = list("Itinerant Monk", "Traveling Doctor", "Dilettante")
	supervisors             = "your conscience"
	description             = "You are a skilled professional who has traveled to this area from elsewhere. You may be a doctor, a scholar, a monk, or some other highly-educated individual with rare skills. Whatever your reason for coming here, you are likely one of the only individuals in the area to possess your unique skillset."
	spawn_positions         = 2
	total_positions         = 2
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/traveller
	skill_points            = 24
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
