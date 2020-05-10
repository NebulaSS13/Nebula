/material/uranium
	display_name = "uranium"
	lore_text = "A highly radioactive metal. Commonly used as fuel in fission reactors."
	mechanics_text = "Uranium ingots are used as fuel in some forms of portable generator."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	door_icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007a00"
	weight = MAT_VALUE_HEAVY
	stack_origin_tech = "{'materials':5}"
	chem_products = list(
				/decl/reagent/uranium = 20
				)
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_MATTE
	value = 1.5
	removed_by_welder = TRUE

/material/gold
	display_name = "gold"
	lore_text = "A heavy, soft, ductile metal. Once considered valuable enough to back entire currencies, now predominantly used in corrosion-resistant electronics."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/gold
	icon_colour = COLOR_GOLD
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_FLEXIBLE + 5
	integrity = 100
	stack_origin_tech = "{'materials':4}"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/decl/reagent/gold = 20
				)
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_SHINY
	ore_smelts_to = MAT_GOLD
	ore_result_amount = 5
	ore_name = "native gold"
	ore_spread_chance = 10
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "nugget"
	value = 1.6
	removed_by_welder = TRUE

/material/gold/bronze //placeholder for ashtrays
	display_name = "bronze"
	lore_text = "An alloy of copper and tin."
	reflectiveness = MAT_VALUE_SHINY
	icon_colour = "#edd12f"
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_smelts_to = null
	ore_compresses_to = null
	value = 1.2

/material/copper
	display_name = "copper"
	wall_name = "bulkhead"
	icon_colour = COLOR_COPPER
	weight = MAT_VALUE_NORMAL
	hardness = MAT_VALUE_FLEXIBLE + 10
	reflectiveness = MAT_VALUE_SHINY
	stack_origin_tech = "{'materials':2}"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
		/decl/reagent/copper = 12,
		/decl/reagent/silver = 8
		)
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_smelts_to = MAT_COPPER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "tetrahedrite"
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	removed_by_welder = TRUE

/material/silver
	display_name = "silver"
	lore_text = "A soft, white, lustrous transition metal. Has many and varied industrial uses in electronics, solar panels and mirrors."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#d1e6e3"
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_FLEXIBLE + 10
	reflectiveness = MAT_VALUE_SHINY
	stack_origin_tech = "{'materials':3}"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/decl/reagent/silver = 20
				)
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_smelts_to = MAT_SILVER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "native silver"
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"
	removed_by_welder = TRUE
	value = 1.2

/material/steel
	display_name = "steel"
	lore_text = "A strong, flexible alloy of iron and carbon. Probably the single most fundamentally useful and ubiquitous substance in human space."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/steel
	weight = MAT_VALUE_NORMAL
	integrity = 150
	brute_armor = 5
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_STEEL
	hitsound = 'sound/weapons/smash.ogg'
	chem_products = list(
				/decl/reagent/iron = 19.6,
				/decl/reagent/carbon = 0.4
				)
	alloy_materials = list(MAT_IRON = 1875, MAT_GRAPHITE = 1875)
	alloy_product = TRUE
	ore_smelts_to = MAT_STEEL
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE
	value = 1.1

/material/steel/holographic
	display_name = "holographic steel"
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE
	hidden_from_codex = TRUE
	value = 0

/material/steel/holographic/get_recipes(reinf_mat)
	return list()

/material/aluminium
	display_name = "aluminium"
	lore_text = "A low-density ductile metal with a silvery-white sheen."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/aluminium
	chem_products = list(
				/decl/reagent/aluminium = 20
				)
	integrity = 125
	weight = MAT_VALUE_LIGHT
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#cccdcc"
	hitsound = 'sound/weapons/smash.ogg'
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE

/material/aluminium/holographic
	display_name = "holoaluminium"
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE
	hidden_from_codex = TRUE

/material/aluminium/holographic/get_recipes(reinf_mat)
	return list()

/material/plasteel
	display_name = "plasteel"
	lore_text = "An alloy of steel and platinum. When regular high-tensile steel isn't tough enough to get the job done, the smart consumer turns to frankly absurd alloys of steel and platinum."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#a8a9b2"
	explosion_resistance = 25
	brute_armor = 6
	burn_armor = 10
	hardness = MAT_VALUE_VERY_HARD
	weight = MAT_VALUE_HEAVY
	stack_origin_tech = "{'materials':2}"
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_HARD_DIY
	alloy_materials = list(MAT_STEEL = 2500, MAT_PLATINUM = 1250)
	alloy_product = TRUE
	ore_smelts_to = MAT_PLASTEEL
	value = 1.4
	reflectiveness = MAT_VALUE_MATTE
	removed_by_welder = TRUE

