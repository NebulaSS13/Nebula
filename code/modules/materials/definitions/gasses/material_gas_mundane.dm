/decl/material/gas/oxygen
	name = "oxygen"
	lore_text = "An ubiquitous oxidizing agent."
	flags = MAT_FLAG_FUSION_FUEL
	gas_specific_heat = 20	
	gas_molar_mass = 0.032	
	gas_flags = XGM_GAS_OXIDIZER
	gas_symbol_html = "O<sub>2</sub>"
	gas_symbol = "O2"
	gas_metabolically_inert = TRUE

/decl/material/gas/helium
	name = "helium"
	lore_text = "A noble gas. It makes your voice squeaky."
	flags = MAT_FLAG_FUSION_FUEL
	gas_specific_heat = 80
	gas_molar_mass = 0.004
	gas_symbol_html = "He"
	gas_symbol = "He"
	taste_description = "nothing"
	metabolism = 0.05

/decl/material/gas/helium/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_SQUEAKY, 1)

/decl/material/gas/carbon_dioxide
	name = "carbon dioxide"
	lore_text = "A byproduct of respiration."
	gas_specific_heat = 30	
	gas_molar_mass = 0.044	
	gas_symbol_html = "CO<sub>2</sub>"
	gas_symbol = "CO2"

/decl/material/gas/carbon_monoxide
	name = "carbon monoxide"
	lore_text = "A highly poisonous gas."
	gas_specific_heat = 30
	gas_molar_mass = 0.028
	gas_symbol_html = "CO"
	gas_symbol = "CO"
	taste_description = "stale air"
	metabolism = 0.05 // As with helium.

/decl/material/gas/carbon_monoxide/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	var/warning_message
	var/warning_prob = 10
	var/dosage = LAZYACCESS(M.chem_doses, type)
	var/mob/living/carbon/human/H = M
	if(dosage >= 3)
		warning_message = pick("extremely dizzy","short of breath","faint","confused")
		warning_prob = 15
		M.adjustOxyLoss(10,20)
		if(istype(H))
			H.co2_alert = 1
	else if(dosage >= 1.5)
		warning_message = pick("dizzy","short of breath","faint","momentarily confused")
		M.adjustOxyLoss(3,5)
		if(istype(H))
			H.co2_alert = 1
	else if(dosage >= 0.25)
		warning_message = pick("a little dizzy","short of breath")
		warning_prob = 10
		if(istype(H))
			H.co2_alert = 0
	else if(istype(H))
		H.co2_alert = 0
	if(istype(H) && dosage > 1 && H.losebreath < 15)
		H.losebreath++
	if(warning_message && prob(warning_prob))
		to_chat(M, SPAN_WARNING("You feel [warning_message]."))

/decl/material/gas/methyl_bromide
	name = "methyl bromide"
	lore_text = "A once-popular fumigant and weedkiller."
	gas_specific_heat = 42.59 
	gas_molar_mass = 0.095	  
	gas_symbol_html = "CH<sub>3</sub>Br"
	gas_symbol = "CH3Br"
	taste_description = "pestkiller"
	vapor_products = list(
		/decl/material/gas/methyl_bromide = 1
	)

/decl/material/gas/methyl_bromide/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	for(var/obj/item/organ/external/E in H.organs)
		if(!LAZYLEN(E.implants))
			continue
		for(var/obj/effect/spider/spider in E.implants)
			if(prob(25))
				E.implants -= spider
				H.visible_message(SPAN_NOTICE("The dying form of \a [spider] emerges from inside \the [M]'s [E.name]."))
				qdel(spider)
				break

/decl/material/gas/nitrous_oxide
	name = "sleeping agent"
	lore_text = "A mild sedative. Also known as laughing gas."
	gas_specific_heat = 40	
	gas_molar_mass = 0.044	
	gas_tile_overlay = "sleeping_agent"
	gas_overlay_limit = 1
	gas_flags = XGM_GAS_OXIDIZER //N2O is a powerful oxidizer
	gas_symbol_html = "N<sub>2</sub>O"
	gas_symbol = "N2O"
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.

/decl/material/gas/nitrous_oxide/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/dosage = LAZYACCESS(M.chem_doses, type)
	if(dosage >= 1)
		if(prob(5)) M.Sleeping(3)
		M.dizziness =  max(M.dizziness, 3)
		M.confused =   max(M.confused, 3)
	if(dosage >= 0.3)
		if(prob(5)) M.Paralyse(1)
		M.drowsyness = max(M.drowsyness, 3)
		M.slurring =   max(M.slurring, 3)
	if(prob(20))
		M.emote(pick("giggle", "laugh"))
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/gas/nitrogen
	name = "nitrogen"
	lore_text = "An ubiquitous noble gas."
	gas_specific_heat = 20	
	gas_molar_mass = 0.028	
	gas_symbol_html = "N<sub>2</sub>"
	gas_symbol = "N2"
	gas_metabolically_inert = TRUE

