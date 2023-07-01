/decl/material/gas/oxygen
	name = "oxygen"
	uid = "gas_oxygen"
	lore_text = "An ubiquitous oxidizing agent."
	flags = MAT_FLAG_FUSION_FUEL
	gas_specific_heat = 20
	molar_mass = 0.032
	latent_heat = 213
	boiling_point = -183 CELSIUS
	gas_flags = XGM_GAS_OXIDIZER
	gas_symbol_html = "O<sub>2</sub>"
	gas_symbol = "O2"
	gas_metabolically_inert = TRUE
	value = 0.25

/decl/material/gas/helium
	name = "helium"
	uid = "gas_helium"
	lore_text = "A noble gas. It makes your voice squeaky."
	flags = MAT_FLAG_FUSION_FUEL
	gas_specific_heat = 80
	molar_mass = 0.004
	latent_heat = 21
	boiling_point = -269 CELSIUS
	gas_symbol_html = "He"
	gas_symbol = "He"
	taste_description = "nothing"
	metabolism = 0.05
	value = 0.3

/decl/material/gas/helium/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_SQUEAKY, 1)

/decl/material/gas/carbon_dioxide
	name = "carbon dioxide"
	uid = "gas_carbon_dioxide"
	lore_text = "A byproduct of respiration."
	gas_specific_heat = 30
	molar_mass = 0.044
	latent_heat = 380
	boiling_point = -78 CELSIUS
	gas_symbol_html = "CO<sub>2</sub>"
	gas_symbol = "CO2"
	gas_metabolically_inert = TRUE

/decl/material/gas/carbon_monoxide
	name = "carbon monoxide"
	uid = "gas_carbon_monoxide"
	lore_text = "A highly poisonous gas."
	gas_specific_heat = 30
	molar_mass = 0.028
	latent_heat = 216
	boiling_point = -192 CELSIUS
	gas_symbol_html = "CO"
	gas_symbol = "CO"
	taste_description = "stale air"
	metabolism = 0.05 // As with helium.

/decl/material/gas/carbon_monoxide/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
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
	uid = "gas_methyl_bromide"
	lore_text = "A once-popular fumigant and weedkiller."
	gas_specific_heat = 42.59
	molar_mass = 0.095
	latent_heat = 253
	boiling_point = 4 CELSIUS
	gas_symbol_html = "CH<sub>3</sub>Br"
	gas_symbol = "CH3Br"
	taste_description = "pestkiller"
	vapor_products = list(
		/decl/material/gas/methyl_bromide = 1
	)
	value = 0.25

/decl/material/gas/methyl_bromide/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	for(var/obj/item/organ/external/E in H.get_external_organs())
		for(var/obj/effect/spider/spider in E.implants)
			if(prob(25))
				E.implants -= spider
				H.visible_message(SPAN_NOTICE("The dying form of \a [spider] emerges from inside \the [M]'s [E.name]."))
				qdel(spider)
				break

/decl/material/gas/nitrous_oxide
	name = "sleeping agent"
	uid = "gas_sleeping_agent"
	lore_text = "A mild sedative. Also known as laughing gas."
	gas_specific_heat = 40
	molar_mass = 0.044
	latent_heat = 376
	boiling_point = -90 CELSIUS
	gas_tile_overlay = "sleeping_agent"
	gas_overlay_limit = 1
	gas_flags = XGM_GAS_OXIDIZER //N2O is a powerful oxidizer
	gas_symbol_html = "N<sub>2</sub>O"
	gas_symbol = "N2O"
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.
	value = 0.25

/decl/material/gas/nitrous_oxide/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/dosage = LAZYACCESS(M.chem_doses, type)
	if(dosage >= 1)
		if(prob(5)) SET_STATUS_MAX(M, STAT_ASLEEP, 3)
		SET_STATUS_MAX(M, STAT_DIZZY, 3)
		SET_STATUS_MAX(M, STAT_CONFUSE, 3)
	if(dosage >= 0.3)
		if(prob(5)) SET_STATUS_MAX(M, STAT_PARA, 1)
		SET_STATUS_MAX(M, STAT_DROWSY, 3)
		SET_STATUS_MAX(M, STAT_SLUR, 3)
	if(prob(20))
		M.emote(pick("giggle", "laugh"))
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/gas/nitrogen
	name = "nitrogen"
	uid = "gas_nitrogen"
	lore_text = "An ubiquitous noble gas."
	gas_specific_heat = 20
	molar_mass = 0.028
	latent_heat = 199
	boiling_point = -195 CELSIUS
	gas_symbol_html = "N<sub>2</sub>"
	gas_symbol = "N2"
	gas_metabolically_inert = TRUE

/decl/material/gas/nitrodioxide
	name = "nitrogen dioxide"
	uid = "gas_nitrogen_dioxide"
	color = "#ca6409"
	gas_specific_heat = 37
	molar_mass = 0.054
	latent_heat = 272
	boiling_point = -9 CELSIUS
	gas_flags = XGM_GAS_OXIDIZER
	gas_symbol_html = "NO<sub>2</sub>"
	gas_symbol = "NO2"

/decl/material/gas/nitricoxide
	name = "nitric oxide"
	uid = "gas_nitric_oxide"
	gas_specific_heat = 10
	molar_mass = 0.030
	latent_heat = 410
	boiling_point = -152 CELSIUS
	gas_flags = XGM_GAS_OXIDIZER
	gas_symbol_html = "NO"
	gas_symbol = "NO"

/decl/material/gas/methane
	name = "methane"
	uid = "gas_methane"
	gas_specific_heat = 30
	molar_mass = 0.016
	latent_heat = 510
	boiling_point = -162 CELSIUS
	gas_flags = XGM_GAS_FUEL
	gas_symbol_html = "CH<sub>4</sub>"
	gas_symbol = "CH4"

