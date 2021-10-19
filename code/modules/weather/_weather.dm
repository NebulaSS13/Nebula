var/global/list/weather_by_z = list()

/obj/weather_system
	name =          ""
	mouse_opacity = 0
	plane =         DEFAULT_PLANE
	layer =         ABOVE_PROJECTILE_LAYER
	icon =          'icons/effects/weather.dmi'
	icon_state =    "blank"
	alpha =          0
	simulated =      FALSE
	density =        FALSE
	opacity =        FALSE
	anchored =       TRUE

	// Wind strength; modifies walk speed on turfs experiencing this 
	// weather. Updated by /decl/weather in current_weather var.
	var/tmp/wind_direction =    0
	var/tmp/wind_strength =     1
	var/const/base_wind_delay = 1

	var/list/affecting_zs
	var/decl/weather/current_weather

/obj/weather_system/proc/get_movement_delay(var/travel_dir)

	// It's quiet. Too quiet.
	if(!wind_direction || !base_wind_delay || !travel_dir)
		return 0

	// May the wind be always at your back!
	var/current_wind_strength = round(wind_strength * base_wind_delay)
	if(wind_direction == travel_dir)
		return -(current_wind_strength)
	if(travel_dir & wind_direction)
		return -(round(current_wind_strength * 0.5))

	// Never spit into the wind.
	var/reversed_wind = global.reverse_dir[wind_direction]
	if(wind_direction == reversed_wind)
		return current_wind_strength
	if(travel_dir & reversed_wind)
		return round(current_wind_strength * 0.5)

	return 0

/obj/weather_system/proc/tick()
	return

/obj/weather_system/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/weather_system/proc/adjust_temperature(initial_temperature)
	return initial_temperature

INITIALIZE_IMMEDIATE(/obj/weather_system)
/obj/weather_system/Initialize(var/ml, var/target_z, var/initial_weather)
	. = ..()

	// Bookkeeping/rightclick guards.
	verbs.Cut()
	forceMove(null)
	SSweather.weather_systems += src

	// Initialize our state. TODO: FSM weather?
	if(ispath(initial_weather, /decl/weather))
		set_current_weather(initial_weather)
	else if(ispath(current_weather, /decl/weather))
		set_current_weather(current_weather)
	else
		set_current_weather(/decl/weather/calm)

	// Track our affected z-levels.
	affecting_zs = GetConnectedZlevels(target_z)

	// If we're post-init, init immediately.
	if(SSweather.initialized)
		addtimer(CALLBACK(src, .proc/init_weather), 0)

/obj/weather_system/proc/set_current_weather(var/weather_type)
	if(current_weather && current_weather.type == weather_type)
		return
	current_weather = GET_DECL(weather_type)
	icon =       current_weather.icon
	icon_state = current_weather.icon_state
	alpha =      current_weather.alpha

/obj/weather_system/Destroy()
	SSweather.weather_systems -= src
	for(var/tz in affecting_zs)
		if(global.weather_by_z["[tz]"] == src)
			global.weather_by_z -= "[tz]" 
		for(var/turf/T AS_ANYTHING in block(locate(1, 1, tz), locate(world.maxx, world.maxy, tz)))
			if(T.weather == src)
				remove_vis_contents(T, src)
				T.weather = null
	. = ..()
	
// Start the weather effects from the highest point; they will propagate downwards during update. 
/obj/weather_system/proc/init_weather()
	// Track all z-levels.
	var/highest_z = affecting_zs[1]
	for(var/tz in affecting_zs)
		if(tz > highest_z)
			highest_z = tz
		global.weather_by_z["[tz]"] = src

	// Update turf weather.
	for(var/turf/T AS_ANYTHING in block(locate(1, 1, highest_z), locate(world.maxx, world.maxy, highest_z)))
		T.update_weather(src)
		CHECK_TICK

/obj/weather_system/proc/handle_mob(var/mob/living/M)
	if(istype(M))
		var/turf/T = M.loc
		if(istype(T))
			current_weather.handle_exposure(M, M.get_weather_exposure())

/client/verb/test_weather_system()

	set name = "Test Weather System"
	set category = "Debug"
	set src = usr

	var/turf/T = get_turf(mob)
	if(!T)
		return
	if(T.weather)
		to_chat(mob, "Randomizing weather state for z[T.z].")
		T.weather.set_current_weather(pick(subtypesof(/decl/weather)))
	else
		to_chat(mob, "Creating weather system for z[T.z].")
		new /obj/weather_system(T.z)
	to_chat(mob, "Done.")