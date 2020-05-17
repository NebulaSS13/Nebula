// Placeholders for compile purposes.
/material/gas
	display_name = null
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

/material/gas/boron
	display_name = "boron"
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	is_fusion_fuel = TRUE

/material/gas/lithium
	display_name = "lithium"
	lore_text = "A chemical element, used as antidepressant."
	chemical_makeup = list(
		/decl/reagent/lithium = 1
	)
	is_fusion_fuel = TRUE

/material/gas/oxygen
	display_name = "oxygen"
	lore_text = "An ubiquitous oxidizing agent."
	is_fusion_fuel = TRUE
	gas_specific_heat = 20	
	gas_molar_mass = 0.032	
	gas_flags = XGM_GAS_OXIDIZER | XGM_GAS_FUSION_FUEL
	gas_symbol_html = "O<sub>2</sub>"
	gas_symbol = "O2"

/material/gas/helium
	display_name = "helium"
	lore_text = "A noble gas. It makes your voice squeaky."
	chemical_makeup = list(
		/decl/reagent/helium = 1
	)
	is_fusion_fuel = TRUE
	gas_specific_heat = 80
	gas_molar_mass = 0.004
	gas_flags = XGM_GAS_FUSION_FUEL
	gas_symbol_html = "He"
	gas_symbol = "He"

/material/gas/carbon_dioxide
	display_name = "carbon dioxide"
	lore_text = "A byproduct of respiration."
	gas_specific_heat = 30	
	gas_molar_mass = 0.044	
	gas_symbol_html = "CO<sub>2</sub>"
	gas_symbol = "CO2"

/material/gas/carbon_monoxide
	display_name = "carbon monoxide"
	lore_text = "A highly poisonous gas."
	chemical_makeup = list(
		/decl/reagent/carbon_monoxide = 1
	)
	gas_specific_heat = 30
	gas_molar_mass = 0.028
	gas_symbol_html = "CO"
	gas_symbol = "CO"

/material/gas/methyl_bromide
	display_name = "methyl bromide"
	lore_text = "A once-popular fumigant and weedkiller."
	chemical_makeup = list(
		/decl/reagent/toxin/methyl_bromide = 1
	)
	gas_specific_heat = 42.59 
	gas_molar_mass = 0.095	  
	gas_symbol_html = "CH<sub>3</sub>Br"
	gas_symbol = "CH3Br"

/material/gas/sleeping_agent
	display_name = "sleeping agent"
	lore_text = "A mild sedative. Also known as laughing gas."
	chemical_makeup = list(
		/decl/reagent/nitrous_oxide = 1
	)
	gas_specific_heat = 40	
	gas_molar_mass = 0.044	
	gas_tile_overlay = "sleeping_agent"
	gas_overlay_limit = 1
	gas_flags = XGM_GAS_OXIDIZER //N2O is a powerful oxidizer
	gas_symbol_html = "N<sub>2</sub>O"
	gas_symbol = "N2O"

/material/gas/nitrogen
	display_name = "nitrogen"
	lore_text = "An ubiquitous noble gas."
	gas_specific_heat = 20	
	gas_molar_mass = 0.028	
	gas_symbol_html = "N<sub>2</sub>"
	gas_symbol = "N2"

/material/gas/nitrodioxide
	display_name = "nitrogen dioxide"
	chemical_makeup = list(
		/decl/reagent/toxin = 1
	)
	icon_colour = "#ca6409"
	gas_specific_heat = 37
	gas_molar_mass = 0.054
	gas_flags = XGM_GAS_OXIDIZER
	gas_symbol_html = "NO<sub>2</sub>"
	gas_symbol = "NO2"

/material/gas/nitricoxide
	display_name = "nitric oxide"
	gas_specific_heat = 10
	gas_molar_mass = 0.030
	gas_flags = XGM_GAS_OXIDIZER
	gas_symbol_html = "NO"
	gas_symbol = "NO"

/material/gas/methane
	display_name = "methane"
	gas_specific_heat = 30	
	gas_molar_mass = 0.016	
	gas_flags = XGM_GAS_FUEL
	gas_symbol_html = "CH<sub>4</sub>"
	gas_symbol = "CH4"

