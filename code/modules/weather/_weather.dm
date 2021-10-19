var/global/list/weather_by_z = list()

/obj/abstract/weather_system
	plane =            DEFAULT_PLANE
	layer =            ABOVE_PROJECTILE_LAYER
	icon =             'icons/effects/weather.dmi'
	icon_state =       "blank"
	invisibility =     0
	appearance_flags = (RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)

	// Wind strength; modifies walk speed on turfs experiencing this 
	// weather. Updated by /decl/state/weather in weather_system FSM.
	var/tmp/wind_direction =    0
	var/tmp/wind_strength =     1
	var/const/base_wind_delay = 1

	var/water_material = /decl/material/liquid/water
	var/ice_material =   /decl/material/solid/ice

	var/list/affecting_zs
	var/datum/state_machine/weather/weather_system
	var/next_weather_transition = 0
	var/obj/abstract/lightning_overlay/lightning_overlay

	var/list/mobs_on_cooldown =  list()
	var/list/mob_shown_weather = list()
	var/list/mob_shown_wind =    list()

/obj/abstract/weather_system/proc/show_wind_to(var/mob/living/M)
	return

/obj/abstract/weather_system/proc/clear_cooldown(var/mobref)
	mobs_on_cooldown -= mobref

/obj/abstract/weather_system/proc/set_cooldown(var/mob/living/M, var/delay = 5 SECONDS)
	var/mobref = weakref(M)
	if(!(mobref in mobs_on_cooldown))
		mobs_on_cooldown[mobref] = TRUE
		addtimer(CALLBACK(src, .proc/clear_cooldown, mobref), delay)
		return TRUE
	return FALSE

/obj/abstract/weather_system/proc/tick()

	// Check if we should move to a new state.
	if(world.time >= next_weather_transition)
		weather_system.evaluate()

	// Change wind direction and speed.
	handle_wind()

	// Handle periodic effects for ticks (like lightning)
	var/decl/state/weather/rain/weather_state = weather_system.current_state
	if(istype(weather_state))
		weather_state.tick(src)

/obj/abstract/weather_system/proc/handle_wind()
	if(prob(66))
		return
	if(prob(10))
		wind_direction = turn(wind_direction, pick(45, -45))
		mob_shown_wind.Cut()
	if(prob(10))
		var/old_strength = wind_strength
		wind_strength = Clamp(wind_strength + rand(-1, 1), 5, -5)
		if(old_strength != wind_strength)
			mob_shown_wind.Cut()

/obj/abstract/weather_system/Destroy()
	SSweather.weather_systems -= src
	for(var/tz in affecting_zs)
		if(global.weather_by_z["[tz]"] == src)
			global.weather_by_z -= "[tz]" 
		for(var/turf/T AS_ANYTHING in block(locate(1, 1, tz), locate(world.maxx, world.maxy, tz)))
			if(T.weather == src)
				remove_vis_contents(T, src)
				T.weather = null
	. = ..()

/obj/abstract/weather_system/examine(mob/user, distance)	
	SHOULD_CALL_PARENT(FALSE)
	var/decl/state/weather/weather_state = weather_system.current_state
	if(istype(weather_state))
		to_chat(user, weather_state.descriptor)

/obj/abstract/weather_system/proc/supports_weather_state(var/target)
	// Exoplanet stuff for the future:
	// - TODO: track and check exoplanet temperature.
	// - TODO: compare to a list of 'acceptable' states
	var/decl/state/weather/next_state = GET_DECL(target)
	if(next_state.is_liquid)
		return !!water_material
	if(next_state.is_ice)
		return !!ice_material
	return TRUE

/obj/abstract/lightning_overlay
	layer = ABOVE_LIGHTING_LAYER
	icon = 'icons/effects/weather.dmi'
	icon_state = "full"
	vis_flags = VIS_INHERIT_ID
	alpha = 0
