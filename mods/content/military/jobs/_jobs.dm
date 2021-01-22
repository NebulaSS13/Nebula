/datum/job/cyborg
	supervisors = "your laws and the Captain"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()

/datum/job/assistant
	title = "Crewman"
	supervisors = "literally everyone, you bottom feeder"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/misc/crewman
	alt_titles = list("Passenger")
	hud_icon = "hudcrewman"
	allowed_branches = list(
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen,
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/arm/e2,
		/datum/mil_rank/arm/e3,
		/datum/mil_rank/civ/civ
	)