/material/gas/alien
	display_name = "alien gas"
	hidden_from_codex = TRUE
	gas_symbol_html = "X"
	gas_symbol = "X"

/material/gas/alien/New()
	var/num = rand(100,999)
	display_name = "compound #[num]"
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

/material/gas/argon
	display_name = "argon"
	lore_text = "Just when you need it, all of your supplies argon."
	gas_specific_heat = 10
	gas_molar_mass = 0.018
	gas_symbol_html = "Ar"
	gas_symbol = "Ar"

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/material/gas/krypton
	display_name = "krypton"
	gas_specific_heat = 5
	gas_molar_mass = 0.036
	gas_symbol_html = "Kr"
	gas_symbol = "Kr"

/material/gas/neon
	display_name = "neon"
	gas_specific_heat = 20
	gas_molar_mass = 0.01
	gas_symbol_html = "Ne"
	gas_symbol = "Ne"

/material/gas/xenon
	display_name = "xenon"
	chemical_makeup = list(
		/decl/reagent/nitrous_oxide/xenon = 1
	)
	gas_specific_heat = 3
	gas_molar_mass = 0.054
	gas_symbol_html = "Xe"
	gas_symbol = "Xe"

/material/gas/ammonia
	display_name = "ammonia"
	chemical_makeup = list(
		/decl/reagent/ammonia = 1
	)
	gas_specific_heat = 20
	gas_molar_mass = 0.017
	gas_symbol_html = "NH<sub>3</sub>"
	gas_symbol = "NH3"

/material/gas/chlorine
	display_name = "chlorine"
	chemical_makeup = list(
		/decl/reagent/toxin/chlorine = 1
	)
	icon_colour = "#c5f72d"
	gas_overlay_limit = 0.5
	gas_specific_heat = 5
	gas_molar_mass = 0.017
	gas_flags = XGM_GAS_CONTAMINANT
	gas_symbol_html = "Cl"
	gas_symbol = "Cl"

/material/gas/sulfurdioxide
	display_name = "sulfur dioxide"
	chemical_makeup = list(
		/decl/reagent/sulfur = 1
	)
	gas_specific_heat = 30
	gas_molar_mass = 0.044
	gas_symbol_html = "SO<sub>2</sub>"
	gas_symbol = "SO2"

/material/gas/water
	display_name = "water vapour"
	chemical_makeup = list(
		/decl/reagent/water = 1
	)
	gas_tile_overlay = "generic"
	gas_overlay_limit = 0.5
	gas_specific_heat = 30
	gas_molar_mass = 0.020
	gas_condensation_point = 308.15 // 35C. Dew point is ~20C but this is better for gameplay considerations.
	gas_symbol_html = "H<sub>2</sub>O"
	gas_symbol = "H2O"

/material/hydrogen
	display_name = "hydrogen"
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
	gas_burn_product = MAT_STEAM
	gas_symbol_html = "H<sub>2</sub>"
	gas_symbol = "H2"
	chemical_makeup = list(
		/decl/reagent/fuel/hydrazine = 1
	)

/material/hydrogen/tritium
	display_name = "tritium"
	lore_text = "A radioactive isotope of hydrogen. Useful as a fusion reactor fuel material."
	mechanics_text = "Tritium is useable as a fuel in some forms of portable generator. It can also be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It fuses hotter than deuterium but is correspondingly more unstable."
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = "{'materials':5}"
	value = 1.5
	gas_symbol_html = "T"
	gas_symbol = "T"

/material/hydrogen/deuterium
	display_name = "deuterium"
	lore_text = "One of the two stable isotopes of hydrogen; also known as heavy hydrogen. Useful as a chemically synthesised fusion reactor fuel material."
	mechanics_text = "Deuterium can be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It is the most 'basic' fusion fuel."
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = "{'materials':3}"
	gas_symbol_html = "D"
	gas_symbol = "D"

/material/hydrogen/metallic
	display_name = "metallic hydrogen"
	lore_text = "When hydrogen is exposed to extremely high pressures and temperatures, such as at the core of gas giants like Jupiter, it can take on metallic properties and - more importantly - acts as a room temperature superconductor. Achieving solid metallic hydrogen at room temperature, though, has proven to be rather tricky."
	display_name = "metallic hydrogen"
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
