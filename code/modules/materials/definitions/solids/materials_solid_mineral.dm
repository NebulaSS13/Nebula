/decl/material/solid/pitchblende
	name = "pitchblende"
	uid = "solid_pitchblende"
	color = "#917d1a"
	ore_result_amount = 1
	ore_spread_chance = 10
	ore_name = "pitchblende"
	ore_scan_icon = "mineral_uncommon"
	stack_origin_tech = @'{"materials":5}'
	xarch_source_mineral = /decl/material/solid/phosphorus
	ore_icon_overlay = "nugget"
	value = 0.8
	sparse_material_weight = 8
	rich_material_weight = 10
	dissolves_into = list(
		/decl/material/solid/metal/uranium = 0.6,
		/decl/material/solid/metal/radium  = 0.3,
		/decl/material/solid/slag          = 0.1
	)
	ore_type_value = ORE_NUCLEAR
	ore_data_value = 3

/decl/material/solid/graphite
	name = "graphite"
	codex_name = "loose graphite"
	uid = "solid_graphite"
	color = "#444444"
	ore_name = "graphite"
	ore_result_amount = 2
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	melting_point = 4074
	boiling_point = 4474
	ignition_point = 774
	accelerant_value = 0.8
	burn_product = /decl/material/gas/carbon_monoxide
	value = 0.8
	sparse_material_weight = 35
	rich_material_weight = 20
	dirtiness = 15
	burn_temperature = 1350 CELSIUS

	flags = MAT_FLAG_FISSIBLE
	neutron_cross_section = 30
	neutron_interactions = list(
		INTERACTION_SCATTER = 2000
	)
	moderation_target = 1500
	dissolves_into = list(
		/decl/material/solid/carbon = 0.6,
		/decl/material/liquid/plasticide = 0.2,
		/decl/material/liquid/acetone = 0.2
	)

/decl/material/solid/quartz
	name = "quartz"
	uid = "solid_quartz"
	ore_name = "quartz"
	opacity = 0.5
	ore_result_amount = 3
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	melting_point = 1744
	boiling_point = 2504
	color = "#effffe"
	reflectiveness = MAT_VALUE_SHINY
	sparse_material_weight = 3
	rich_material_weight = 1
	dissolves_into = list(
		/decl/material/solid/silicon = 1
	)

/decl/material/solid/pyrite
	name = "fool's gold"
	uid = "solid_pyrite"
	ore_name = "pyrite"
	ore_result_amount = 3
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

/decl/material/solid/spodumene
	name = "spodumene"
	uid = "solid_spodumene"
	ore_name = "spodumene"
	ore_result_amount = 3
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

/decl/material/solid/cinnabar
	name = "cinnabar"
	uid = "solid_cinnabar"
	ore_name = "cinnabar"
	ore_result_amount = 3
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

/decl/material/solid/phosphorite
	name = "phosphorite"
	uid = "solid_phosphorite"
	ore_name = "phosphorite"
	ore_result_amount = 3
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

/decl/material/solid/sodiumchloride
	name = "sodium chloride"
	uid = "solid_sodium_chloride"
	lore_text = "A chemical element, readily reacts with water."
	ore_name = "rock salt"
	ore_result_amount = 3
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
	solid_name = "salt"
	soup_hot_desc = null

/decl/material/solid/potash
	name = "potash"
	uid = "solid_potash"
	lore_text = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	ore_name = "potash"
	ore_result_amount = 3
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

/decl/material/solid/potassium/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/decl/material/solid/bauxite
	name = "bauxite"
	uid = "solid_bauxite"
	ore_name = "bauxite"
	ore_result_amount = 3
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

/decl/material/solid/sand
	name = "sand"
	uid = "solid_sand"
	color = "#e2dbb5"
	heating_products = list(/decl/material/solid/glass = 1)
	heating_point = 2000 CELSIUS
	heating_sound = null
	heating_message = null
	ore_compresses_to = /decl/material/solid/stone/sandstone
	ore_name = "sand"
	ore_icon_overlay = "dust"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.8
	hardness = MAT_VALUE_MALLEABLE
	integrity = 10
	dirtiness = 15
	dissolves_into = list(
		/decl/material/solid/silicon = 1
	)
	dug_drop_type = /obj/item/stack/material/ore/handful
	default_solid_form = /obj/item/stack/material/ore/handful
	can_backfill_turf_type = /turf/floor/natural/sand

/decl/material/solid/clay
	name = "clay"
	codex_name = "raw clay"
	uid = "solid_clay"
	color = "#807f7a"
	ore_name = "clay"
	ore_compresses_to = null
	ore_icon_overlay = "lump_large"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.8
	hardness = MAT_VALUE_MALLEABLE
	integrity = 10
	dirtiness = 10
	dug_drop_type = /obj/item/stack/material/lump/large
	default_solid_form = /obj/item/stack/material/lump/large
	bakes_into_material = /decl/material/solid/stone/pottery
	temperature_burn_milestone_material = TRUE
	melting_point = null // Clay is already almost a liquid...
	// lower than the temperature expected from a kiln so that clay can be used to make bricks to make a high-temperature kiln.
	bakes_into_at_temperature = 950 CELSIUS
	can_backfill_turf_type = /turf/floor/natural/clay

