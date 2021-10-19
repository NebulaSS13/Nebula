/decl/weather
	abstract_type = /decl/weather
	var/name =       "Undefined"
	var/descriptor = "<span class='notice'>The weather is calm.</span>"
	var/icon =       'icons/effects/weather.dmi'
	var/icon_state = "blank"
	var/alpha =      180
	var/list/mobs_on_cooldown = list()

/decl/weather/proc/clear_cooldown(var/mob/M)
	if(M)
		mobs_on_cooldown -= weakref(M)

/decl/weather/proc/handle_cosmetic_message(var/mob/M)
	var/mobref = weakref(M)
	if(!(mobref in mobs_on_cooldown))
		to_chat(M, get_cosmetic_message())
		mobs_on_cooldown[mobref] = TRUE
		addtimer(CALLBACK(src, .proc/clear_cooldown, M), 10 SECONDS)

/decl/weather/proc/get_cosmetic_message()
	return SPAN_NOTICE("The sky is empty and clear.")

/decl/weather/proc/handle_exposure(var/mob/M)
	return handle_cosmetic_message(M)

/decl/weather/calm
	name = "Calm"
	descriptor = "<span class='notice'>The weather is calm.</span>"

/decl/weather/snow
	name = "Light Snow"
	icon_state = "snowfall_light"
	descriptor = "<span class='notice'>It is snowing gently.</span>"

/decl/weather/snow/get_cosmetic_message()
	return "You get snowed on a bit."

/decl/weather/snow/medium
	name =  "Snow"
	icon_state = "snowfall_med"
	descriptor = "It is snowing."

/decl/weather/snow/medium/get_cosmetic_message()
	return "You get snowed on a lot."

/decl/weather/snow/heavy
	name =  "Heavy Snow"
	icon_state = "snowfall_heavy"
	descriptor = "<span class='warning'>It is snowing heavily.</span>"

/decl/weather/snow/heavy/get_cosmetic_message()
	return "You get snowed on a ton!"

/decl/weather/rain
	name =  "Light Rain"
	icon_state = "rain"
	descriptor = "<span class='notice'>It is raining gently.</span>"

/decl/weather/rain/get_cosmetic_message()
	return "You get rained on."

/decl/weather/rain/storm
	name =  "Heavy Rain"
	icon_state = "storm"
	descriptor = "<span class='warning'>It is raining heavily.</span>"

/decl/weather/rain/storm/get_cosmetic_message()
	return "You get stormed on!"

/decl/weather/hail
	name =  "Hail"
	icon_state = "hail"
	descriptor = "<span class='danger'>It is hailing.</span>"

/decl/weather/hail/get_cosmetic_message()
	return "Hail patters around you."

/decl/weather/hail/handle_exposure(var/mob/M)
	to_chat(M, SPAN_DANGER("You are pelted by hail!"))
	M.adjustBruteLoss(rand(1,3))

/decl/weather/ash
	name =  "Ash"
	icon_state = "ashfall_light"
	descriptor = "<span class='warning'>A rain of ash falls from the sky.</span>"

/decl/weather/ash/get_cosmetic_message()
	return "Drifts of ash fall from the sky."
