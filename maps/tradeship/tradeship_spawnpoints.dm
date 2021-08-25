var/global/list/latejoin_cryo_two = list()
var/global/list/latejoin_cryo_captain = list()
/obj/effect/landmark/latejoin/cryo_two/add_loc()
	global.latejoin_cryo_two |= get_turf(src)

/obj/effect/landmark/latejoin/cryo_captain/add_loc()
	global.latejoin_cryo_captain |= get_turf(src)

/datum/map/tradeship
	allowed_spawns = list("Port Cryogenic Storage", "Starboard Cryogenic Storage", "Robot Storage", "Captain Compartment")
	default_spawn = "Port Cryogenic Storage"

/datum/spawnpoint/cryo
	display_name = "Port Cryogenic Storage"
	msg = "has completed revival in the port cryogenics bay"
	disallow_job = list("Robot")

/datum/spawnpoint/cryo/two
	display_name = "Starboard Cryogenic Storage"
	msg = "has completed revival in the starboard cryogenics bay"
	disallow_job = list("Robot")

/datum/spawnpoint/cryo/two/New()
	..()
	turfs = global.latejoin_cryo_two

/datum/spawnpoint/cryo/captain
	display_name = "Captain Compartment"
	msg = "has completed revival in the captain compartment"
	restrict_job = list("Captain")

/datum/spawnpoint/cryo/captain/New()
	..()
	turfs = global.latejoin_cryo_captain
