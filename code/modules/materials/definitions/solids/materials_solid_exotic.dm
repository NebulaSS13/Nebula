/decl/material/solid/metallic_hydrogen
	name = "metallic hydrogen"
	lore_text = "When hydrogen is exposed to extremely high pressures and temperatures, such as at the core of gas giants like Jupiter, it can take on metallic properties and - more importantly - acts as a room temperature superconductor. Achieving solid metallic hydrogen at room temperature, though, has proven to be rather tricky."
	name = "metallic hydrogen"
	color = "#e6c5de"
	stack_origin_tech = "{'materials':6,'powerstorage':6,'magnets':5}"
	heating_products = list(
		/decl/material/gas/hydrogen/tritium =   0.7,
		/decl/material/gas/hydrogen/deuterium = 0.3
	)
	heating_point = 990
	ore_name = "raw hydrogen"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	value = 2
	gas_symbol_html = "H*"
	gas_symbol = "H*"
	flags = MAT_FLAG_FUSION_FUEL
	wall_name = "bulkhead"
	construction_difficulty = MAT_VALUE_HARD_DIY
	gas_specific_heat = 100
	gas_molar_mass = 0.002
	gas_flags = XGM_GAS_FUEL
	burn_product = /decl/material/liquid/water
	gas_symbol_html = "H<sub>2</sub>"
	gas_symbol = "H2"
	ore_type_value = ORE_EXOTIC
	ore_data_value = 4
	dissolves_into = list(
		/decl/material/liquid/fuel/hydrazine = 1
	)
	default_solid_form = /obj/item/stack/material/segment

/decl/material/solid/exotic_matter
	name = "exotic matter"
	lore_text = "Hypercrystalline supermatter is a subset of non-baryonic 'exotic' matter. It is found mostly in the heart of large stars, and features heavily in all kinds of fringe physics-defying technology."
	color = "#ffff00"
	radioactivity = 20
	stack_origin_tech = "{'wormholes':2,'materials':6,'exoticmatter':4}"
	luminescence = 3
	value = 3
	icon_base = 'icons/turf/walls/stone.dmi'
	wall_flags = 0
	table_icon_base = "stone"
	shard_type = SHARD_SHARD
	hardness = MAT_VALUE_RIGID
	flags = MAT_FLAG_FUSION_FUEL
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_SHINY
	ignition_point = FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE
	gas_specific_heat = 200	// J/(mol*K)
	gas_molar_mass = 0.405	// kg/mol
	gas_overlay_limit = 0.7
	gas_flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT
	gas_symbol_html = "Ex<sub>*</sub>"
	gas_symbol = "Ex*"
	taste_mult = 1.5
	toxicity = 30
	touch_met = 5
	fuel_value = 2
	vapor_products = list(
		/decl/material/solid/exotic_matter = 1
	)
	default_solid_form = /obj/item/stack/material/segment