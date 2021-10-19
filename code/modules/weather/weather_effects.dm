/obj/abstract/weather_system/proc/handle_mob(var/mob/living/M, var/exposure)
	if(istype(M))
		if(M.client)
			if(!(weakref(M) in mob_shown_weather))
				show_weather(M)
			else if(!(weakref(M) in mob_shown_wind))
				show_wind(M)
		var/decl/state/weather/current_weather = weather_system?.current_state
		if(istype(current_weather))
			current_weather.handle_exposure(M, exposure, src)

/obj/abstract/weather_system/proc/get_movement_delay(var/travel_dir)

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

/obj/abstract/weather_system/proc/adjust_temperature(initial_temperature)
	return initial_temperature

/obj/abstract/weather_system/proc/show_weather(var/mob/M)
	var/decl/state/weather/current_weather = weather_system?.current_state
	if(istype(current_weather))
		mob_shown_weather[weakref(M)] = TRUE
		current_weather.show_to(M, src)

/obj/abstract/weather_system/proc/show_wind(var/mob/M)
	mob_shown_wind[weakref(M)] = TRUE
	var/absolute_strength = abs(wind_strength)
	if(absolute_strength <= 0.5)
		to_chat(M, SPAN_NOTICE("The wind is calm."))
	else
		to_chat(M, SPAN_NOTICE("The wind is blowing[absolute_strength > 2 ? " strongly" : ""] towards the [dir2text(wind_direction)]."))

/obj/abstract/weather_system/proc/lightning_strike()
	set waitfor = FALSE
	animate(lightning_overlay, alpha = 255, time = 3)
	sleep(3)
	animate(lightning_overlay, alpha = 0, time = 15)
