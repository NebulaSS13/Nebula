/* General medicine */
/datum/reagent/tricordrazine
	name = "Tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "grossness"
	color = "#8040ff"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 6

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(3 * removed, 3 * removed)

/datum/reagent/alkysine
	name = "Alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a injury. Can aid in healing brain tissue."
	taste_description = "bitterness"
	color = "#ffff66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 5.9

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.add_chemical_effect(CE_BRAIN_REGEN, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.confused++
		H.drowsyness++

/datum/reagent/chloralhydrate
	name = "chloral hydrate"
	description = "A powerful sedative."
	taste_description = "bitterness"
	color = "#000067"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 2.6

/datum/reagent/chloralhydrate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/threshold = 1
	M.add_chemical_effect(CE_SEDATE, 1)
	if(M.chem_doses[type] <= metabolism * threshold)
		M.confused += 2
		M.drowsyness += 2
	if(M.chem_doses[type] < 2 * threshold)
		M.Weaken(30)
		M.eye_blurry = max(M.eye_blurry, 10)
	else
		M.sleeping = max(M.sleeping, 30)
	if(M.chem_doses[type] > 1 * threshold)
		M.adjustToxLoss(removed)

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	taste_description = "sourness"
	color = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	heating_point = 61 CELSIUS
	heating_products = list(/datum/reagent/potassium, /datum/reagent/acetone, /datum/reagent/nutriment/sugar)
	value = 2

/datum/reagent/cryptobiolin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/drug_strength = 4
	M.make_dizzy(drug_strength)
	M.confused = max(M.confused, drug_strength * 5)
