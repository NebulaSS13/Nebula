/datum/artifact_effect/heal
	name = "heal"
	origin_type = EFFECT_ORGANIC

/datum/artifact_effect/heal/DoEffectTouch(var/mob/toucher)
	if(isliving(toucher))
		heal(toucher, 25, 1)
		return 1

/datum/artifact_effect/heal/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/target in range(src.effect_range,T))
			heal(target, 1, msg_prob = 5)

/datum/artifact_effect/heal/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/target in range(effect_range,T))
			heal(target, 5)

//todo: check over this properly
/datum/artifact_effect/heal/proc/heal(mob/living/M, amount, strong, msg_prob = 100)
	var/weakness = GetAnomalySusceptibility(M)
	if(prob(weakness * 100))
		if(prob(msg_prob))
			to_chat(M, SPAN_NOTICE("A wave of energy invigorates you."))
		var/force = amount * weakness
		M.apply_damages(-force, -force, -force, -force)
		M.heal_damage(BRAIN, force)
		if(strong)
			M.apply_radiation(-25 * weakness)
			M.bodytemperature = M.get_species()?.body_temperature || initial(M.bodytemperature)
			M.adjust_nutrition(50 * weakness)
			if(ishuman(M))
				var/mob/living/human/H = M
				H.regenerate_blood(5 * weakness)
