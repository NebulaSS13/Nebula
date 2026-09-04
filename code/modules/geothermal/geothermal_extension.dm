/datum/extension/geothermal_vent
	base_type = /datum/extension/geothermal_vent
	expected_type = /obj/effect/geyser
	flags = EXTENSION_FLAG_IMMEDIATE
	var/pressure_min = 1000
	var/pressure_max = 2000
	var/steam_min = 20 SECONDS
	var/steam_max = 60 SECONDS
	var/tmp/next_steam = 0
	var/tmp/obstructed = FALSE
	var/obj/machinery/geothermal/my_machine
	var/obj/effect/geyser/my_vent

/datum/extension/geothermal_vent/New(datum/holder)
	..()
	START_PROCESSING(SSprocessing, src)
	my_vent = holder

/datum/extension/geothermal_vent/Destroy()
	my_machine = null
	my_vent = null
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/datum/extension/geothermal_vent/proc/set_my_generator(var/obj/machinery/geothermal/G)
	my_machine = G

/datum/extension/geothermal_vent/proc/set_obstructed(var/state)
	obstructed = state
	if(obstructed)
		STOP_PROCESSING(SSprocessing, src)
	else
		START_PROCESSING(SSprocessing, src)

/datum/extension/geothermal_vent/Process()
	if(obstructed && !my_machine) //If we have a machine, don't care about obstruction, or it might cause problems
		return PROCESS_KILL

	if(world.time >= next_steam)
		next_steam = world.time + rand(steam_min, steam_max)
		//If we cached something, make it work
		if(my_machine?.anchored)
			my_machine.add_pressure(rand(pressure_min, pressure_max))
		else
			my_vent.do_spout() //Let the holder decide what to do when spewing steam
