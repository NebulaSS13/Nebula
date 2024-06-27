#define RANDOM_CHEM_EFFECT_TRUE  1 //Boolean, starts true
#define RANDOM_CHEM_EFFECT_INT   2
#define RANDOM_CHEM_EFFECT_FLOAT 3

/decl/random_chem_effect
	var/minimum = 0
	var/maximum = 1
	var/mode = RANDOM_CHEM_EFFECT_TRUE
	var/beneficial = 0 // Neutral; 1 for beneficial, -1 for harmful
	var/desc
	var/cost = 500 // Modify if an effect should be valued more.

/decl/random_chem_effect/proc/get_random_value()
	switch(mode)
		if(RANDOM_CHEM_EFFECT_TRUE)
			return 1
		if(RANDOM_CHEM_EFFECT_INT)
			return rand(minimum, maximum)
		if(RANDOM_CHEM_EFFECT_FLOAT)
			return rand() * (maximum - minimum) + minimum

/decl/random_chem_effect/proc/prototype_process(var/decl/material/liquid/random/reagent, temperature)
	var/value = get_random_value(temperature)
	on_property_recompute(reagent, value)

/decl/random_chem_effect/proc/on_property_recompute(var/decl/material/liquid/random/reagent, var/value)

/decl/random_chem_effect/proc/affect_blood(var/mob/living/M, var/removed, var/value)

// This is referring to monetary value.
/decl/random_chem_effect/proc/get_value(var/value)
	switch(beneficial)
		if(1)
			return cost * (value - minimum)/(maximum - minimum)
		if(0)
			return 0
		if(-1)
			return -3 * cost * (value - minimum)/(maximum - minimum)

// All general properties will be chosen.

/decl/random_chem_effect/general_properties/name
	maximum = 999
	minimum = 100
	mode = RANDOM_CHEM_EFFECT_INT

/decl/random_chem_effect/general_properties/name/on_property_recompute(var/decl/material/liquid/random/reagent, var/value)
	reagent.name = "[initial(reagent.name)]-[value]"

/decl/random_chem_effect/general_properties/color/get_random_value()
	return color_matrix_rotate_hue(round(rand(0,360),20))

/decl/random_chem_effect/general_properties/color/on_property_recompute(var/decl/material/liquid/random/reagent, var/value)
	reagent.color = value

/decl/random_chem_effect/general_properties/overdose
	minimum = REAGENTS_OVERDOSE * 0.2
	maximum = REAGENTS_OVERDOSE * 2
	mode = RANDOM_CHEM_EFFECT_FLOAT

/decl/random_chem_effect/general_properties/overdose/on_property_recompute(var/decl/material/liquid/random/reagent, var/value)
	reagent.overdose = value

/decl/random_chem_effect/general_properties/metabolism
	minimum = REM * 0.5
	maximum = REM * 3
	mode = RANDOM_CHEM_EFFECT_FLOAT

/decl/random_chem_effect/general_properties/metabolism/on_property_recompute(var/decl/material/liquid/random/reagent, var/value)
	reagent.metabolism = value

/decl/random_chem_effect/general_properties/chilling_point
	minimum = TCMB
	var/generic_minimum = T0C - 80 // Will be used unless the temperature we're gunning for is too cold
	maximum = T0C - 10
	mode = RANDOM_CHEM_EFFECT_FLOAT

/decl/random_chem_effect/general_properties/chilling_point/get_random_value(temperature)
	var/max = max(min(maximum, temperature - 20), minimum) // Use given max unless that's above the given temp - margin
	var/min = max(min(generic_minimum, max - 20), minimum) // Use the generic min as min unless that's above the max - margin
	return rand() * (max - min) + min

/decl/random_chem_effect/general_properties/heating_point
	minimum = T0C + 60
	var/generic_maximum = T0C + 180
	maximum = T0C + 500
	mode = RANDOM_CHEM_EFFECT_FLOAT

/decl/random_chem_effect/general_properties/heating_point/get_random_value(temperature)
	var/min = min(max(minimum, temperature + 20), maximum)
	var/max = min(max(generic_maximum, min + 20), maximum)
	return rand() * (max - min) + min

// Only some random properties are picked.

/decl/random_chem_effect/random_properties
	var/chem_effect_define                //If it corresponds to a CE_WHATEVER define, place here and it will do generic affect blood based on it

/decl/random_chem_effect/random_properties/affect_blood(var/mob/living/M, var/removed, var/value)
	if(chem_effect_define)
		M.add_chemical_effect(chem_effect_define, value)

/decl/random_chem_effect/random_properties/on_property_recompute(var/decl/material/liquid/random/reagent, var/value)
	reagent.data[type] = value

