/datum/artifact_effect/hurt
	name = "hurt"
	origin_type = EFFECT_ORGANIC

/datum/artifact_effect/hurt/DoEffectTouch(var/mob/toucher)
	if(iscarbon(toucher))
		hurt(toucher, rand(5,25), 1)

/datum/artifact_effect/hurt/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effect_range,T))
			hurt(C, 1, msg_prob = 5)

/datum/artifact_effect/hurt/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effect_range, T))
			hurt(C, 3)

/datum/artifact_effect/hurt/proc/hurt(mob/living/carbon/C, amount, strong, msg_prob=100)
	var/weakness = GetAnomalySusceptibility(C)
	if(prob(weakness * 100))
		if(prob(msg_prob))
			to_chat(C, SPAN_DANGER("A wave of painful energy strikes you!"))
		var/force = amount * weakness
		C.apply_damages(force, force, force, force)
		C.adjustBrainLoss(0.1 * weakness)
		if(strong)
			C.apply_radiation(25 * weakness)
			C.set_nutrition(min(50 * weakness, C.nutrition))
			SET_STATUS_MAX(C, STAT_DIZZY, 6 * weakness)
			SET_STATUS_MAX(C, STAT_WEAK, 6 * weakness)