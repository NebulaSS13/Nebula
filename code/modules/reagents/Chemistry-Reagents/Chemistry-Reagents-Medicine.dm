/datum/reagent/neuroannealer
	name = "neuroannealer"
	description = "A neuroplasticity-assisting compound that helps to lessen damage to neurological tissue after a injury. Can aid in healing brain tissue."
	taste_description = "bitterness"
	color = "#ffff66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 5.9

/datum/reagent/neuroannealer/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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
