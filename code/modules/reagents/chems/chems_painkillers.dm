
/decl/material/liquid/painkillers
	name = "painkillers"
	lore_text = "A highly effective opioid painkiller. Do not mix with alcohol."
	taste_description = "sourness"
	color = "#cb68fc"
	overdose = 30
	scannable = 1
	metabolism = 0.05
	ingest_met = 0.02
	flags = IGNORE_MOB_SIZE
	value = 1.8
	var/pain_power = 80 //magnitide of painkilling effect
	var/effective_dose = 0.5 //how many units it need to process to reach max power

/decl/material/liquid/painkillers/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	var/effectiveness = 1
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose < effective_dose) //some ease-in ease-out for the effect
		effectiveness = dose/effective_dose
	else if(volume < effective_dose)
		effectiveness = volume/effective_dose
	M.add_chemical_effect(CE_PAINKILLER, pain_power * effectiveness)
	if(dose > 0.5 * overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		if(prob(1))
			M.slurring = max(M.slurring, 10)
	if(dose > 0.75 * overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	if(dose > overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		M.slurring = max(M.slurring, 30)
		if(prob(1))
			M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 5)
	var/boozed = isboozed(M)
	if(boozed)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.add_chemical_effect(CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard

/decl/material/liquid/painkillers/affect_overdose(var/mob/living/M, var/alien, var/datum/reagents/holder)
	..()
	M.set_hallucination(120, 30)
	M.adjust_drugged(10, 10)
	M.add_chemical_effect(CE_PAINKILLER, pain_power*0.5) //extra painkilling for extra trouble
	M.add_chemical_effect(CE_BREATHLOSS, 0.6) //Have trouble breathing, need more air
	if(isboozed(M))
		M.add_chemical_effect(CE_BREATHLOSS, 0.2) //Don't drink and OD on opiates folks

/decl/material/liquid/painkillers/proc/isboozed(var/mob/living/carbon/M)
	. = 0
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested)
		var/list/pool = M.reagents.reagent_volumes | ingested.reagent_volumes
		for(var/rtype in pool)
			var/decl/material/liquid/ethanol/booze = GET_DECL(rtype)
			if(!istype(booze) ||LAZYACCESS(M.chem_doses, rtype) < 2) //let them experience false security at first
				continue
			. = 1
			if(booze.strength < 40) //liquor stuff hits harder
				return 2