/decl/material/solid/soil
	name = "soil"
	codex_name = "soil"
	uid = "solid_soil"
	color = "#41311b"
	value = 0
	default_solid_form = /obj/item/stack/material/lump/large
	melting_point = null
	hardness = MAT_VALUE_MALLEABLE
	integrity = 10
	dirtiness = 30
	dug_drop_type = /obj/item/stack/material/lump/large
	tillable = TRUE
	can_backfill_turf_type = list(
		/turf/floor/natural/mud,
		/turf/floor/natural/dirt
	)

/decl/material/solid/hematite
	name = "hematite"
	uid = "solid_hematite"
	color = "#aa6666"
	heating_products = list(
		/decl/material/solid/metal/iron = 0.8,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 2
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = "hematite"
	ore_icon_overlay = "lump"
	value = 0.8
	sparse_material_weight = 35
	rich_material_weight = 20
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	ferrous = TRUE

/decl/material/solid/rutile
	name = "rutile"
	uid = "solid_rutile"
	color = "#d8ad97"
	heating_products = list(
		/decl/material/solid/metal/titanium = 0.8,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 2
	ore_spread_chance = 15
	ore_scan_icon = "mineral_uncommon"
	ore_name = "rutile"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_PRECIOUS
	ore_data_value = 2
	value = 0.8
	sparse_material_weight = 3
	rich_material_weight = 1

/decl/material/solid/tetrahedrite
	name = "tetrahedrite"
	uid = "solid_tetrahedrite"
	heating_products = list(
		/decl/material/solid/metal/copper = 0.4,
		/decl/material/solid/metal/silver = 0.4,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 2
	ore_spread_chance = 10
	ore_name = "tetrahedrite"
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	dissolves_into = list(
		/decl/material/solid/metal/copper = 0.5,
		/decl/material/solid/metal/silver = 0.5
	)

/decl/material/solid/magnetite
	name = "magnetite"
	uid = "solid_magnetite"
	color = "#aa6666"
	heating_products = list(
		/decl/material/solid/metal/iron = 0.8,
		/decl/material/solid/metal/copper = 0.1,
		/decl/material/solid/slag = 0.1
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 2
	ore_spread_chance = 20
	ore_scan_icon = "mineral_common"
	ore_name = "magnetite"
	ore_icon_overlay = "lump"
	value = 0.9
	sparse_material_weight = 20
	rich_material_weight = 10
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	dissolves_into = list(
		/decl/material/solid/metal/iron = 0.8,
		/decl/material/solid/metal/copper = 0.1,
		/decl/material/solid/sulfur = 0.1
	)

/decl/material/solid/chalcopyrite
	name = "chalcopyrite"
	uid = "solid_chalcopyrite"
	color = "#9e9357"
	heating_products = list(
		/decl/material/solid/metal/copper = 0.6,
		/decl/material/solid/slag = 0.4
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 2
	ore_spread_chance = 20
	ore_scan_icon = "mineral_common"
	ore_name = "chalcopyrite"
	ore_icon_overlay = "lump"
	value = 0.9
	sparse_material_weight = 20
	rich_material_weight = 10
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	dissolves_into = list(
		/decl/material/solid/metal/iron = 0.1,
		/decl/material/solid/metal/copper = 0.6,
		/decl/material/solid/sulfur = 0.3
	)

/decl/material/solid/densegraphite
	name = "dense graphite"
	uid = "solid_dense_graphite"
	color = "#2c2c2c"
	heating_products = list(
		/decl/material/solid/gemstone/diamond = 0.02,
		/decl/material/solid/carbon = 0.98
	)
	burn_temperature = 1750 CELSIUS
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "dense graphite"
	ore_result_amount = 2
	ore_spread_chance = 10
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 1.2
	sparse_material_weight = 10
	rich_material_weight = 5
	ignition_point = 774
	accelerant_value = 0.9
	dirtiness = 15
	dissolves_into = list(
		/decl/material/solid/carbon = 0.1,
		/decl/material/liquid/plasticide = 0.4,
		/decl/material/liquid/acetone = 0.4,
		/decl/material/solid/gemstone/diamond = 0.1
	)

/decl/material/solid/cassiterite
	name = "cassiterite"
	uid = "solid_cassiterite"
	color = "#a1a4cf"
	heating_products = list(
		/decl/material/solid/metal/tin = 0.7,
		/decl/material/solid/metal/tungsten = 0.2,
		/decl/material/solid/slag = 0.1
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "cassiterite"
	ore_result_amount = 3
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.9
	sparse_material_weight = 20
	rich_material_weight = 10
	dissolves_into = list(
		/decl/material/solid/metal/tin = 0.8,
		/decl/material/solid/metal/tungsten = 0.2
	)

/decl/material/solid/wolframite
	name = "wolframite"
	uid = "solid_wolframite"
	color = "#8184ac"
	heating_products = list(
		/decl/material/solid/metal/tin = 0.1,
		/decl/material/solid/metal/tungsten = 0.2,
		/decl/material/solid/metal/iron = 0.2,
		/decl/material/solid/slag = 0.5
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "wolframite"
	ore_result_amount = 2
	ore_spread_chance = 15
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.9
	sparse_material_weight = 15
	rich_material_weight = 10
	dissolves_into = list(
		/decl/material/solid/metal/tin = 0.1,
		/decl/material/solid/metal/tungsten = 0.6,
		/decl/material/solid/metal/iron = 0.3
	)

/decl/material/solid/sperrylite
	name = "sperrylite"
	uid = "solid_sperrylite"
	color = "#cfd0d8"
	heating_products = list(
		/decl/material/solid/metal/platinum = 0.5,
		/decl/material/solid/metal/iron = 0.1,
		/decl/material/solid/glass = 0.1,
		/decl/material/solid/slag = 0.3
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "sperrylite"
	ore_result_amount = 2
	ore_spread_chance = 15
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_PRECIOUS
	ore_data_value = 1
	value = 1.1
	sparse_material_weight = 10
	rich_material_weight = 5
	dissolves_into = list(
		/decl/material/solid/metal/platinum = 0.7,
		/decl/material/solid/metal/iron = 0.1,
		/decl/material/solid/glass = 0.1,
		/decl/material/solid/metal/titanium = 0.1
	)

/decl/material/solid/sphalerite
	name = "sphalerite"
	uid = "solid_sphalerite"
	color = "#aaaa9c"
	heating_products = list(
		/decl/material/solid/metal/zinc = 0.7,
		/decl/material/solid/metal/iron = 0.1,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "sphalerite"
	ore_result_amount = 3
	ore_spread_chance = 15
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.8
	sparse_material_weight = 25
	rich_material_weight = 15
	dissolves_into = list(
		/decl/material/solid/metal/zinc = 0.7,
		/decl/material/solid/metal/iron = 0.2,
		/decl/material/solid/silicon = 0.1
	)

/decl/material/solid/galena
	name = "galena"
	uid = "solid_galena"
	color = "#aaaa9c"
	heating_products = list(
		/decl/material/solid/metal/lead = 0.6,
		/decl/material/solid/metal/iron = 0.2,
		/decl/material/solid/metal/silver = 0.1,
		/decl/material/solid/slag = 0.1
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "galena"
	ore_result_amount = 2
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.8
	sparse_material_weight = 20
	rich_material_weight = 10
	dissolves_into = list(
		/decl/material/solid/metal/lead = 0.7,
		/decl/material/solid/metal/iron = 0.2,
		/decl/material/solid/metal/silver = 0.1
	)

/decl/material/solid/calaverite
	name = "calaverite"
	uid = "solid_calaverite"
	color = "#aaaa9c"
	heating_products = list(
		/decl/material/solid/metal/gold = 0.6,
		/decl/material/solid/metal/silver = 0.3,
		/decl/material/solid/slag = 0.1
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "calaverite"
	ore_result_amount = 2
	ore_spread_chance = 5
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_PRECIOUS
	ore_data_value = 1
	value = 0.8
	sparse_material_weight = 5
	rich_material_weight = 5
	dissolves_into = list(
		/decl/material/solid/metal/gold = 0.7,
		/decl/material/solid/metal/silver = 0.3
	)

/decl/material/solid/crocoite
	name = "crocoite"
	uid = "solid_crocoite"
	color = "#fa672c"
	heating_products = list(
		/decl/material/solid/metal/chromium = 0.3,
		/decl/material/solid/metal/lead = 0.4,
		/decl/material/solid/slag = 0.3
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "crocoite"
	ore_result_amount = 3
	ore_spread_chance = 5
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_PRECIOUS
	ore_data_value = 1
	value = 0.9
	sparse_material_weight = 5
	rich_material_weight = 10
	dissolves_into = list(
		/decl/material/solid/metal/chromium = 0.6,
		/decl/material/solid/metal/lead = 0.4
	)

/decl/material/solid/borax
	name = "borax"
	uid = "solid_borax"
	color = "#a9aa81"
	heating_products = list(
		/decl/material/solid/boron = 0.8,
		/decl/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_name = "borax"
	ore_result_amount = 3
	ore_spread_chance = 5
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "lump"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	value = 0.5
	sparse_material_weight = 4
	rich_material_weight = 2
