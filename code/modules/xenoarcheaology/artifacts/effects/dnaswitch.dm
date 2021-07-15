//todo
/datum/artifact_effect/dnaswitch
	name = "dnaswitch"
	origin_type = EFFECT_ORGANIC
	var/severity
	var/static/list/feels = list(
		"You feel a little different.",
		"You feel very strange.",
		"Your stomach churns.",
		"Your skin feels loose.",
		"You feel a stabbing pain in your head.",
		"You feel a tingling sensation in your chest.",
		"Your entire body vibrates."
	)

/datum/artifact_effect/dnaswitch/New()
	..()
	if(operation_type == EFFECT_AURA)
		severity = rand(5,30)
	else
		severity = rand(25,95)

/datum/artifact_effect/dnaswitch/DoEffectTouch(var/mob/toucher)
	if(ishuman(toucher))
		mess_dna(toucher, 100, 75, 100)
		return 1

/datum/artifact_effect/dnaswitch/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(effect_range,T))
			mess_dna(H, 100, 50, 30)
		return 1

/datum/artifact_effect/dnaswitch/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(effect_range, T))
			mess_dna(H, 25, 75, 75)
		return 1

/datum/artifact_effect/dnaswitch/proc/mess_dna(mob/living/carbon/human/H, scramble_prob, UI_scramble_prob, message_prob)
	var/weakness = GetAnomalySusceptibility(H)
	if(prob(weakness * 100))
		if(prob(message_prob))
			to_chat(H, "<span class='alium'>[pick(feels)]</span>")
		if(scramble_prob)
			if(prob(UI_scramble_prob))
				scramble(1, H, weakness * severity)
			else
				scramble(0, H, weakness * severity)