/decl/material/gas/argon
	name = "argon"
	uid = "gas_argon"
	lore_text = "Just when you need it, all of your supplies argon."
	gas_specific_heat = 10
	molar_mass = 0.039
	latent_heat = 163
	boiling_point = -185 CELSIUS
	gas_symbol_html = "Ar"
	gas_symbol = "Ar"
	value = 0.25

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/decl/material/gas/krypton
	name = "krypton"
	uid = "gas_krypton"
	gas_specific_heat = 5
	molar_mass = 0.083
	latent_heat = 108
	boiling_point = -153 CELSIUS
	gas_symbol_html = "Kr"
	gas_symbol = "Kr"
	value = 0.25

/decl/material/gas/neon
	name = "neon"
	uid = "gas_neon"
	gas_specific_heat = 20
	molar_mass = 0.02
	latent_heat = 86
	boiling_point = -246 CELSIUS
	gas_symbol_html = "Ne"
	gas_symbol = "Ne"
	value = 0.25

/decl/material/gas/ammonia
	name = "ammonia"
	uid = "gas_ammonia"
	gas_specific_heat = 20
	molar_mass = 0.017
	latent_heat = 1370
	boiling_point = -33 CELSIUS
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
	uid = "gas_xenon"
	gas_specific_heat = 3
	molar_mass = 0.131
	latent_heat = 96
	boiling_point = -108 CELSIUS
	gas_symbol_html = "Xe"
	gas_symbol = "Xe"
	value = 0.25

/decl/material/gas/xenon/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/dosage = LAZYACCESS(M.chem_doses, type)
	if(dosage >= 1)
		if(prob(5)) SET_STATUS_MAX(M, STAT_ASLEEP, 3)
		SET_STATUS_MAX(M, STAT_DIZZY, 3)
		SET_STATUS_MAX(M, STAT_CONFUSE, 3)
	if(dosage >= 0.3)
		if(prob(5)) SET_STATUS_MAX(M, STAT_PARA, 1)
		SET_STATUS_MAX(M, STAT_DROWSY, 3)
		SET_STATUS_MAX(M, STAT_SLUR, 3)
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/gas/chlorine
	name = "chlorine"
	uid = "gas_chlorine"
	color = "#c5f72d"
	gas_overlay_limit = 0.5
	gas_specific_heat = 5
	molar_mass = 0.071 //Cl2 gas
	latent_heat = 254
	boiling_point = -34 CELSIUS
	gas_flags = XGM_GAS_CONTAMINANT
	gas_symbol_html = "Cl<sub>2</sub>"
	gas_symbol = "Cl"
	taste_description = "bleach"
	metabolism = REM
	toxicity = 15

/decl/material/gas/sulfur_dioxide
	name = "sulfur dioxide"
	uid = "gas_sulfur_dioxide"
	gas_specific_heat = 30
	molar_mass = 0.064
	latent_heat = 389
	boiling_point = -10 CELSIUS
	gas_symbol_html = "SO<sub>2</sub>"
	gas_symbol = "SO2"
	dissolves_into = list(
		/decl/material/solid/sulfur = 0.5,
		/decl/material/gas/oxygen = 0.5
	)

/decl/material/gas/hydrogen
	name = "hydrogen"
	codex_name = "elemental hydrogen"
	uid = "gas_hydrogen"
	lore_text = "A colorless, flammable gas."
	flags = MAT_FLAG_FUSION_FUEL
	wall_name = "bulkhead"
	construction_difficulty = MAT_VALUE_HARD_DIY
	gas_specific_heat = 100
	molar_mass = 0.002
	latent_heat = 454
	boiling_point = -252 CELSIUS
	gas_flags = XGM_GAS_FUEL
	burn_product = /decl/material/liquid/water
	gas_symbol_html = "H<sub>2</sub>"
	gas_symbol = "H2"
	dissolves_into = list(
		/decl/material/liquid/fuel/hydrazine = 1
	)
	value = 0.4

/decl/material/gas/hydrogen/tritium
	name = "tritium"
	codex_name = null
	uid = "gas_tritium"
	lore_text = "A radioactive isotope of hydrogen. Useful as a fusion reactor fuel material."
	mechanics_text = "Tritium is useable as a fuel in some forms of portable generator. It can also be converted into a fuel rod suitable for a R-UST fusion plant injector by using a fuel compressor. It fuses hotter than deuterium but is correspondingly more unstable."
	color = "#777777"
	stack_origin_tech = "{'materials':5}"
	value = 0.45
	gas_symbol_html = "T"
	gas_symbol = "T"
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_UNCOMMON

/decl/material/gas/hydrogen/deuterium
	name = "deuterium"
	codex_name = null
	uid = "gas_deuterium"
	lore_text = "One of the two stable isotopes of hydrogen; also known as heavy hydrogen. Useful as a chemically synthesised fusion reactor fuel material."
	mechanics_text = "Deuterium can be converted into a fuel rod suitable for a R-UST fusion plant injector by using a fuel compressor. It is the most 'basic' fusion fuel."
	flags = MAT_FLAG_FUSION_FUEL | MAT_FLAG_FISSIBLE
	color = "#999999"
	stack_origin_tech = "{'materials':3}"
	gas_symbol_html = "D"
	gas_symbol = "D"
	value = 0.5
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_UNCOMMON

	neutron_interactions = list(
		INTERACTION_ABSORPTION = 1250
	)
	absorption_products = list(
		/decl/material/gas/hydrogen/tritium = 1
	)
	neutron_absorption = 5
	neutron_cross_section = 3

