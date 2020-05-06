/decl/material/uranium
	name = "uranium"
	lore_text = "A silvery-white metallic chemical element in the actinide series, somewhat radioactive."
	mechanics_text = "Uranium ingots are used as fuel in some forms of portable generator."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 0.8
	icon_base = "stone"
	door_icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007a00"
	weight = MAT_VALUE_HEAVY
	stack_origin_tech = "{'materials':5}"
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_MATTE
	sale_price = 2
	value = 100
	removed_by_welder = TRUE
	taste_description = "the inside of a reactor"

/decl/material/uranium/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_ingest(M, alien, removed, holder)

/decl/material/uranium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.apply_damage(5 * removed, IRRADIATE, armor_pen = 100)

/decl/material/uranium/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/decl/material/gold
	name = "gold"
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
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_SHINY
	ore_smelts_to = MAT_GOLD
	ore_result_amount = 5
	ore_name = "native gold"
	ore_spread_chance = 10
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "nugget"
	sale_price = 3
	removed_by_welder = TRUE
	taste_description = "expensive metal"
	value = 1.5

/decl/material/bronze //placeholder for ashtrays
	name = "bronze"
	lore_text = "An alloy of copper and tin."
	icon_colour = "#edd12f"
	sale_price = null
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/generic
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_FLEXIBLE + 5
	integrity = 100
	stack_origin_tech = "{'materials':4}"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE
	taste_description = "metal"
	value = 1.5

/decl/material/copper
	name = "copper"
	wall_name = "bulkhead"
	lore_text = "A highly ductile metal."
	taste_description = "copper"
	value = 0.5
	icon_colour = "#b87333"
	weight = MAT_VALUE_NORMAL
	hardness = MAT_VALUE_FLEXIBLE + 10
	reflectiveness = MAT_VALUE_SHINY
	stack_origin_tech = "{'materials':2}"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_smelts_to = MAT_COPPER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "tetrahedrite"
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	sale_price = 1
	removed_by_welder = TRUE

/decl/material/silver
	name = "silver"
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
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_smelts_to = MAT_SILVER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "native silver"
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"
	sale_price = 2
	value = 35
	removed_by_welder = TRUE
	taste_description = "expensive yet reasonable metal"

/decl/material/steel
	name = "steel"
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
	alloy_materials = list(
		MAT_IRON = 1875, 
		MAT_GRAPHITE = 1875
	)
	alloy_product = TRUE
	sale_price = 1
	ore_smelts_to = MAT_STEEL
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_SHINY
	value = 4
	removed_by_welder = TRUE

/decl/material/steel/holographic
	name = "holographic steel"
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE
	sale_price = null
	hidden_from_codex = TRUE
	value = 0

/decl/material/steel/holographic/get_recipes(reinf_mat)
	return list()

/decl/material/aluminium
	name = "aluminium"
	lore_text = "A low-density ductile metal with a silvery-white sheen."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/aluminium
	integrity = 125
	weight = MAT_VALUE_LIGHT
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#cccdcc"
	hitsound = 'sound/weapons/smash.ogg'
	sale_price = 1
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE
	taste_description = "metal"
	taste_mult = 1.1
	value = 0.5

/decl/material/aluminium/holographic
	name = "holoaluminium"
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE
	sale_price = null
	hidden_from_codex = TRUE

/decl/material/aluminium/holographic/get_recipes(reinf_mat)
	return list()

/decl/material/plasteel
	name = "plasteel"
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
	sale_price = 2
	ore_smelts_to = MAT_PLASTEEL
	value = 12
	reflectiveness = MAT_VALUE_MATTE
	removed_by_welder = TRUE

/decl/material/plasteel/titanium
	name = "titanium"
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
	value = 30
	reflectiveness = MAT_VALUE_SHINY

/decl/material/plasteel/ocp
	name = "osmium-carbide plasteel"
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
	sale_price = 3
	reflectiveness = MAT_VALUE_SHINY

/decl/material/osmium
	name = "osmium"
	lore_text = "An extremely hard form of platinum."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999ff"
	stack_origin_tech = "{'materials':5}"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	sale_price = 3
	ore_smelts_to = MAT_OSMIUM
	value = 30
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE

/decl/material/platinum
	name = "platinum"
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
	sale_price = 5
	value = 80
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE

/decl/material/iron
	name = "iron"
	lore_text = "A ubiquitous, very common metal. The epitaph of stars and the primary ingredient in Earth's core."
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#353535"
	weight = MAT_VALUE_HEAVY
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	sale_price = 1
	value = 5
	reflectiveness = MAT_VALUE_MATTE
	removed_by_welder = TRUE
	taste_description = "tangy metal"
	value = 0.5

/decl/material/iron/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

// Adminspawn only, do not let anyone get this.
/decl/material/voxalloy
	name = "dense alloy"
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
	value = 100
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE

// Likewise.
/decl/material/voxalloy/elevatorium
	name = "elevator panelling"
	wall_name = "bulkhead"
	icon_colour = "#666666"
	construction_difficulty = MAT_VALUE_HARD_DIY
	hidden_from_codex = TRUE

/decl/material/aliumium
	name = "alien alloy"
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

/decl/material/aliumium/New()
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

/decl/material/aliumium/place_dismantled_girder(var/turf/target, var/decl/material/reinf_material)
	return

/decl/material/hematite
	name = "hematite"
	wall_name = "bulkhead"
	stack_type = null
	icon_colour = "#aa6666"
	ore_smelts_to = MAT_IRON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = "hematite"
	ore_icon_overlay = "lump"
	sale_price = 1
	removed_by_welder = TRUE

/decl/material/rutile
	name = "rutile"
	wall_name = "bulkhead"
	stack_type = null
	icon_colour = "#d8ad97"
	ore_smelts_to = MAT_TITANIUM
	ore_result_amount = 5
	ore_spread_chance = 15
	ore_scan_icon = "mineral_uncommon"
	ore_name = "rutile"
	ore_icon_overlay = "lump"
	sale_price = 2
	removed_by_welder = TRUE
