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
	var/pain_power = 80 //magnitude of painkilling effect
	var/effective_dose = 0.5 //how many units it need to process to reach max power
	var/additional_effect_threshold = 15 // cumulative dosage at which slowdown and drowsiness are applied
	var/sedation = 0 //how strong is this chemical as a sedative
	var/breathloss_severity = 0.5 //how strong will breathloss related effects be
	var/slowdown_severity = 1
	var/blurred_vision = 0.5
	var/stuttering_severity = 0
	var/slur_severity = 1
	var/confusion_severity = 0.5 //confusion randomizes your movement
	var/weakness_severity = 0.5 //weakness makes you remain floored
	var/dizziness_severity = 1
	var/narcotic = TRUE

/decl/material/liquid/painkillers/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	var/effectiveness = 1
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose < effective_dose) //some ease-in ease-out for the effect
		effectiveness = dose/effective_dose
	else if(volume < effective_dose)
		effectiveness = volume/effective_dose

	M.add_chemical_effect(CE_PAINKILLER, (pain_power * effectiveness))

	if(!narcotic)
		return
	if(dose > 0.5 * additional_effect_threshold)
		M.add_chemical_effect(CE_SLOWDOWN, slowdown_severity)
		if(prob(15) && slur_severity)
			SET_STATUS_MAX(M, STAT_SLUR, (slur_severity * 10))

	if(dose > 0.75 * additional_effect_threshold) //minor side effects may start here
		M.add_chemical_effect(CE_SLOWDOWN, slowdown_severity)
		if(prob(30) && slur_severity)
			SET_STATUS_MAX(M, STAT_SLUR, (slur_severity * 20))
		if(prob(30) && dizziness_severity)
			SET_STATUS_MAX(M, STAT_DIZZY, (dizziness_severity * 20))
		if(prob(30) && confusion_severity)
			SET_STATUS_MAX(M, STAT_CONFUSE, (confusion_severity * 20))
		if(prob(75) && blurred_vision)
			SET_STATUS_MAX(M, STAT_BLURRY, (blurred_vision * 20))
		if(prob(30) && stuttering_severity)
			SET_STATUS_MAX(M, STAT_STUTTER, (stuttering_severity * 20))
		if(prob(30) && weakness_severity)
			SET_STATUS_MAX(M, STAT_WEAK, (weakness_severity * 10))
		if(sedation > 0)
			if(prob(20))
				M.add_chemical_effect(CE_SEDATE, (sedation * 1))
				SET_STATUS_MAX(M, STAT_DROWSY, (sedation * 10))
			else
				SET_STATUS_MAX(M, STAT_DROWSY, (sedation * 20))

	if(dose > additional_effect_threshold) //not quite an overdose yet, but it's a lot of medicine to take at once.
		M.add_chemical_effect(CE_SLOWDOWN, (slowdown_severity * 2))
		SET_STATUS_MAX(M, STAT_BLURRY, (blurred_vision * 40))
		if(prob(75) && slur_severity)
			SET_STATUS_MAX(M, STAT_SLUR, (slur_severity * 40))
		if(prob(75) && dizziness_severity)
			SET_STATUS_MAX(M, STAT_DIZZY, (dizziness_severity * 40))
		if(prob(75) && confusion_severity)
			SET_STATUS_MAX(M, STAT_CONFUSE, (confusion_severity * 40))
		if(prob(75) && stuttering_severity)
			SET_STATUS_MAX(M, STAT_STUTTER, (stuttering_severity * 40))
		if(prob(75) && weakness_severity)
			SET_STATUS_MAX(M, STAT_WEAK, (weakness_severity * 20))
		if(sedation > 0)
			if(prob(50)) //fall asleep
				M.add_chemical_effect(CE_SEDATE, (sedation * 1))
				SET_STATUS_MAX(M, STAT_ASLEEP, (sedation * 20)) //is CE_SEDATE and STAT_DROWSY redundant with STAT_ASLEEP? reminder for further testing
				SET_STATUS_MAX(M, STAT_DROWSY, (sedation * 40))
			else //stay awake, but immobilized.
				SET_STATUS_MAX(M, STAT_WEAK, (weakness_severity * 40))
				SET_STATUS_MAX(M, STAT_DROWSY, (sedation * 40))

	var/boozed = isboozed(M)
	if(boozed)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.add_chemical_effect(CE_BREATHLOSS, 1 * boozed) //drinking and opiating suppreesses breathing.

/decl/material/liquid/painkillers/affect_overdose(var/mob/living/M, var/alien, var/datum/reagents/holder)
	..()
	if(!narcotic)
		return
	M.set_hallucination(120, 30)
	SET_STATUS_MAX(M, STAT_DRUGGY, 10)
	M.add_chemical_effect(CE_PAINKILLER, pain_power*0.5) //extra painkilling for extra trouble
	M.add_chemical_effect(CE_BREATHLOSS, breathloss_severity*2) //ODing on opiates can be deadly.
	if(isboozed(M))
		M.add_chemical_effect(CE_BREATHLOSS, breathloss_severity*4) //Don't drink and OD on opiates folks

/decl/material/liquid/painkillers/proc/isboozed(var/mob/living/carbon/M)
	. = 0
	if(!narcotic)
		return
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
