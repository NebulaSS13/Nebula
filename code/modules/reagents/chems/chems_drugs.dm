
/datum/reagent/amphetamines
	name = "amphetamines"
	description = "A powerful, long-lasting stimulant." 
	taste_description = "acid"
	color = "#ff3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 3.9

/datum/reagent/amphetamines/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 3)

/datum/reagent/narcotics
	name = "narcotics"
	description = "A narcotic that impedes mental ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	value = 1.8

/datum/reagent/narcotics/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.jitteriness = max(M.jitteriness - 5, 0)
	if(prob(80))
		M.adjustBrainLoss(5.25 * removed)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(10))
		M.emote("drool")

/datum/reagent/nicotine
	name = "nicotine"
	description = "A sickly yellow liquid sourced from tobacco leaves. Stimulates and relaxes the mind and body."
	taste_description = "peppery bitterness"
	color = "#efebaa"
	metabolism = REM * 0.002
	overdose = 6
	scannable = 1
	data = 0
	value = 2

/datum/reagent/nicotine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(volume*20))
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume <= 0.02 && M.chem_doses[type] >= 0.05 && world.time > data + 3 MINUTES)
		data = world.time
		to_chat(M, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else
		if(world.time > data + 3 MINUTES)
			data = world.time
			to_chat(M, "<span class='notice'>You feel invigorated and calm.</span>")

/datum/reagent/nicotine/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/sedatives
	name = "sedatives"
	description = "A mild sedative used to calm patients and induce sleep."
	taste_description = "bitterness"
	color = "#009ca8"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 2.5

/datum/reagent/sedatives/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.make_jittery(-50)
	var/threshold = 1
	if(M.chem_doses[type] < 0.5 * threshold)
		if(M.chem_doses[type] == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(M.chem_doses[type] < 1 * threshold)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(M.chem_doses[type] < 2 * threshold)
		if(prob(50))
			M.Weaken(2)
			M.add_chemical_effect(CE_SEDATE, 1)
		M.drowsyness = max(M.drowsyness, 20)
	else
		M.sleeping = max(M.sleeping, 20)
		M.drowsyness = max(M.drowsyness, 60)
		M.add_chemical_effect(CE_SEDATE, 1)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/psychoactives
	name = "psychoactives"
	description = "An illegal chemical compound used as a psychoactive drug."
	taste_description = "bitterness"
	taste_mult = 0.4
	color = "#60a584"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 2.8

/datum/reagent/psychoactives/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/drug_strength = 15
	M.druggy = max(M.druggy, drug_strength)
	if(prob(10))
		M.SelfMove(pick(GLOB.cardinal))
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/hallucinogenics
	name = "hallucinogenics"
	description = "A mix of powerful hallucinogens, they can cause fatal effects in users."
	taste_description = "sourness"
	color = "#b31008"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	value = 0.6

/datum/reagent/hallucinogenics/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_MIND, -2)
	M.hallucination(50, 50)

/datum/reagent/psychotropics
	name = "psychotropics"
	description = "A strong psychotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#e700e7"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	value = 0.7

/datum/reagent/psychotropics/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/threshold = 1
	M.druggy = max(M.druggy, 30)

	if(M.chem_doses[type] < 1 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else if(M.chem_doses[type] < 2 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		if(prob(10))
			M.emote(pick("twitch", "giggle"))
	else
		M.add_chemical_effect(CE_MIND, -1)
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))