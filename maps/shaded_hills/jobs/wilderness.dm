/decl/department/shaded_hills/locals
	name                    = "Locals"
	colour                  = "#40684a"
	display_color           = "#8cc4a8"

/datum/job/shaded_hills/local
	abstract_type           = /datum/job/shaded_hills/local
	department_types        = list(/decl/department/shaded_hills/locals)

/datum/job/shaded_hills/local/miner
	title                   = "Miner"
	description             = "You mine ores from the mountain, and occasionally refine them, too. The only limit to your potential bounty is your own hard work and ingenuity... and the kobaloi in the caves."
	supervisors             = "the consequences of your actions"
	spawn_positions         = 1
	total_positions         = 1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/miner

/obj/abstract/landmark/start/shaded_hills/miner
	name                    = "Miner"

/datum/job/shaded_hills/local/herbalist
	title                   = "Herbalist"
	description             = "You collect and grow plants and herbs and process them into various useful substances, such as medicinal tinctures, ointments, and teas."
	supervisors             = "nature"
	spawn_positions         = 1
	total_positions         = 1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/herbalist

/obj/abstract/landmark/start/shaded_hills/herbalist
	name                    = "Herbalist"

/datum/job/shaded_hills/local/forester
	title                   = "Forester"
	description             = "You are at home in nature, whether you're fishing, hunting wild game, or chopping timber for firewood and construction."
	supervisors             = "nature"
	spawn_positions         = 1
	total_positions         = 1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/forester

/obj/abstract/landmark/start/shaded_hills/forester
	name                    = "Forester"
