/datum/artifact_effect/emp
	name = "emp"
	origin_type = XA_EFFECT_ELECTRO

/datum/artifact_effect/emp/New()
	..()
	operation_type = XA_EFFECT_PULSE

/datum/artifact_effect/emp/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		empulse(T, effect_range/2, effect_range)
		return 1
