/datum/artifact_effect/stun
	name = "stun"

/datum/artifact_effect/stun/New()
	..()
	origin_type = pick(EFFECT_PSIONIC, EFFECT_ORGANIC)

/datum/artifact_effect/stun/DoEffectTouch(var/mob/toucher)
	if(iscarbon(toucher))
		var/mob/living/carbon/C = toucher
		var/susceptibility = GetAnomalySusceptibility(C)
		if(prob(susceptibility * 100))
			to_chat(C, "<span class='warning'>A powerful force overwhelms your consciousness.</span>")
			SET_STATUS_MAX(C, STAT_WEAK, rand(1,10) * susceptibility)
			SET_STATUS_MAX(C, STAT_STUTTER, 10 * susceptibility)

/datum/artifact_effect/stun/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effect_range,T))
			var/susceptibility = GetAnomalySusceptibility(C)
			if(prob(10 * susceptibility))
				to_chat(C, "<span class='warning'>Your body goes numb for a moment.</span>")
				SET_STATUS_MAX(C, STAT_WEAK, 2)
				SET_STATUS_MAX(C, STAT_STUTTER, 2)
			else if(prob(10))
				to_chat(C, "<span class='warning'>You feel numb.</span>")

/datum/artifact_effect/stun/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effect_range,T))
			var/susceptibility = GetAnomalySusceptibility(C)
			if(prob(100 * susceptibility))
				to_chat(C, "<span class='warning'>A wave of energy overwhelms your senses!</span>")
				SET_STATUS_MAX(C, STAT_WEAK, 4 * susceptibility)
				SET_STATUS_MAX(C, STAT_STUTTER, 4 * susceptibility)
