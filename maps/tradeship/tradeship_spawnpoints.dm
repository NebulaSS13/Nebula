/datum/map/tradeship
	allowed_latejoin_spawns = list(
		/decl/spawnpoint/cryo,
		/decl/spawnpoint/cryo/two,
		/decl/spawnpoint/cyborg,
	)
	default_spawn = /decl/spawnpoint/cryo

/decl/spawnpoint/cryo
	name = "Port Cryogenic Storage"
	spawn_announcement = "has completed revival in the port cryogenics bay"
	disallow_job = list(/datum/job/standard/robot)

/decl/spawnpoint/cryo/two
	name = "Starboard Cryogenic Storage"
	spawn_announcement = "has completed revival in the starboard cryogenics bay"
	uid = "spawn_cryo_two"

/obj/abstract/landmark/latejoin/cryo_two
	spawn_decl = /decl/spawnpoint/cryo/two

/decl/spawnpoint/cryo/captain
	name = "Captain Compartment"
	spawn_announcement = "has completed revival in the captain compartment"
	restrict_job = list(/datum/job/standard/captain/tradeship)
	uid = "spawn_cryo_captain"

/obj/abstract/landmark/latejoin/cryo_captain
	spawn_decl = /decl/spawnpoint/cryo/captain
