/decl/material/solid/mineral
	stack_type = /obj/item/stack/material/generic/brick

/decl/material/solid/mineral/pitchblende
	name = "pitchblende"
	color = "#917d1a"
	heating_products = list(
		/decl/material/solid/metal/uranium = 0.8,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "pitchblende"
	ore_scan_icon = "mineral_uncommon"
	stack_origin_tech = "{'materials':5}"
	xarch_source_mineral = /decl/material/solid/phosphorus
	ore_icon_overlay = "nugget"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	value = 0.8
	sparse_material_weight = 8
	rich_material_weight = 10
	dissolves_into = list(
		/decl/material/solid/metal/uranium = 0.5,
		/decl/material/solid/metal/radium = 0.5
	)
	ore_type_value = ORE_NUCLEAR
	ore_data_value = 3

/decl/material/solid/mineral/graphite
	name = "graphite"
	color = "#444444"
	ore_name = "graphite"
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.8
	sparse_material_weight = 35
	rich_material_weight = 20
	fuel_value = 0.8
	dirtiness = 15
	dissolves_into = list(
		/decl/material/solid/carbon = 0.6,
		/decl/material/liquid/plasticide = 0.2,
		/decl/material/liquid/acetone = 0.2
	)

/decl/material/solid/mineral/quartz
	name = "quartz"
	ore_name = "quartz"
	opacity = 0.5
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#effffe"
	reflectiveness = MAT_VALUE_SHINY
	sparse_material_weight = 3
	rich_material_weight = 1
	dissolves_into = list(
		/decl/material/solid/silicon = 1
	)

/decl/material/solid/mineral/pyrite
	name = "pyrite"
	ore_name = "pyrite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#ccc9a3"
	reflectiveness = MAT_VALUE_SHINY
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1
	dissolves_into = list(
		/decl/material/solid/sulfur = 0.75,
		/decl/material/solid/metal/iron = 0.25		
	)

/decl/material/solid/mineral/spodumene
	name = "spodumene"
	ore_name = "spodumene"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#e5becb"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1
	dissolves_into = list(
		/decl/material/solid/lithium = 1
	)

/decl/material/solid/mineral/cinnabar
	name = "cinnabar"
	ore_name = "cinnabar"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#e54e4e"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1
	dissolves_into = list(
		/decl/material/liquid/mercury = 1
	)

/decl/material/solid/mineral/phosphorite
	name = "phosphorite"
	ore_name = "phosphorite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	dissolves_into = list(
		/decl/material/solid/phosphorus = 1
	)
	color = "#832828"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1
	lore_text = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"

/decl/material/solid/mineral/sodiumchloride
	name = "sodium chloride"
	lore_text = "A chemical element, readily reacts with water."
	ore_name = "rock salt"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#d1c0bc"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1
	taste_description = "salt"
	overdose = REAGENTS_OVERDOSE
	dissolves_into = list(
		/decl/material/solid/sodium = 1
	)

/decl/material/solid/mineral/potash
	name = "potash"
	lore_text = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	ore_name = "potash"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#b77464"
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	dissolves_into = list(
		/decl/material/solid/potassium = 1
	)

/decl/material/solid/mineral/potassium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/decl/material/solid/mineral/bauxite
	name = "bauxite"
	ore_name = "bauxite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	color = "#d8ad97"
	heating_products = list(
		/decl/material/solid/metal/aluminium = 0.8,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1
	dissolves_into = list(
		/decl/material/solid/metal/aluminium = 1
	)

/decl/material/solid/mineral/sand
	name = "sand"
	stack_type = null
	color = "#e2dbb5"
	heating_products = list(/decl/material/solid/glass = 1)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_compresses_to = /decl/material/solid/stone/sandstone
	ore_name = "sand"
	ore_icon_overlay = "dust"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.8
	dirtiness = 15
	dissolves_into = list(
		/decl/material/solid/silicon = 1
	)

/decl/material/solid/mineral/clay
	name = "clay"
	stack_type = null
	color = COLOR_OFF_WHITE
	ore_name = "clay"
	ore_icon_overlay = "lump"
	heating_products = list(/decl/material/solid/stone/ceramic = 1)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_compresses_to = null
	ore_icon_overlay = "dust"
	value = 0.8

/decl/material/solid/mineral/hematite
	name = "hematite"
	stack_type = null
	color = "#aa6666"
	heating_products = list(
		/decl/material/solid/metal/iron = 0.8,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = "hematite"
	ore_icon_overlay = "lump"
	value = 0.8
	sparse_material_weight = 35
	rich_material_weight = 20
	ore_type_value = ORE_SURFACE
	ore_data_value = 1

/decl/material/solid/mineral/rutile
	name = "rutile"
	stack_type = null
	color = "#d8ad97"
	heating_products = list(
		/decl/material/solid/metal/titanium = 0.8,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 5
	ore_spread_chance = 15
	ore_scan_icon = "mineral_uncommon"
	ore_name = "rutile"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_PRECIOUS
	ore_data_value = 2
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/solid/mineral/tetrahedrite
	name = "tetrahedrite"
	heating_products = list(
		/decl/material/solid/metal/copper = 0.4,
		/decl/material/solid/metal/silver = 0.4,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "tetrahedrite"
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	dissolves_into = list(
		/decl/material/solid/metal/copper = 0.5,
		/decl/material/solid/metal/silver = 0.5
	)