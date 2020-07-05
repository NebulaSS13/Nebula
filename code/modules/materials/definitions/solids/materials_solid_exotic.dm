/decl/material/solid/metallic_hydrogen
	name = "metallic hydrogen"
	lore_text = "When hydrogen is exposed to extremely high pressures and temperatures, such as at the core of gas giants like Jupiter, it can take on metallic properties and - more importantly - acts as a room temperature superconductor. Achieving solid metallic hydrogen at room temperature, though, has proven to be rather tricky."
	name = "metallic hydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	color = "#e6c5de"
	stack_origin_tech = "{'materials':6,'powerstorage':6,'magnets':5}"
	ore_smelts_to = /decl/material/gas/hydrogen/tritium
	ore_name = "raw hydrogen"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	value = 2
	gas_symbol_html = "H*"
	gas_symbol = "H*"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	flags = MAT_FLAG_FUSION_FUEL
	wall_name = "bulkhead"
	construction_difficulty = MAT_VALUE_HARD_DIY
	gas_specific_heat = 100
	gas_molar_mass = 0.002
	gas_flags = XGM_GAS_FUEL
	gas_burn_product = /decl/material/liquid/water
	gas_symbol_html = "H<sub>2</sub>"
	gas_symbol = "H2"
	dissolves_into = list(
		/decl/material/liquid/fuel/hydrazine = 1
	)

/decl/material/solid/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	table_icon_base = "stone"
	color = "#e37108"
	shard_type = SHARD_SHARD
	hardness = MAT_VALUE_RIGID
	stack_origin_tech = "{'materials':2,'exoticmatter':2}"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	flags = MAT_FLAG_FUSION_FUEL
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_name = "phoron"
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_uncommon"
	xarch_source_mineral = /decl/material/solid/phoron
	ore_icon_overlay = "gems"
	//Note that this has a significant impact on TTV yield.
	//Because it is so high, any leftover phoron soaks up a lot of heat and drops the yield pressure.
	gas_specific_heat = 200	// J/(mol*K)
	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	gas_molar_mass = 0.405	// kg/mol
	gas_overlay_limit = 0.7
	gas_flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT
	gas_symbol_html = "Ph"
	gas_symbol = "Ph"
	reflectiveness = MAT_VALUE_SHINY
	value = 1.6
	sparse_material_weight = 10
	rich_material_weight = 20
	taste_mult = 1.5
	toxicity = 30
	touch_met = 5
	fuel_value = 2
	vapor_products = list(
		/decl/material/solid/phoron = 1
	)

//Controls phoron and phoron based objects reaction to being in a turf over 200c -- Phoron's flashpoint.
/decl/material/solid/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(/decl/material/solid/phoron, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)

/decl/material/solid/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(10 * fuel_value))
		M.handle_contaminants()

/decl/material/solid/supermatter
	name = "exotic matter"
	lore_text = "Hypercrystalline supermatter is a subset of non-baryonic 'exotic' matter. It is found mostly in the heart of large stars, and features heavily in all kinds of fringe physics-defying technology."
	color = "#ffff00"
	radioactivity = 20
	stack_origin_tech = "{'bluespace':2,'materials':6,'exoticmatter':4}"
	luminescence = 3
	value = 3
	icon_base = "stone"
	table_icon_base = "stone"
	shard_type = SHARD_SHARD
	hardness = MAT_VALUE_RIGID
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	flags = MAT_FLAG_FUSION_FUEL
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_SHINY
