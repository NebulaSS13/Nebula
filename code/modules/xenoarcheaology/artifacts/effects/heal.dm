/datum/artifact_effect/heal
	name = "heal"
	origin_type = EFFECT_ORGANIC

/datum/artifact_effect/heal/DoEffectTouch(var/mob/toucher)
	if(iscarbon(toucher))
		heal(toucher, 25, 1)
		return 1

/datum/artifact_effect/heal/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effect_range,T))
			heal(C, 1, msg_prob = 5)

/datum/artifact_effect/heal/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effect_range,T))
			heal(C, 5)

//todo: check over this properly
/datum/artifact_effect/heal/proc/heal(mob/living/carbon/C, amount, strong, msg_prob = 100)
	var/weakness = GetAnomalySusceptibility(C)
	if(prob(weakness * 100))
		if(prob(msg_prob))
			to_chat(C, "<span class='notice'>A wave of energy invigorates you.</span>")
		var/force = amount * weakness
		C.apply_damages(-force, -force, -force, -force)
		C.adjustBrainLoss(-force)
		if(strong)
			C.apply_radiation(-25 * weakness)
			C.bodytemperature = C.species?.body_temperature || initial(C.bodytemperature)
			C.adjust_nutrition(50 * weakness)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				H.regenerate_blood(5 * weakness)