/decl/material/gas/nitrodioxide
	name = "nitrogen dioxide"
	color = "#ca6409"
	gas_specific_heat = 37
	gas_molar_mass = 0.054
	gas_flags = XGM_GAS_OXIDIZER
	gas_symbol_html = "NO<sub>2</sub>"
	gas_symbol = "NO2"

/decl/material/gas/nitricoxide
	name = "nitric oxide"
	gas_specific_heat = 10
	gas_molar_mass = 0.030
	gas_flags = XGM_GAS_OXIDIZER
	gas_symbol_html = "NO"
	gas_symbol = "NO"

/decl/material/gas/methane
	name = "methane"
	gas_specific_heat = 30	
	gas_molar_mass = 0.016	
	gas_flags = XGM_GAS_FUEL
	gas_symbol_html = "CH<sub>4</sub>"
	gas_symbol = "CH4"

/decl/material/gas/argon
	name = "argon"
	lore_text = "Just when you need it, all of your supplies argon."
	gas_specific_heat = 10
	gas_molar_mass = 0.018
	gas_symbol_html = "Ar"
	gas_symbol = "Ar"

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/decl/material/gas/krypton
	name = "krypton"
	gas_specific_heat = 5
	gas_molar_mass = 0.036
	gas_symbol_html = "Kr"
	gas_symbol = "Kr"

/decl/material/gas/neon
	name = "neon"
	gas_specific_heat = 20
	gas_molar_mass = 0.01
	gas_symbol_html = "Ne"
	gas_symbol = "Ne"

/decl/material/gas/ammonia
	name = "ammonia"
	gas_specific_heat = 20
	gas_molar_mass = 0.017
	gas_symbol_html = "NH<sub>3</sub>"
	gas_symbol = "NH3"
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.
	taste_description = "mordant"
	taste_mult = 2
	lore_text = "A caustic substance commonly used in fertilizer or household cleaners."
	color = "#404030"
	metabolism = REM * 0.5
	overdose = 5

/decl/material/gas/xenon
	name = "xenon"
	gas_specific_heat = 3
	gas_molar_mass = 0.054
	gas_symbol_html = "Xe"
	gas_symbol = "Xe"

/decl/material/gas/xenon/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/dosage = LAZYACCESS(M.chem_doses, type)
	if(dosage >= 1)
		if(prob(5)) M.Sleeping(3)
		M.dizziness =  max(M.dizziness, 3)
		M.confused =   max(M.confused, 3)
	if(dosage >= 0.3)
		if(prob(5)) M.Paralyse(1)
		M.drowsyness = max(M.drowsyness, 3)
		M.slurring =   max(M.slurring, 3)
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/gas/chlorine
	name = "chlorine"
	color = "#c5f72d"
	gas_overlay_limit = 0.5
	gas_specific_heat = 5
	gas_molar_mass = 0.017
	gas_flags = XGM_GAS_CONTAMINANT
	gas_symbol_html = "Cl"
	gas_symbol = "Cl"
	taste_description = "bleach"
	metabolism = REM
	heating_point = null
	heating_products = null
	toxicity = 15

/decl/material/gas/sulfur_dioxide
	name = "sulfur dioxide"
	gas_specific_heat = 30
	gas_molar_mass = 0.044
	gas_symbol_html = "SO<sub>2</sub>"
	gas_symbol = "SO2"
	dissolves_into = list(
		/decl/material/solid/sulfur = 0.5,
		/decl/material/gas/oxygen = 0.5
	)

/decl/material/gas/hydrogen
	name = "hydrogen"
	lore_text = "A colorless, flammable gas."
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	flags = MAT_FLAG_FUSION_FUEL
	wall_name = "bulkhead"
	construction_difficulty = MAT_VALUE_HARD_DIY
	gas_specific_heat = 100
	gas_molar_mass = 0.002
	gas_flags = XGM_GAS_FUEL
	burn_product = /decl/material/liquid/water
	gas_symbol_html = "H<sub>2</sub>"
	gas_symbol = "H2"
	dissolves_into = list(
		/decl/material/liquid/fuel/hydrazine = 1
	)

/decl/material/gas/hydrogen/tritium
	name = "tritium"
	lore_text = "A radioactive isotope of hydrogen. Useful as a fusion reactor fuel material."
	mechanics_text = "Tritium is useable as a fuel in some forms of portable generator. It can also be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It fuses hotter than deuterium but is correspondingly more unstable."
	stack_type = /obj/item/stack/material/tritium
	color = "#777777"
	stack_origin_tech = "{'materials':5}"
	value = 1.5
	gas_symbol_html = "T"
	gas_symbol = "T"

/decl/material/gas/hydrogen/deuterium
	name = "deuterium"
	lore_text = "One of the two stable isotopes of hydrogen; also known as heavy hydrogen. Useful as a chemically synthesised fusion reactor fuel material."
	mechanics_text = "Deuterium can be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It is the most 'basic' fusion fuel."
	stack_type = /obj/item/stack/material/deuterium
	color = "#999999"
	stack_origin_tech = "{'materials':3}"
	gas_symbol_html = "D"
	gas_symbol = "D"
