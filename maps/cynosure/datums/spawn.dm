/decl/spawnpoint/wilderness
	name = "Wilderness"
	restrict_job = list(
		/datum/job/cynosure/survivalist,
		/datum/job/cynosure/trained_animal
	)
	uid = "spawn_cynosure_wilderness"

/obj/abstract/landmark/latejoin/wilderness
	name = "Wilderness Latejoin"
	spawn_decl = /decl/spawnpoint/wilderness

/decl/spawnpoint/checkpoint
	name = "Checkpoint"
	uid = "spawn_cynosure_checkpoint"

/obj/abstract/landmark/latejoin/checkpoint
	name = "Checkpoint Latejoin"
	spawn_decl = /decl/spawnpoint/checkpoint
