/decl/state_transition/weather
	abstract_type = /decl/state_transition/weather
	var/likelihood_weighting = 100

/decl/state_transition/weather/is_open(datum/holder)
	var/obj/abstract/weather_system/weather = holder
	return weather.supports_weather_state(target)

/decl/state_transition/weather/calm
	target = /decl/state/weather/calm

/decl/state_transition/weather/cold
	target = /decl/state/weather/cold
	likelihood_weighting = 50

/decl/state_transition/weather/snow
	target = /decl/state/weather/snow
	likelihood_weighting = 30

/decl/state_transition/weather/rain
	target = /decl/state/weather/rain
	likelihood_weighting = 30

/decl/state_transition/weather/snow_medium
	target = /decl/state/weather/snow/medium
	likelihood_weighting = 20

/decl/state_transition/weather/snow_heavy
	target = /decl/state/weather/snow/heavy
	likelihood_weighting = 10

/decl/state_transition/weather/storm
	target = /decl/state/weather/rain/storm
	likelihood_weighting = 20

/decl/state_transition/weather/hail
	target = /decl/state/weather/rain/hail
	likelihood_weighting = 20
