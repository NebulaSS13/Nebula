/decl/material/pitchblende
	name = "pitchblende"
	ore_compresses_to = MAT_PITCHBLENDE
	color = "#917d1a"
	ore_smelts_to = MAT_URANIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "pitchblende"
	ore_scan_icon = "mineral_uncommon"
	stack_origin_tech = "{'materials':5}"
	xarch_source_mineral = /decl/material/chem/phosphorus
	ore_icon_overlay = "nugget"
	dissolves_into = list(
		/decl/material/chem/radium = 0.5,
		/decl/material/uranium = 0.5
	)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	value = 0.8
	sparse_material_weight = 8
	rich_material_weight = 10

/decl/material/graphite
	name = "graphite"
	ore_compresses_to = MAT_GRAPHITE
	color = "#444444"
	ore_name = "graphite"
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	dissolves_into = list(
		/decl/material/chem/carbon = 0.6,
		/decl/material/chem/toxin/plasticide = 0.2,
		/decl/material/chem/acetone = 0.2
	)
	value = 0.8
	sparse_material_weight = 35
	rich_material_weight = 20
	dirtiness = 15

/decl/material/quartz
	name = "quartz"
	ore_compresses_to = MAT_QUARTZ
	ore_name = "quartz"
	opacity = 0.5
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#effffe"
	dissolves_into = list(
		/decl/material/chem/silicon = 1
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	reflectiveness = MAT_VALUE_SHINY
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/pyrite
	name = "pyrite"
	ore_name = "pyrite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#ccc9a3"
	dissolves_into = list(
		/decl/material/chem/sulfur = 0.75,
		/decl/material/iron = 0.25
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_compresses_to = MAT_PYRITE
	reflectiveness = MAT_VALUE_SHINY
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/spodumene
	name = "spodumene"
	ore_compresses_to = MAT_SPODUMENE
	ore_name = "spodumene"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#e5becb"
	dissolves_into = list(
		/decl/material/chem/lithium = 1
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/cinnabar
	name = "cinnabar"
	ore_compresses_to = MAT_CINNABAR
	ore_name = "cinnabar"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#e54e4e"
	dissolves_into = list(
		/decl/material/chem/mercury = 1
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/phosphorite
	name = "phosphorite"
	ore_compresses_to = MAT_PHOSPHORITE
	ore_name = "phosphorite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#acad95"
	dissolves_into = list(
		/decl/material/chem/phosphorus = 1
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/sodium_chloride
	name = "sodium chloride"
	lore_text = "A salt made of sodium chloride. Commonly used to season food."
	ore_compresses_to = MAT_ROCK_SALT
	ore_name = "rock salt"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#d1c0bc"
	dissolves_into = list(
		/decl/material/chem/sodium = 1
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1
	overdose = REAGENTS_OVERDOSE
	taste_description = "salt"

/decl/material/potash
	name = "potash"
	ore_compresses_to = MAT_POTASH
	ore_name = "potash"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#b77464"
	dissolves_into = list(
		/decl/material/chem/potassium = 1
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/bauxite
	name = "bauxite"
	ore_name = "bauxite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#d8ad97"
	dissolves_into = list(
		/decl/material/aluminium = 1
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_smelts_to = MAT_ALUMINIUM
	ore_compresses_to = MAT_BAUXITE
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/sand
	name = "sand"
	stack_type = null
	color = "#e2dbb5"
	ore_smelts_to = MAT_GLASS
	ore_compresses_to = MAT_SANDSTONE
	ore_name = "sand"
	ore_icon_overlay = "dust"
	dissolves_into = list(
		/decl/material/chem/silicon = 1
	)
	value = 0.8

/decl/material/sand/clay
	name = "clay"
	color = COLOR_OFF_WHITE
	ore_name = "clay"
	ore_icon_overlay = "lump"
	ore_smelts_to = MAT_CERAMIC
	ore_compresses_to = MAT_CLAY
	value = 0.8

/decl/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	table_icon_base = "stone"
	color = "#e37108"
	shard_type = SHARD_SHARD
	hardness = MAT_VALUE_RIGID
	stack_origin_tech = "{'materials':2,'exoticmatter':2}"
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	flags = MAT_FLAG_FUSION_FUEL
	dissolves_into = list(
		/decl/material/chem/toxin/phoron = 1
	)
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_name = "phoron"
	ore_compresses_to = MAT_PHORON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_uncommon"
	xarch_source_mineral = /decl/material/chem/toxin/phoron
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

//Controls phoron and phoron based objects reaction to being in a turf over 200c -- Phoron's flashpoint.
/decl/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(MAT_PHORON, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)

/decl/material/phoron/supermatter
	name = "exotic matter"
	lore_text = "Hypercrystalline supermatter is a subset of non-baryonic 'exotic' matter. It is found mostly in the heart of large stars, and features heavily in bluespace technology."
	color = "#ffff00"
	radioactivity = 20
	stack_origin_tech = "{'bluespace':2,'materials':6,'exoticmatter':4}"
	stack_type = null
	luminescence = 3
	ore_compresses_to = null
	value = 3
	sparse_material_weight = null
	rich_material_weight = null
