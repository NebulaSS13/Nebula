/decl/material/boron
	name = "boron"
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	is_fusion_fuel = TRUE
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/lithium
	name = "lithium"
	lore_text = "A chemical element, used as antidepressant."
	chem_products = list(/decl/material/lithium = 20)
	is_fusion_fuel = TRUE
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/oxygen
	name = "oxygen"
	lore_text = "An ubiquitous oxidizing agent."
	is_fusion_fuel = TRUE
	gas_specific_heat = 20	
	gas_molar_mass = 0.032	
	gas_flags = XGM_GAS_OXIDIZER | XGM_GAS_FUSION_FUEL | XGM_GAS_DEFAULT_GAS
	gas_symbol_html = "O<sub>2</sub>"
	gas_symbol = "O2"

/decl/material/helium
	name = "helium"
	lore_text = "A noble gas. It makes your voice squeaky."
	chem_products = list(/decl/material/helium = 20)
	is_fusion_fuel = TRUE
	gas_specific_heat = 80
	gas_molar_mass = 0.004
	gas_flags = XGM_GAS_FUSION_FUEL | XGM_GAS_DEFAULT_GAS
	gas_symbol_html = "He"
	gas_symbol = "He"
	taste_description = "nothing"
	icon_colour = COLOR_GRAY80
	metabolism = 0.05

/decl/material/helium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_SQUEAKY, 1)

/decl/material/carbon_dioxide
	name = "carbon dioxide"
	lore_text = "A byproduct of respiration."
	gas_specific_heat = 30	
	gas_molar_mass = 0.044	
	gas_symbol_html = "CO<sub>2</sub>"
	gas_symbol = "CO2"
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/carbon_monoxide
	name = "carbon monoxide"
	lore_text = "A dangerous carbon comubstion byproduct."
	chem_products = list(/decl/material/carbon_monoxide = 20)
	gas_specific_heat = 30
	gas_molar_mass = 0.028
	gas_symbol_html = "CO"
	gas_symbol = "CO"
	taste_description = "stale air"
	icon_colour = COLOR_GRAY80
	metabolism = 0.05 // As with helium.
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/carbon_monoxide/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	var/warning_message
	var/warning_prob = 10
	var/dosage = M.chem_doses[type]
	if(dosage >= 3)
		warning_message = pick("extremely dizzy","short of breath","faint","confused")
		warning_prob = 15
		M.adjustOxyLoss(10,20)
		M.co2_alert = 1
	else if(dosage >= 1.5)
		warning_message = pick("dizzy","short of breath","faint","momentarily confused")
		M.co2_alert = 1
		M.adjustOxyLoss(3,5)
	else if(dosage >= 0.25)
		warning_message = pick("a little dizzy","short of breath")
		warning_prob = 10
		M.co2_alert = 0
	else
		M.co2_alert = 0
	if(dosage > 1 && M.losebreath < 15)
		M.losebreath++
	if(warning_message && prob(warning_prob))
		to_chat(M, "<span class='warning'>You feel [warning_message].</span>")

/decl/material/toxin/methyl_bromide
	name = "methyl bromide"
	lore_text = "A once-popular fumigant and weedkiller."
	chem_products = list(/decl/material/toxin/methyl_bromide = 20)
	gas_specific_heat = 42.59 
	gas_molar_mass = 0.095	  
	gas_symbol_html = "CH<sub>3</sub>Br"
	gas_symbol = "CH3Br"
	gas_flags = XGM_GAS_DEFAULT_GAS
	taste_description = "pestkiller"
	icon_colour = "#4c3b34"
	strength = 5

/decl/material/toxin/methyl_bromide/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T))
		var/volume = REAGENT_VOLUME(holder, type)
		T.assume_gas(MAT_METHYL_BROMIDE, volume, T20C)
		holder.remove_reagent(type, volume)

/decl/material/toxin/methyl_bromide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(istype(M))
		for(var/obj/item/organ/external/E in M.organs)
			if(LAZYLEN(E.implants))
				for(var/obj/effect/spider/spider in E.implants)
					if(prob(25))
						E.implants -= spider
						M.visible_message("<span class='notice'>The dying form of \a [spider] emerges from inside \the [M]'s [E.name].</span>")
						qdel(spider)
						break

