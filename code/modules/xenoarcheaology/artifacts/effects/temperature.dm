#define ANOM_EFFECT_COOLING  -1
#define ANOM_EFFECT_HEATING  1
/datum/artifact_effect/temperature
	name = "temperature manipulation"
	var/target_temp
	var/direction

/datum/artifact_effect/temperature/New()
	..()
	operation_type = pick(EFFECT_TOUCH, EFFECT_AURA)
	origin_type = pick(EFFECT_ORGANIC, EFFECT_SYNTH)
	if(!direction)
		direction = pick(ANOM_EFFECT_COOLING, ANOM_EFFECT_HEATING)
	switch(direction)
		if(ANOM_EFFECT_COOLING)
			target_temp = rand(TCMB, T0C - 30)
		if(ANOM_EFFECT_HEATING)
			target_temp = rand(T0C + 30, T0C + 600)

/datum/artifact_effect/temperature/DoEffectTouch(var/mob/user)
	if(holder)
		var/temp = direction == ANOM_EFFECT_COOLING ? "cold" : "hot"
		to_chat(user, SPAN_WARNING("[holder] feels really [temp] to touch!"))
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			var/temp_change = rand(5,50) * direction
			change_air_temp(env, temp_change)

/datum/artifact_effect/temperature/DoEffectAura()
	if(holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && air_needs_to_be_changed(env))
			change_air_temp(env, direction)

/datum/artifact_effect/temperature/proc/air_needs_to_be_changed(datum/gas_mixture/air)
	switch(direction)
		if(ANOM_EFFECT_COOLING)
			return air.temperature > target_temp
		if(ANOM_EFFECT_HEATING)
			return air.temperature < target_temp
	
/datum/artifact_effect/temperature/proc/change_air_temp(datum/gas_mixture/air, degrees)
	var/new_temp = air.temperature + degrees
	if(direction == ANOM_EFFECT_COOLING)
		new_temp = max(target_temp, new_temp)
	else
		new_temp = min(target_temp, new_temp)
	air.add_thermal_energy(air.get_thermal_energy_change(new_temp))

/datum/artifact_effect/temperature/heat
	name = "heat generation"
	direction = ANOM_EFFECT_HEATING

/datum/artifact_effect/temperature/cold
	name = "air cooling"
	direction = ANOM_EFFECT_COOLING

#undef ANOM_EFFECT_COOLING
#undef ANOM_EFFECT_HEATING