var/global/list/latejoin_cryo_two = list()
var/global/list/latejoin_cryo_captain = list()
/obj/abstract/landmark/latejoin/cryo_two/add_loc()
	global.latejoin_cryo_two |= get_turf(src)

/obj/abstract/landmark/latejoin/cryo_captain/add_loc()
	global.latejoin_cryo_captain |= get_turf(src)

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
	msg = "has completed revival in the port cryogenics bay"
	disallow_job = list(/datum/job/tradeship_robot)

/decl/spawnpoint/cryo/two
	name = "Starboard Cryogenic Storage"
	msg = "has completed revival in the starboard cryogenics bay"

/decl/spawnpoint/cryo/two/Initialize()
	. = ..()
	turfs = global.latejoin_cryo_two

/decl/spawnpoint/cryo/captain
	name = "Captain Compartment"
	msg = "has completed revival in the captain compartment"
	restrict_job = list(/datum/job/tradeship_captain)

/decl/spawnpoint/cryo/captain/Initialize()
	. = ..()
	turfs = global.latejoin_cryo_captain