/decl/random_chem_effect/random_properties/ce_stable
	chem_effect_define = CE_STABLE
	beneficial = 1
	desc = "stabilization"

/decl/random_chem_effect/random_properties/ce_antibiotic
	chem_effect_define = CE_ANTIBIOTIC
	beneficial = 1
	desc = "antibiotic power"

/decl/random_chem_effect/random_properties/ce_bloodrestore
	chem_effect_define = CE_BLOODRESTORE
	beneficial = 1
	minimum = 1
	maximum = 12
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "blood restoration"

/decl/random_chem_effect/random_properties/ce_painkiller
	chem_effect_define = CE_PAINKILLER
	beneficial = 1
	maximum = 100
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "pain suppression"

/decl/random_chem_effect/random_properties/ce_alcohol
	chem_effect_define = CE_ALCOHOL
	beneficial = -1
	desc = "intoxication"

/decl/random_chem_effect/random_properties/ce_alcotoxic
	chem_effect_define = CE_ALCOHOL_TOXIC
	beneficial = -1
	maximum = 8
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "liver damage"

/decl/random_chem_effect/random_properties/ce_gofast
	chem_effect_define = CE_SPEEDBOOST
	beneficial = 1
	maximum = 2
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "faster movement"

/decl/random_chem_effect/random_properties/ce_goslow
	chem_effect_define = CE_SLOWDOWN
	beneficial = -1
	maximum = 20
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "slower movement"

/decl/random_chem_effect/random_properties/ce_xcardic
	chem_effect_define = CE_PULSE
	beneficial = -1
	minimum = -2
	maximum = 4
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "pulse destabilization"

/decl/random_chem_effect/random_properties/ce_heartstop
	chem_effect_define = CE_NOPULSE
	beneficial = -1
	desc = "cardiac arrest"

/decl/random_chem_effect/random_properties/ce_antitox
	chem_effect_define = CE_ANTITOX
	beneficial = 1
	desc = "poison removal"

/decl/random_chem_effect/random_properties/ce_oxygen
	chem_effect_define = CE_OXYGENATED
	beneficial = 1
	maximum = 2
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "blood oxygenation"

/decl/random_chem_effect/random_properties/ce_brainfix
	chem_effect_define = CE_BRAIN_REGEN
	beneficial = 1
	desc = "neurological repair"

/decl/random_chem_effect/random_properties/ce_toxins
	chem_effect_define = CE_TOXIN
	beneficial = -1
	desc = "general toxicity"

/decl/random_chem_effect/random_properties/ce_breathloss
	chem_effect_define = CE_BREATHLOSS
	beneficial = -1
	maximum = 0.6
	mode = RANDOM_CHEM_EFFECT_FLOAT
	desc = "respiratory depression"

/decl/random_chem_effect/random_properties/ce_mindbending
	chem_effect_define = CE_MIND
	beneficial = -1
	minimum = -2
	maximum = 2
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "phychiatric effects"

/decl/random_chem_effect/random_properties/ce_cryogenic
	chem_effect_define = CE_CRYO
	beneficial = 1
	desc = "hypothermia protection"

/decl/random_chem_effect/random_properties/ce_blockage
	chem_effect_define = CE_BLOCKAGE
	beneficial = -1
	maximum = 0.5
	mode = RANDOM_CHEM_EFFECT_FLOAT
	desc = "blood flow obstruction"

/decl/random_chem_effect/random_properties/ce_squeaky
	chem_effect_define = CE_SQUEAKY
	beneficial = -1
	desc = "abnormal speech patterns"

/decl/random_chem_effect/random_properties/tox_damage
	beneficial = -1
	maximum = 100
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "acute toxicity"

/decl/random_chem_effect/random_properties/heal_brute/affect_blood(var/mob/living/M, var/removed, var/value)
	M.take_damage(value * removed, TOX)

/decl/random_chem_effect/random_properties/heal_brute
	beneficial = 1
	maximum = 10
	desc = "tissue repair"

/decl/random_chem_effect/random_properties/heal_brute/affect_blood(var/mob/living/M, var/removed, var/value)
	M.heal_organ_damage(removed * value, 0)

/decl/random_chem_effect/random_properties/heal_burns
	beneficial = 1
	maximum = 10
	desc = "burn repair"

/decl/random_chem_effect/random_properties/heal_brute/affect_blood(var/mob/living/M, var/removed, var/value)
	M.heal_organ_damage(0, removed * value)

#undef RANDOM_CHEM_EFFECT_TRUE
#undef RANDOM_CHEM_EFFECT_INT
#undef RANDOM_CHEM_EFFECT_FLOAT