/decl/material/nitrous_oxide
	name = "nitrous oxide"
	lore_text = "An ubiquitous sedative also known as laughing gas."
	chem_products = list(/decl/material/nitrous_oxide = 20)
	gas_specific_heat = 40	
	gas_molar_mass = 0.044	
	gas_tile_overlay = "sleeping_agent"
	gas_overlay_limit = 1
	gas_flags = XGM_GAS_OXIDIZER | XGM_GAS_DEFAULT_GAS //N2O is a powerful oxidizer
	gas_symbol_html = "N<sub>2</sub>O"
	gas_symbol = "N2O"
	taste_description = "dental surgery"
	icon_colour = COLOR_GRAY80
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.

/decl/material/nitrous_oxide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/dosage = M.chem_doses[type]
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

/decl/material/nitrogen
	name = "nitrogen"
	lore_text = "An ubiquitous noble gas."
	gas_specific_heat = 20	
	gas_molar_mass = 0.028	
	gas_symbol_html = "N<sub>2</sub>"
	gas_symbol = "N2"
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/toxin/nitrodioxide
	name = "nitrogen dioxide"
	chem_products = list(/decl/material/toxin/nitrodioxide = 20)
	icon_colour = "#ca6409"
	gas_specific_heat = 37
	gas_molar_mass = 0.054
	gas_flags = XGM_GAS_OXIDIZER | XGM_GAS_DEFAULT_GAS
	gas_symbol_html = "NO<sub>2</sub>"
	gas_symbol = "NO2"
	strength = 4

/decl/material/nitricoxide
	name = "nitric oxide"
	gas_specific_heat = 10
	gas_molar_mass = 0.030
	gas_flags = XGM_GAS_OXIDIZER | XGM_GAS_DEFAULT_GAS
	gas_symbol_html = "NO"
	gas_symbol = "NO"

/decl/material/methane
	name = "methane"
	gas_specific_heat = 30	
	gas_molar_mass = 0.016	
	gas_flags = XGM_GAS_FUEL | XGM_GAS_DEFAULT_GAS
	gas_symbol_html = "CH<sub>4</sub>"
	gas_symbol = "CH4"

/decl/material/alien
	name = "alien gas"
	hidden_from_codex = TRUE
	gas_symbol_html = "X"
	gas_symbol = "X"
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/alien/New()
	var/num = rand(100,999)
	name = "compound #[num]"
	gas_specific_heat = rand(1, 400)	
	gas_molar_mass = rand(20,800)/1000	
	if(prob(40))
		gas_flags |= XGM_GAS_FUEL
	else if(prob(40)) //it's prooobably a bad idea for gas being oxidizer to itself.
		gas_flags |= XGM_GAS_OXIDIZER
	if(prob(40))
		gas_flags |= XGM_GAS_CONTAMINANT
	if(prob(40))
		gas_flags |= XGM_GAS_FUSION_FUEL
	gas_symbol_html = "X<sup>[num]</sup>"
	gas_symbol = "X-[num]"
	if(prob(50))
		icon_colour = RANDOM_RGB
		gas_overlay_limit = 0.5

