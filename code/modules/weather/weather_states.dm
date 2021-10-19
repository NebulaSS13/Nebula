/decl/weather
	abstract_type = /decl/weather
	var/name =       "Undefined"
	var/descriptor = "<span class='notice'>The weather is calm.</span>"
	var/icon =       'icons/effects/weather.dmi'
	var/icon_state = "blank"
	var/alpha =      180
	var/list/mobs_on_cooldown = list()

/decl/weather/proc/clear_cooldown(var/mobref)
	mobs_on_cooldown -= mobref

/decl/weather/proc/set_cooldown(var/mob/living/M)
	var/mobref = weakref(M)
	if(!(mobref in mobs_on_cooldown))
		mobs_on_cooldown[mobref] = TRUE
		addtimer(CALLBACK(src, .proc/clear_cooldown, mobref), 10 SECONDS)
		return TRUE
	return FALSE

/decl/weather/proc/handle_roof_effects(var/mob/living/M, var/turf/roof)
	return

/decl/weather/proc/handle_protected_effects(var/mob/living/M)
	to_chat(M, SPAN_NOTICE("The sky is empty and clear."))

/decl/weather/proc/handle_exposure_effects(var/mob/living/M)
	handle_protected_effects(M)

/decl/weather/proc/handle_exposure(var/mob/living/M, var/exposure)
	if(exposure != WEATHER_IGNORE && set_cooldown(M))
		if(exposure == WEATHER_ROOFED)
			handle_roofed_effects(M)
		else if(exposure == WEATHER_PROTECTED)
			handle_cosmetic_effects(M)
		else
			handle_exposure_effects(M)

/decl/weather/calm
	name = "Calm"
	descriptor = "<span class='notice'>The weather is calm.</span>"

/decl/weather/snow
	name = "Light Snow"
	icon_state = "snowfall_light"
	descriptor = "<span class='notice'>It is snowing gently.</span>"

/decl/weather/snow/handle_protected_effects(var/mob/living/M)
	to_chat(M, "You get snowed on a bit.")

/decl/weather/snow/medium
	name =  "Snow"
	icon_state = "snowfall_med"
	descriptor = "It is snowing."

/decl/weather/snow/medium/handle_protected_effects(var/mob/living/M)
	to_chat(M, "You get snowed on a lot.")

/decl/weather/snow/heavy
	name =  "Heavy Snow"
	icon_state = "snowfall_heavy"
	descriptor = "<span class='warning'>It is snowing heavily.</span>"

/decl/weather/snow/heavy/handle_protected_effects(var/mob/living/M)
	to_chat(M, "You get snowed on a ton!")

/decl/weather/rain
	name =  "Light Rain"
	icon_state = "rain"
	descriptor = "<span class='notice'>It is raining gently.</span>"

/decl/weather/rain/handle_protected_effects(var/mob/living/M)
	to_chat(M, "You get rained on.")

/decl/weather/rain/storm
	name =  "Heavy Rain"
	icon_state = "storm"
	descriptor = "<span class='warning'>It is raining heavily.</span>"

/decl/weather/rain/storm/handle_protected_effects(var/mob/living/M)
	to_chat(M, "You get stormed on!")

/decl/weather/hail
	name =  "Hail"
	icon_state = "hail"
	descriptor = "<span class='danger'>It is hailing.</span>"

/decl/weather/hail/handle_protected_effects(var/mob/living/M)
	to_chat(M, SPAN_WARNING("Hail patters around you."))

/decl/weather/hail/handle_exposure_effects(var/mob/living/M)
	to_chat(M, SPAN_DANGER("You are pelted by hail!"))
	M.adjustBruteLoss(rand(1,3))

/decl/weather/ash
	name =  "Ash"
	icon_state = "ashfall_light"
	descriptor = "<span class='warning'>A rain of ash falls from the sky.</span>"

/decl/weather/ash/handle_protected_effects(var/mob/living/M)
	to_chat(M, "Drifts of ash fall from the sky.")
