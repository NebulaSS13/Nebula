/datum/map/tradeship
	allowed_spawns = list(
		/decl/spawnpoint/cryo,
		/decl/spawnpoint/cryo/two,
		/decl/spawnpoint/cyborg,
		/decl/spawnpoint/cryo/captain
	)
	default_spawn = /decl/spawnpoint/cryo

/decl/spawnpoint/cryo
	name = "Port Cryogenic Storage"
	spawn_announcement = "has completed revival in the port cryogenics bay"
	disallow_job = list(/datum/job/tradeship_robot)

/decl/spawnpoint/cryo/two
	name = "Starboard Cryogenic Storage"
	spawn_announcement = "has completed revival in the starboard cryogenics bay"

/obj/abstract/landmark/latejoin/cryo_two
	spawn_decl = /decl/spawnpoint/cryo/two

/decl/spawnpoint/cryo/captain
	name = "Captain Compartment"
	spawn_announcement = "has completed revival in the captain compartment"
	restrict_job = list(/datum/job/tradeship_captain)

/obj/abstract/landmark/latejoin/cryo_captain
	spawn_decl = /decl/spawnpoint/cryo/captain