/decl/material/argon
	name = "argon"
	lore_text = "Just when you need it, all of your supplies argon."
	gas_specific_heat = 10
	gas_molar_mass = 0.018
	gas_symbol_html = "Ar"
	gas_symbol = "Ar"
	gas_flags = XGM_GAS_DEFAULT_GAS

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/decl/material/krypton
	name = "krypton"
	gas_specific_heat = 5
	gas_molar_mass = 0.036
	gas_symbol_html = "Kr"
	gas_symbol = "Kr"
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/neon
	name = "neon"
	gas_specific_heat = 20
	gas_molar_mass = 0.01
	gas_symbol_html = "Ne"
	gas_symbol = "Ne"
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/xenon
	name = "xenon"
	lore_text = "A nontoxic gas used as a general anaesthetic."
	chem_products = list(/decl/material/xenon = 20)
	gas_specific_heat = 3
	gas_molar_mass = 0.054
	gas_symbol_html = "Xe"
	gas_symbol = "Xe"
	taste_description = "nothing"
	icon_colour = COLOR_GRAY80
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/xenon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/dosage = M.chem_doses[type]
	if(dosage >= 1)
		if(prob(5)) M.Sleeping(3)
		M.dizziness =  max(M.dizziness, 3)
		M.confused =   max(M.confused, 3)
	if(dosage >= 0.3)
		if(prob(5)) M.Paralyse(1)
		M.drowsyness = max(M.drowsyness, 3)
		M.slurring =   max(M.slurring, 3)
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/ammonia
	name = "ammonia"
	lore_text = "A caustic substance commonly used in fertilizer or household cleaners."
	chem_products = list(/decl/material/ammonia = 20)
	gas_specific_heat = 20
	gas_molar_mass = 0.017
	gas_symbol_html = "NH<sub>3</sub>"
	gas_symbol = "NH3"
	taste_description = "mordant"
	taste_mult = 2
	icon_colour = "#404030"
	metabolism = REM * 0.5
	overdose = 5
	value = 0.5
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/toxin/chlorine
	name = "chlorine"
	lore_text = "A highly poisonous chemical. Smells strongly of bleach."
	chem_products = list(/decl/material/toxin/chlorine = 20)
	taste_description = "bleach"
	icon_colour = "#707c13"
	gas_overlay_limit = 0.5
	gas_specific_heat = 5
	gas_molar_mass = 0.017
	gas_flags = XGM_GAS_CONTAMINANT | XGM_GAS_DEFAULT_GAS
	gas_symbol_html = "Cl"
	gas_symbol = "Cl"
	strength = 15

/decl/material/sulfurdioxide
	name = "sulfur dioxide"
	chem_products = list(/decl/material/sulfur = 20)
	gas_specific_heat = 30
	gas_molar_mass = 0.044
	gas_symbol_html = "SO<sub>2</sub>"
	gas_symbol = "SO2"
	gas_flags = XGM_GAS_DEFAULT_GAS

/decl/material/hydrogen
	name = "hydrogen"
	lore_text = "A colorless, flammable gas."
	is_fusion_fuel = TRUE
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	wall_name = "bulkhead"
	construction_difficulty = MAT_VALUE_HARD_DIY
	gas_specific_heat = 100
	gas_molar_mass = 0.002
	gas_flags = XGM_GAS_FUEL | XGM_GAS_FUSION_FUEL | XGM_GAS_DEFAULT_GAS
	gas_burn_product = MAT_WATER
	gas_symbol_html = "H<sub>2</sub>"
	gas_symbol = "H2"
	chem_products = list(MAT_HYDRAZINE = 20)

/decl/material/hydrogen/tritium
	name = "tritium"
	lore_text = "A radioactive isotope of hydrogen. Useful as a fusion reactor fuel material."
	mechanics_text = "Tritium is useable as a fuel in some forms of portable generator. It can also be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It fuses hotter than deuterium but is correspondingly more unstable."
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = "{'materials':5}"
	value = 300
	gas_symbol_html = "T"
	gas_symbol = "T"

/decl/material/hydrogen/deuterium
	name = "deuterium"
	lore_text = "One of the two stable isotopes of hydrogen; also known as heavy hydrogen. Useful as a chemically synthesised fusion reactor fuel material."
	mechanics_text = "Deuterium can be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It is the most 'basic' fusion fuel."
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = "{'materials':3}"
	gas_symbol_html = "D"
	gas_symbol = "D"

/decl/material/hydrogen/metallic
	name = "metallic hydrogen"
	lore_text = "When hydrogen is exposed to extremely high pressures and temperatures, such as at the core of gas giants like Jupiter, it can take on metallic properties and - more importantly - acts as a room temperature superconductor. Achieving solid metallic hydrogen at room temperature, though, has proven to be rather tricky."
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#e6c5de"
	stack_origin_tech = "{'materials':6,'powerstorage':6,'magnets':5}"
	ore_smelts_to = MAT_TRITIUM
	ore_name = "raw hydrogen"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	sale_price = 5
	value = 100
	gas_symbol_html = "H*"
	gas_symbol = "H*"
	gas_flags = 0
