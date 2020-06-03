// Placeholders for compile purposes.
/decl/material/gas
	name = null
	icon_colour = COLOR_GRAY80
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE
	hidden_from_codex = FALSE
	value = 0
	gas_burn_product = MAT_CO2
	gas_specific_heat = 20    // J/(mol*K)
	gas_molar_mass =    0.032 // kg/mol
	reflectiveness = 0
	hardness = 0
	weight = 1

/decl/material/gas/boron
	name = "boron"
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	is_fusion_fuel = TRUE

/decl/material/gas/lithium
	name = "lithium"
	lore_text = "A chemical element, used as antidepressant."
	chemical_makeup = list(
		/decl/material/chem/lithium = 1
	)
	is_fusion_fuel = TRUE

/decl/material/gas/oxygen
	name = "oxygen"
	lore_text = "An ubiquitous oxidizing agent."
	is_fusion_fuel = TRUE
	gas_specific_heat = 20	
	gas_molar_mass = 0.032	
	gas_flags = XGM_GAS_OXIDIZER | XGM_GAS_FUSION_FUEL
	gas_symbol_html = "O<sub>2</sub>"
	gas_symbol = "O2"

/decl/material/gas/helium
	name = "helium"
	lore_text = "A noble gas. It makes your voice squeaky."
	chemical_makeup = list(
		/decl/material/gas/helium = 1
	)
	is_fusion_fuel = TRUE
	gas_specific_heat = 80
	gas_molar_mass = 0.004
	gas_flags = XGM_GAS_FUSION_FUEL
	gas_symbol_html = "He"
	gas_symbol = "He"
	taste_description = "nothing"
	metabolism = 0.05

/decl/material/gas/helium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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
	chemical_makeup = list(
		/decl/material/gas/carbon_monoxide = 1
	)
	gas_specific_heat = 30
	gas_molar_mass = 0.028
	gas_symbol_html = "CO"
	gas_symbol = "CO"
	taste_description = "stale air"
	metabolism = 0.05 // As with helium.

/decl/material/gas/carbon_monoxide/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/material/gas/methyl_bromide
	name = "methyl bromide"
	lore_text = "A once-popular fumigant and weedkiller."
	chemical_makeup = list(
		/decl/material/gas/methyl_bromide = 1
	)
	gas_specific_heat = 42.59 
	gas_molar_mass = 0.095	  
	gas_symbol_html = "CH<sub>3</sub>Br"
	gas_symbol = "CH3Br"
	taste_description = "pestkiller"

/decl/material/gas/methyl_bromide/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T))
		var/volume = REAGENT_VOLUME(holder, type)
		T.assume_gas(MAT_METHYL_BROMIDE, volume, T20C)
		holder.remove_reagent(type, volume)

/decl/material/gas/methyl_bromide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/material/gas/nitrous_oxide
	name = "sleeping agent"
	lore_text = "A mild sedative. Also known as laughing gas."
	chemical_makeup = list(
		/decl/material/gas/nitrous_oxide = 1
	)
	gas_specific_heat = 40	
	gas_molar_mass = 0.044	
	gas_tile_overlay = "sleeping_agent"
	gas_overlay_limit = 1
	gas_flags = XGM_GAS_OXIDIZER //N2O is a powerful oxidizer
	gas_symbol_html = "N<sub>2</sub>O"
	gas_symbol = "N2O"
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.

/decl/material/gas/nitrous_oxide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/material/gas/nitrogen
	name = "nitrogen"
	lore_text = "An ubiquitous noble gas."
	gas_specific_heat = 20	
	gas_molar_mass = 0.028	
	gas_symbol_html = "N<sub>2</sub>"
	gas_symbol = "N2"

/decl/material/gas/nitrodioxide
	name = "nitrogen dioxide"
	chemical_makeup = list(
		/decl/material/chem/toxin = 1
	)
	icon_colour = "#ca6409"
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

/decl/material/gas/alien
	name = "alien gas"
	hidden_from_codex = TRUE
	gas_symbol_html = "X"
	gas_symbol = "X"

/decl/material/gas/alien/New()
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
	chemical_makeup = list(
		/decl/material/chem/ammonia = 1
	)
	gas_specific_heat = 20
	gas_molar_mass = 0.017
	gas_symbol_html = "NH<sub>3</sub>"
	gas_symbol = "NH3"
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.

/decl/material/gas/xenon
	name = "xenon"
	chemical_makeup = list(
		/decl/material/gas/xenon = 1
	)
	gas_specific_heat = 3
	gas_molar_mass = 0.054
	gas_symbol_html = "Xe"
	gas_symbol = "Xe"

/decl/material/gas/xenon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/material/gas/chlorine
	name = "chlorine"
	chemical_makeup = list(
		/decl/material/chem/toxin/chlorine = 1
	)
	icon_colour = "#c5f72d"
	gas_overlay_limit = 0.5
	gas_specific_heat = 5
	gas_molar_mass = 0.017
	gas_flags = XGM_GAS_CONTAMINANT
	gas_symbol_html = "Cl"
	gas_symbol = "Cl"

/decl/material/gas/sulfurdioxide
	name = "sulfur dioxide"
	chemical_makeup = list(
		/decl/material/chem/sulfur = 1
	)
	gas_specific_heat = 30
	gas_molar_mass = 0.044
	gas_symbol_html = "SO<sub>2</sub>"
	gas_symbol = "SO2"

