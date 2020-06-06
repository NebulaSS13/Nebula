GLOBAL_LIST_EMPTY(latejoin_cryo_two)

/obj/effect/landmark/Initialize()
	if(name == "JoinLateCryoTwo")
		GLOB.latejoin_cryo_two += loc
		delete_me = 1
	. = ..()

/datum/map/tradeship
	allowed_spawns = list("Port Cryogenic Storage", "Starboard Cryogenic Storage", "Robot Storage")
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
	turfs = GLOB.latejoin_cryo_two
