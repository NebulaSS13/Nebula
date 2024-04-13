/decl/department/shaded_hills/visitors
	name                    = "Visitors"
	colour                  = "#685b40"
	display_color           = "#c4bc8c"

/datum/job/shaded_hills/visitor
	abstract_type           = /datum/job/shaded_hills/visitor
	department_types        = list(/decl/department/shaded_hills/visitors)

/datum/job/shaded_hills/visitor/traveller
	title                   = "Traveller"
	spawn_positions         = -1
	total_positions         = -1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/traveller

/obj/abstract/landmark/start/shaded_hills/traveller
	name                    = "Traveller"