/decl/material/gas/water
	name = "water"
	gas_name = "water vapour"
	solid_name = "ice"
	lore_text = "A ubiquitous chemical substance composed of hydrogen and oxygen."
	color = COLOR_OCEAN
	chemical_makeup = list(
		/decl/material/gas/water = 1
	)
	gas_tile_overlay = "generic"
	gas_overlay_limit = 0.5
	gas_specific_heat = 30
	gas_molar_mass = 0.020
	gas_condensation_point = 308.15 // 35C. Dew point is ~20C but this is better for gameplay considerations.
	gas_symbol_html = "H<sub>2</sub>O"
	gas_symbol = "H2O"
	scannable = 1
	metabolism = REM * 10
	taste_description = "water"
	glass_name = "water"
	glass_desc = "The father of all refreshments."
	chilling_products = list(/decl/material/gas/water/ice)
	chilling_point = T0C
	heating_products = list(/decl/material/gas/water/boiling)
	heating_point = T100C

/decl/material/gas/water/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(M, /mob/living/carbon/slime) || alien == IS_SLIME)
		M.adjustToxLoss(2 * removed)

/decl/material/gas/water/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjust_hydration(removed * 10)
	affect_blood(M, alien, removed, holder)

#define WATER_LATENT_HEAT 9500 // How much heat is removed when applied to a hot turf, in J/unit (9500 makes 120 u of water roughly equivalent to 2L
/decl/material/gas/water/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T20C + rand(0, 20) // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	var/volume = REAGENT_VOLUME(holder, type)
	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(volume >= 10)
		var/turf/simulated/S = T
		S.wet_floor(8, TRUE)

/decl/material/gas/water/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/item/chems/food/snacks/monkeycube))
		var/obj/item/chems/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/decl/material/gas/water/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M))
		var/needed = M.fire_stacks * 10
		if(amount > needed)
			M.fire_stacks = 0
			M.ExtinguishMob()
			holder.remove_reagent(type, needed)

		else
			M.adjust_fire_stacks(-(amount / 10))
			holder.remove_reagent(type, amount)

/decl/material/gas/water/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M, /mob/living/carbon/slime) && alien != IS_SLIME)
		return
	M.adjustToxLoss(10 * removed)	// Babies have 150 health, adults have 200; So, 15 units and 20
	var/mob/living/carbon/slime/S = M
	if(!S.client && istype(S))
		if(S.Target) // Like cats
			S.Target = null
		if(S.Victim)
			S.Feedstop()
	if(M.chem_doses[type] == removed)
		M.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")
		M.confused = max(M.confused, 2)

/decl/material/gas/water/holywater
	name = "holy water"
	lore_text = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#e0e8ef"
	glass_name = "holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	hidden_from_codex = TRUE

/decl/material/gas/water/holywater/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M)) // Any location
		if(iscultist(M))
			if(prob(10))
				GLOB.cult.offer_uncult(M)
			if(prob(2))
				var/obj/effect/spider/spiderling/S = new /obj/effect/spider/spiderling(M.loc)
				M.visible_message("<span class='warning'>\The [M] coughs up \the [S]!</span>")
		else if(M.mind && GLOB.godcult.is_antagonist(M.mind))
			if(REAGENT_VOLUME(holder, type) > 5)
				M.adjustHalLoss(5)
				M.adjustBruteLoss(1)
				if(prob(10)) //Only annoy them a /bit/
					to_chat(M,"<span class='danger'>You feel your insides curdle and burn!</span> \[<a href='?src=\ref[src];deconvert=\ref[M]'>Give Into Purity</a>\]")

/decl/material/gas/water/holywater/Topic(href, href_list)
	. = ..()
	if(!. && href_list["deconvert"])
		var/mob/living/carbon/C = locate(href_list["deconvert"])
		if(C.mind)
			GLOB.godcult.remove_antagonist(C.mind,1)

/decl/material/gas/water/holywater/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) >= 5)
		T.holy = 1
	return

/decl/material/gas/water/boiling
	name = "boiling water"
	chilling_products = list(/decl/material/gas/water)
	chilling_point =   99 CELSIUS
	chilling_message = "stops boiling."
	heating_products =  list(null)
	heating_point =    null
	hidden_from_codex = TRUE

/decl/material/gas/water/ice
	name = "ice"
	lore_text = "Frozen water, your dentist wouldn't like you chewing this."
	taste_description = "ice"
	taste_mult = 1.5
	color = "#619494"

	glass_name = "ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."
	glass_icon = DRINK_ICON_NOISY

	heating_message = "cracks and melts."
	heating_products = list(/decl/material/gas/water)
	heating_point = 299 // This is about 26C, higher than the actual melting point of ice but allows drinks to be made properly without weird workarounds.

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
	gas_flags = XGM_GAS_FUEL|XGM_GAS_FUSION_FUEL
	gas_burn_product = MAT_WATER
	gas_symbol_html = "H<sub>2</sub>"
	gas_symbol = "H2"
	chemical_makeup = list(
		/decl/material/chem/fuel/hydrazine = 1
	)

/decl/material/hydrogen/tritium
	name = "tritium"
	lore_text = "A radioactive isotope of hydrogen. Useful as a fusion reactor fuel material."
	mechanics_text = "Tritium is useable as a fuel in some forms of portable generator. It can also be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It fuses hotter than deuterium but is correspondingly more unstable."
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = "{'materials':5}"
	value = 1.5
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
	name = "metallic hydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#e6c5de"
	stack_origin_tech = "{'materials':6,'powerstorage':6,'magnets':5}"
	ore_smelts_to = MAT_TRITIUM
	ore_compresses_to = MAT_METALLIC_HYDROGEN
	ore_name = "raw hydrogen"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	value = 2
	gas_symbol_html = "H*"
	gas_symbol = "H*"
