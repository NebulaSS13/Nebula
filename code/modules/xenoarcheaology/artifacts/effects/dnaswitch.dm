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
		for(var/mob/living/human/H in range(effect_range,T))
			mess_dna(H, 100, 50, 30)
		return 1

/datum/artifact_effect/dnaswitch/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/human/H in range(effect_range, T))
			mess_dna(H, 25, 75, 75)
		return 1

// Swapped to radiation pending readding of mutations.
/datum/artifact_effect/dnaswitch/proc/mess_dna(mob/living/human/H, scramble_prob, UI_scramble_prob, message_prob)
	var/weakness = GetAnomalySusceptibility(H)
	if(prob(weakness * 100) && H.has_genetic_information())
		if(prob(message_prob))
			to_chat(H, "<span class='alium'>[pick(feels)]</span>")
		if(prob(scramble_prob) )
			if(prob(UI_scramble_prob))
				H.set_unique_enzymes(num2text(random_id(/mob, 1000000, 9999999)))
			var/gene_scramble_prob = weakness * severity
			if(prob(gene_scramble_prob))
				H.randomize_gender()
			if(prob(gene_scramble_prob))
				H.randomize_skin_tone()
			if(prob(gene_scramble_prob))
				H.randomize_skin_color()
			if(prob(gene_scramble_prob))
				H.randomize_eye_color()
			if(prob(gene_scramble_prob))
				var/decl/genetic_condition/condition = pick(decls_repository.get_decls_of_type_unassociated(/decl/genetic_condition))
				H.add_genetic_condition(condition.type)