/material/plasteel/titanium
	display_name = "titanium"
	lore_text = "A light, strong, corrosion-resistant metal. Perfect for cladding high-velocity ballistic supply pods."
	brute_armor = 10
	burn_armor = 8
	integrity = 200
	melting_point = 3000
	weight = MAT_VALUE_LIGHT
	stack_type = /obj/item/stack/material/titanium
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#d1e6e3"
	icon_reinf = "reinf_metal"
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	alloy_materials = null
	alloy_product = FALSE
	reflectiveness = MAT_VALUE_SHINY
	value = 1.5

/material/plasteel/ocp
	display_name = "osmium-carbide plasteel"
	stack_type = /obj/item/stack/material/ocp
	integrity = 200
	melting_point = 12000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#9bc6f2"
	brute_armor = 4
	burn_armor = 20
	weight = MAT_VALUE_HEAVY
	stack_origin_tech = "{'materials':3}"
	alloy_materials = list(MAT_PLASTEEL = 7500, MAT_OSMIUM = 3750)
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	alloy_product = TRUE
	reflectiveness = MAT_VALUE_SHINY
	value = 1.8

/material/osmium
	display_name = "osmium"
	lore_text = "An extremely hard form of platinum."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999ff"
	stack_origin_tech = "{'materials':5}"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	ore_smelts_to = MAT_OSMIUM
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE
	value = 1.3

/material/platinum
	display_name = "platinum"
	lore_text = "A very dense, unreactive, precious metal. Has many industrial uses, particularly as a catalyst."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#deddff"
	weight = MAT_VALUE_VERY_HEAVY
	stack_origin_tech = "{'materials':2}"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_smelts_to = MAT_PLATINUM
	ore_compresses_to = MAT_OSMIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "raw platinum"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "shiny"
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE
	value = 1.5

/material/iron
	display_name = "iron"
	lore_text = "A ubiquitous, very common metal. The epitaph of stars and the primary ingredient in Earth's core."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5c5454"
	weight = MAT_VALUE_HEAVY
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	chem_products = list(
				/decl/reagent/iron = 20
				)
	reflectiveness = MAT_VALUE_MATTE
	removed_by_welder = TRUE

// Adminspawn only, do not let anyone get this.
/material/voxalloy
	display_name = "dense alloy"
	wall_name = "bulkhead"
	stack_type = null
	icon_colour = "#6c7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	construction_difficulty = MAT_VALUE_HARD_DIY
	hidden_from_codex = TRUE
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE
	value = 3

// Likewise.
/material/voxalloy/elevatorium
	display_name = "elevator panelling"
	wall_name = "bulkhead"
	icon_colour = "#666666"
	construction_difficulty = MAT_VALUE_HARD_DIY
	hidden_from_codex = TRUE

/material/aliumium
	display_name = "alien alloy"
	wall_name = "bulkhead"
	stack_type = null
	icon_base = "jaggy"
	door_icon_base = "metal"
	icon_reinf = "reinf_metal"
	hitsound = 'sound/weapons/smash.ogg'
	sheet_singular_name = "chunk"
	sheet_plural_name = "chunks"
	stack_type = /obj/item/stack/material/aliumium
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	hidden_from_codex = TRUE
	removed_by_welder = TRUE
	value = 2.5

/material/aliumium/New()
	icon_base = "metal"
	icon_colour = rgb(rand(10,150),rand(10,150),rand(10,150))
	explosion_resistance = rand(25,40)
	brute_armor = rand(10,20)
	burn_armor = rand(10,20)
	hardness = rand(15,100)
	reflectiveness = rand(15,100)
	integrity = rand(200,400)
	melting_point = rand(400,10000)
	..()

/material/aliumium/place_dismantled_girder(var/turf/target, var/material/reinf_material)
	return

/material/hematite
	display_name = "hematite"
	wall_name = "bulkhead"
	stack_type = null
	icon_colour = "#aa6666"
	ore_smelts_to = MAT_IRON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = "hematite"
	ore_icon_overlay = "lump"
	removed_by_welder = TRUE
	value = 0.8

/material/rutile
	display_name = "rutile"
	wall_name = "bulkhead"
	stack_type = null
	icon_colour = "#d8ad97"
	ore_smelts_to = MAT_TITANIUM
	ore_result_amount = 5
	ore_spread_chance = 15
	ore_scan_icon = "mineral_uncommon"
	ore_name = "rutile"
	ore_icon_overlay = "lump"
	removed_by_welder = TRUE
	value = 0.8