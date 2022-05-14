/datum/extension/geothermal_vent
	base_type = /datum/extension/geothermal_vent
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE
	var/pressure_min = 1000
	var/pressure_max = 2000
	var/steam_min = 30 SECONDS
	var/steam_max = 1 MINUTE
	var/tmp/next_steam = 0
	var/datum/effect/effect/system/steam_spread/steam

/datum/extension/geothermal_vent/New()
	..()
	START_PROCESSING(SSprocessing, src)

/datum/extension/geothermal_vent/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)
	
/datum/extension/geothermal_vent/Process()
	..()
	if(world.time >= next_steam)
		next_steam = world.time + rand(steam_min, steam_max)
		var/turf/T = get_turf(holder)
		if(!istype(T))
			return
		var/obj/machinery/geothermal/geothermal = locate() in T
		if(geothermal?.anchored)
			geothermal.add_pressure(rand(pressure_min, pressure_max))
			return
		if(!steam)
			steam = new
			steam.set_up(5, 0, holder)
		steam.start()
