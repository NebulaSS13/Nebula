/decl/department/shaded_hills/locals
	name                    = "Locals"
	colour                  = "#40684a"
	display_color           = "#8cc4a8"

/datum/job/shaded_hills/local
	abstract_type           = /datum/job/shaded_hills/local
	department_types        = list(/decl/department/shaded_hills/locals)

/datum/job/shaded_hills/local/miner
	title                   = "Miner"
	spawn_positions         = 1
	total_positions         = 1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/miner

/obj/abstract/landmark/start/shaded_hills/miner
	name                    = "Miner"

/datum/job/shaded_hills/local/herbalist
	title                   = "Herbalist"
	spawn_positions         = 1
	total_positions         = 1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/herbalist

/obj/abstract/landmark/start/shaded_hills/herbalist
	name                    = "Herbalist"

/datum/job/shaded_hills/local/forester
	title                   = "Forester"
	spawn_positions         = 1
	total_positions         = 1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/forester

/obj/abstract/landmark/start/shaded_hills/forester
	name                    = "Forester"
