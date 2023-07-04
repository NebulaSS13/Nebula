
/decl/material/liquid/amphetamines
	name = "amphetamines"
	lore_text = "A powerful, long-lasting stimulant."
	taste_description = "acid"
	color = "#ff3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 2
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_amphetamines"

/decl/material/liquid/amphetamines/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 3)

/decl/material/liquid/narcotics
	name = "narcotics"
	lore_text = "A narcotic that impedes mental ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	value = 2
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_narcotics"

/decl/material/liquid/narcotics/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	ADJ_STATUS(M, STAT_JITTER, -5)
	if(prob(80))
		M.adjustBrainLoss(5.25 * removed)
	if(prob(50))
		SET_STATUS_MAX(M, STAT_DROWSY, 3)
	if(prob(10))
		M.emote("drool")

/decl/material/liquid/nicotine
	name = "nicotine"
	lore_text = "A sickly yellow liquid sourced from tobacco leaves. Stimulates and relaxes the mind and body."
	taste_description = "peppery bitterness"
	color = "#efebaa"
	metabolism = REM * 0.002
	overdose = 6
	scannable = 1
	value = 2
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_nicotine"

/decl/material/liquid/nicotine/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(prob(volume*20))
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume <= 0.02 && LAZYACCESS(M.chem_doses, type) >= 0.05 && world.time > REAGENT_DATA(holder, type) + 3 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else if(world.time > REAGENT_DATA(holder, type) + 3 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, "<span class='notice'>You feel invigorated and calm.</span>")

/decl/material/liquid/nicotine/affect_overdose(var/mob/living/M)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/decl/material/liquid/sedatives
	name = "sedatives"
	lore_text = "A mild sedative used to calm patients and induce sleep."
	taste_description = "bitterness"
	color = "#009ca8"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 2
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_sedatives"

/decl/material/liquid/sedatives/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	ADJ_STATUS(M, STAT_JITTER, -50)
	var/threshold = 1
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose < 0.5 * threshold)
		if(dose == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(dose < 1 * threshold)
		SET_STATUS_MAX(M, STAT_BLURRY, 10)
	else if(dose < 2 * threshold)
		if(prob(50))
			SET_STATUS_MAX(M, STAT_WEAK, 2)
			M.add_chemical_effect(CE_SEDATE, 1)
		SET_STATUS_MAX(M, STAT_DROWSY, 20)
	else
		SET_STATUS_MAX(M, STAT_ASLEEP, 20)
		SET_STATUS_MAX(M, STAT_DROWSY, 60)
		M.add_chemical_effect(CE_SEDATE, 1)
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/liquid/psychoactives
	name = "psychoactives"
	lore_text = "An illegal chemical compound used as a psychoactive drug."
	taste_description = "bitterness"
	taste_mult = 0.4
	color = "#60a584"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 2
	narcosis = 7
	fruit_descriptor = "rich"
	euphoriant = 15
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_psychoactives"

/decl/material/liquid/psychoactives/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	SET_STATUS_MAX(M, STAT_DRUGGY, 15)
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/liquid/hallucinogenics
	name = "hallucinogenics"
	lore_text = "A mix of powerful hallucinogens, they can cause fatal effects in users."
	taste_description = "sourness"
	color = "#b31008"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	value = 2
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_hallucinogenics"

/decl/material/liquid/hallucinogenics/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_MIND, -2)
	M.set_hallucination(50, 50)

/decl/material/liquid/psychotropics
	name = "psychotropics"
	lore_text = "A strong psychotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#e700e7"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	value = 2
	euphoriant = 30
	fruit_descriptor = "hallucinogenic"
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_psychotropics"

/decl/material/liquid/psychotropics/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/threshold = 1
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose < 1 * threshold)
		M.apply_effect(3, STUTTER)
		ADJ_STATUS(M, STAT_DIZZY, 1)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else if(dose < 2 * threshold)
		M.apply_effect(3, STUTTER)
		ADJ_STATUS(M, STAT_JITTER,  2)
		ADJ_STATUS(M, STAT_DIZZY,   2)
		SET_STATUS_MAX(M, STAT_DRUGGY, 35)

		if(prob(10))
			M.emote(pick("twitch", "giggle"))
	else
		M.add_chemical_effect(CE_MIND, -1)
		M.apply_effect(3, STUTTER)
		ADJ_STATUS(M, STAT_JITTER, 5)
		ADJ_STATUS(M, STAT_DIZZY,  5)
		SET_STATUS_MAX(M, STAT_DRUGGY, 40)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))

// Welcome back, Three Eye
/decl/material/liquid/glowsap/gleam
	name = "Gleam"
	lore_text = "A powerful hallucinogenic and psychotropic derived from various species of glowing mushroom. Some say it can have permanent effects on the brains of those who over-indulge."
	color = "#ccccff"
	metabolism = REM
	overdose = 25
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_gleam"

	// M A X I M U M C H E E S E
	var/static/list/dose_messages = list(
		"Your name is called. It is your time.",
		"You are dissolving. Your hands are wax...",
		"It all runs together. It all mixes.",
		"It is done. It is over. You are done. You are over.",
		"You won't forget. Don't forget. Don't forget.",
		"Light seeps across the edges of your vision...",
		"Something slides and twitches within your sinus cavity...",
		"Your bowels roil. It waits within.",
		"Your gut churns. You are heavy with potential.",
		"Your heart flutters. It is winged and caged in your chest.",
		"There is a precious thing, behind your eyes.",
		"Everything is ending. Everything is beginning.",
		"Nothing ends. Nothing begins.",
		"Wake up. Please wake up.",
		"Stop it! You're hurting them!",
		"It's too soon for this. Please go back.",
		"We miss you. Where are you?",
		"Come back from there. Please."
	)

	var/static/list/overdose_messages = list(
		"THE SIGNAL THE SIGNAL THE SIGNAL THE SIGNAL",
		"IT CRIES IT CRIES IT WAITS IT CRIES",
		"NOT YOURS NOT YOURS NOT YOURS NOT YOURS",
		"THAT IS NOT FOR YOU",
		"IT RUNS IT RUNS IT RUNS IT RUNS",
		"THE BLOOD THE BLOOD THE BLOOD THE BLOOD",
		"THE LIGHT THE DARK A STAR IN CHAINS"
	)

/decl/material/liquid/glowsap/gleam/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	M.add_client_color(/datum/client_color/noir/thirdeye)
	M.add_chemical_effect(CE_THIRDEYE, 1)
	M.add_chemical_effect(CE_MIND, -2)
	M.set_hallucination(50, 50)
	ADJ_STATUS(M, STAT_JITTER, 3)
	ADJ_STATUS(M, STAT_DIZZY,  3)
	if(prob(0.1) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.seizure()
		H.adjustBrainLoss(rand(8, 12))
	if(prob(5))
		to_chat(M, SPAN_WARNING("<font size = [rand(1,3)]>[pick(dose_messages)]</font>"))

/decl/material/liquid/glowsap/gleam/on_leaving_metabolism(datum/reagents/metabolism/holder)
	. = ..()
	var/mob/M = holder?.my_atom
	if(istype(M))
		M.remove_client_color(/datum/client_color/noir/thirdeye)

/decl/material/liquid/glowsap/gleam/affect_overdose(var/mob/living/M)
	M.adjustBrainLoss(rand(1, 5))
	if(ishuman(M) && prob(10))
		var/mob/living/carbon/human/H = M
		H.seizure()
	if(prob(10))
		to_chat(M, SPAN_DANGER("<font size = [rand(2,4)]>[pick(overdose_messages)]</font>"))
