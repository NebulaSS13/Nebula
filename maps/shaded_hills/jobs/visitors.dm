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

/obj/abstract/landmark/start/shaded_hills/traveller
	name                    = "Traveller"
