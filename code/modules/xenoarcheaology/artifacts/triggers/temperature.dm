/datum/artifact_trigger/temperature
	name = "specific temperature range"
	toggle = FALSE
	var/min_temp
	var/max_temp

/datum/artifact_trigger/temperature/New()
	if(isnull(min_temp) && isnull(max_temp))
		min_temp = rand(T0C - 100, T0C + 200)
		max_temp = min_temp + rand(10, 30)

	if (max_temp <= T0C)
		name = "low temperature"
	else if (min_temp >= T20C)
		name = "high temperature"
	else
		name = "room temperature"
	if(min_temp > -INFINITY && max_temp < INFINITY)
		name += " (specific range)"

/datum/artifact_trigger/temperature/copy()
	var/datum/artifact_trigger/temperature/C = ..()
	C.min_temp = min_temp
	C.max_temp = max_temp

/datum/artifact_trigger/temperature/on_gas_exposure(datum/gas_mixture/gas)
	return gas.temperature >= min_temp && gas.temperature <= max_temp

/datum/artifact_trigger/temperature/on_hit(obj/O, mob/user)
	. = O.get_heat() >= min_temp && O.get_heat() <= max_temp
	if(max_temp > T20C) 
		. = . || O.isflamesource()

/datum/artifact_trigger/temperature/on_explosion(severity)
	if(max_temp > T20C)
		return TRUE

/datum/artifact_trigger/temperature/cold/New()
	min_temp = -INFINITY
	max_temp = rand(T0C - 100, T0C)

/datum/artifact_trigger/temperature/heat/New()
	min_temp = rand(T0C + 20, T0C + 300)
	max_temp = INFINITY
