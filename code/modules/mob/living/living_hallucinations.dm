/mob/living
	var/hallucination_power = 0
	var/hallucination_duration = 0
	var/next_hallucination
	var/list/_hallucinations

/mob/living/proc/adjust_hallucination(duration, power)
	hallucination_duration = max(0, hallucination_duration + duration)
	hallucination_power = max(0, hallucination_power + power)

/mob/living/proc/set_hallucination(duration, power)
	hallucination_duration = max(hallucination_duration, duration)
	hallucination_power = max(hallucination_power, power)

/mob/living/proc/handle_hallucinations()
	//Tick down the duration
	hallucination_duration = max(0, hallucination_duration - 1)
	//Adjust power if we have some chems that affect it
	if(has_chemical_effect(CE_MIND, threshold_under = -1))
		hallucination_power = hallucination_power++
	else if(has_chemical_effect(CE_MIND, threshold_under = 0))
		hallucination_power = min(hallucination_power++, 50)
	else if(has_chemical_effect(CE_MIND, 1))
		hallucination_duration = max(0, hallucination_duration - 1)
		hallucination_power = max(hallucination_power - GET_CHEMICAL_EFFECT(src, CE_MIND), 0)

	//See if hallucination is gone
	if(!hallucination_power)
		hallucination_duration = 0
		return
	if(!hallucination_duration)
		hallucination_power = 0
		return

	if(!client || stat || world.time < next_hallucination)
		return
	if(has_chemical_effect(CE_MIND, 1) && prob(GET_CHEMICAL_EFFECT(src, CE_MIND)*40)) //antipsychotics help
		return
	var/hall_delay = rand(10,20) SECONDS

	if(hallucination_power < 50)
		hall_delay *= 2
	next_hallucination = world.time + hall_delay
	var/list/candidates = list()
	for(var/T in subtypesof(/datum/hallucination))
		var/datum/hallucination/H = new T
		if(H.can_affect(src))
			candidates += H
	if(candidates.len)
		var/datum/hallucination/H = pick(candidates)
		H.holder = src
		H.activate_hallucination()
