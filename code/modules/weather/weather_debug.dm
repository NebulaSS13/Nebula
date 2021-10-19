/client/verb/test_weather_system()

	set name = "Test Weather System"
	set category = "Debug"
	set src = usr

	var/turf/T = get_turf(mob)
	if(!T)
		return
	var/obj/abstract/weather_system/weather = T.weather || global.weather_by_z["[T.z]"]
	if(weather)
		to_chat(mob, "Forcing weather state change for z[T.z].")
		weather.next_weather_transition = 0
		weather.tick()
	else
		to_chat(mob, "Creating weather system for z[T.z].")
		new /obj/abstract/weather_system(null, T.z)
	to_chat(mob, "Done.")

/client/verb/test_weather_lightning()
	set name = "Test Weather System"
	set category = "Debug"
	set src = usr

	var/turf/T = get_turf(mob)
	if(!T)
		return
	to_chat(mob, "Testing lightning strike.")
	var/obj/abstract/weather_system/weather = T.weather || global.weather_by_z["[T.z]"]
	if(!weather)
		weather = new /obj/abstract/weather_system(null, T.z)
	weather.lightning_strike()
	to_chat(mob, "Done.")
