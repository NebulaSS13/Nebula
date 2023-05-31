SUBSYSTEM_DEF(weather)
	name =       "Weather"
	wait =       15 SECONDS
	init_order = SS_INIT_WEATHER
	priority =   SS_PRIORITY_WEATHER
	flags =      SS_BACKGROUND

	var/list/weather_systems    = list()
	var/list/weather_by_z       = list()
	var/list/processing_systems

/datum/controller/subsystem/weather/stat_entry()
	..("all systems: [length(weather_systems)], processing systems: [length(processing_systems)]")

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	. = ..()
	for(var/obj/abstract/weather_system/weather as anything in weather_systems)
		weather.init_weather()

/datum/controller/subsystem/weather/fire(resumed)

	if(!resumed)
		processing_systems = weather_systems.Copy()

	var/obj/abstract/weather_system/weather
	while(processing_systems.len)
		weather = processing_systems[processing_systems.len]
		processing_systems.len--
		weather.tick()
		if(MC_TICK_CHECK)
			return

///Sets a weather state to use for a given z level/z level stack. topmost_level may be a level_id or a level_data instance.
/datum/controller/subsystem/weather/proc/setup_weather_system(var/datum/level_data/topmost_level, var/decl/state/weather/initial_state)
	if(istext(topmost_level))
		topmost_level = SSmapping.levels_by_id[topmost_level]

	//First check and clear any existing weather system on the level
	var/obj/abstract/weather_system/WS = weather_by_z[topmost_level.level_z]
	if(WS)
		unregister_weather_system(WS)
		qdel(WS)
	//Create the new weather system and let it register itself
	new /obj/abstract/weather_system(locate(1, 1, topmost_level.level_z), topmost_level.level_z, initial_state)

///Registers a given weather system obj for getting updates by SSweather.
/datum/controller/subsystem/weather/proc/register_weather_system(var/obj/abstract/weather_system/WS)
	if(weather_by_z[WS.z])
		CRASH("Trying to register another weather system on the same z-level([WS.z]) as an existing one!")
	LAZYDISTINCTADD(weather_systems, WS)

	//Mark all affected z-levels
	var/list/affected = SSmapping.get_connected_levels(WS.z)
	for(var/Z in affected)
		if(weather_by_z[Z])
			CRASH("Trying to register another weather system on the same z-level([Z]) as an existing one!")
		weather_by_z[Z] = WS

///Remove a weather systeam from the processing lists.
/datum/controller/subsystem/weather/proc/unregister_weather_system(var/obj/abstract/weather_system/WS)
	//Clear any and all references to our weather object
	for(var/Z = 1 to length(weather_by_z))
		if(weather_by_z[Z] == WS)
			weather_by_z[Z] = null
	LAZYREMOVE(weather_systems, WS)

///Returns the weather obj for a given z-level if it exists
/datum/controller/subsystem/weather/proc/get_weather_for_level(var/z_level)
	if(z_level > length(weather_by_z))
		return null
	return weather_by_z[z_level]