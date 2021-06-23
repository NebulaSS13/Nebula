/decl/material/solid/metal
	name = null
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_SHINY
	removed_by_welder = TRUE
	wall_name = "bulkhead"
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_RIGID
	wall_support_value = MAT_VALUE_HEAVY
	wall_blend_icons = list(
		'icons/turf/walls/wood.dmi' = TRUE,
		'icons/turf/walls/stone.dmi' = TRUE
	)
	default_solid_form = /obj/item/stack/material/ingot
	table_icon_base = "metal"

/decl/material/solid/metal/uranium
	name = "uranium"
	lore_text = "A silvery-white metallic chemical element in the actinide series, weakly radioactive. Commonly used as fuel in fission reactors."
	mechanics_text = "Uranium ingots are used as fuel in some forms of portable generator."
	taste_description = "the inside of a reactor"
	radioactivity = 12
	icon_base = 'icons/turf/walls/stone.dmi'
	wall_flags = 0
	table_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	color = "#007a00"
	stack_origin_tech = "{'materials':5}"
	reflectiveness = MAT_VALUE_MATTE
	value = 1.5
	default_solid_form = /obj/item/stack/material/puck

/decl/material/solid/metal/radium
	name = "radium"
	lore_text = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_description = "the color blue, and regret"
	color = "#c7c7c7"
	value = 0.5
	radioactivity = 18

/decl/material/solid/metal/gold
	name = "gold"
	lore_text = "A heavy, soft, ductile metal. Once considered valuable enough to back entire currencies, now predominantly used in corrosion-resistant electronics."
	color = COLOR_GOLD
	hardness = MAT_VALUE_FLEXIBLE + 5
	integrity = 100
	stack_origin_tech = "{'materials':4}"
	ore_result_amount = 5
	ore_name = "native gold"
	ore_spread_chance = 10
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "nugget"
	value = 1.6
	sparse_material_weight = 8
	rich_material_weight = 10
	ore_type_value = ORE_PRECIOUS
	ore_data_value = 2

/decl/material/solid/metal/bronze
	name = "bronze"
	lore_text = "An alloy of copper and tin. Once used in weapons and laboring tools."
	color = "#ccbc63"
	brute_armor = 3
	hardness = MAT_VALUE_RIGID + 10
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
	value = 1.2
	default_solid_form = /obj/item/stack/material/sheet

/decl/material/solid/metal/blackbronze
	name = "black bronze"
	lore_text = "An alloy of copper and silver. Used in ancient ceremonial gear."
	color = "#3f352a"
	brute_armor = 4
	hardness = MAT_VALUE_HARD
	reflectiveness = MAT_VALUE_MATTE
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
	value = 1.4

/decl/material/solid/metal/redgold
	name = "red gold"
	lore_text = "An alloy of copper and gold. A soft metal used for its ornamental properties."
	color = "#ff7a59"
	reflectiveness = MAT_VALUE_SHINY
	value = 1.4

/decl/material/solid/metal/brass
	name = "brass"
	lore_text = "An alloy of copper and zinc. Renowned for its golden color."
	color = "#dab900"
	reflectiveness = MAT_VALUE_VERY_SHINY
	value = 1.2
	default_solid_form = /obj/item/stack/material/sheet

/decl/material/solid/metal/copper
	name = "copper"
	lore_text = "A metal used in some components and many alloys. Known for its color-shifting properties when oxidized."
	color = COLOR_COPPER
	weight = MAT_VALUE_NORMAL
	hardness = MAT_VALUE_FLEXIBLE + 10
	stack_origin_tech = "{'materials':2}"

/decl/material/solid/metal/silver
	name = "silver"
	lore_text = "A soft, white, lustrous transition metal. Has many and varied industrial uses in electronics, solar panels and mirrors."
	color = "#d1e6e3"
	hardness = MAT_VALUE_FLEXIBLE + 10
	stack_origin_tech = "{'materials':3}"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "native silver"
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"
	value = 1.2
	sparse_material_weight = 8
	rich_material_weight = 10
	ore_type_value = ORE_PRECIOUS
	ore_data_value = 2

/decl/material/solid/metal/steel
	name = "steel"
	lore_text = "A strong, flexible alloy of iron and carbon. Probably the single most fundamentally useful and ubiquitous substance in human space."
	weight = MAT_VALUE_NORMAL
	wall_support_value = MAT_VALUE_VERY_HEAVY // Ideal construction material.
	integrity = 150
	brute_armor = 5
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
	color = COLOR_STEEL
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	value = 1.1
	dissolves_into = list(
		/decl/material/solid/metal/iron = 0.98,
		/decl/material/solid/carbon = 0.02
	)
	default_solid_form = /obj/item/stack/material/sheet

/decl/material/solid/metal/steel/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe_list("office chairs",list(
		new/datum/stack_recipe/furniture/chair/office/dark(src),
		new/datum/stack_recipe/furniture/chair/office/light(src)
		))
	. += new/datum/stack_recipe_list("comfy office chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/office/comfy))
	. += new/datum/stack_recipe_list("comfy chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/comfy))
	. += new/datum/stack_recipe_list("armchairs", create_recipe_list(/datum/stack_recipe/furniture/chair/arm))
	. += new/datum/stack_recipe/key(src)
	. += new/datum/stack_recipe/furniture/table_frame(src)
	. += new/datum/stack_recipe/furniture/rack(src)
	. += new/datum/stack_recipe/furniture/closet(src)
	. += new/datum/stack_recipe/furniture/canister(src)
	. += new/datum/stack_recipe/furniture/tank(src)
	. += new/datum/stack_recipe/cannon(src)
	. += create_recipe_list(/datum/stack_recipe/tile/metal)
	. += new/datum/stack_recipe/furniture/computerframe(src)
	. += new/datum/stack_recipe/furniture/machine(src)
	. += new/datum/stack_recipe/furniture/turret(src)
	. += new/datum/stack_recipe_list("airlock assemblies", create_recipe_list(/datum/stack_recipe/furniture/door_assembly))
	. += new/datum/stack_recipe/grenade(src)
	. += new/datum/stack_recipe/light(src)
	. += new/datum/stack_recipe/light_small(src)
	. += new/datum/stack_recipe/light_switch(src)
	. += new/datum/stack_recipe/light_switch/windowtint(src)
	. += new/datum/stack_recipe/apc(src)
	. += new/datum/stack_recipe/air_alarm(src)
	. += new/datum/stack_recipe/fire_alarm(src)
	. += new/datum/stack_recipe_list("modular computer frames", create_recipe_list(/datum/stack_recipe/computer))
	. += new/datum/stack_recipe/furniture/coffin(src)
	. += new/datum/stack_recipe/butcher_hook(src)

/decl/material/solid/metal/steel/holographic
	name = "holographic steel"
	shard_type = SHARD_NONE
	conductive = 0
	hidden_from_codex = TRUE
	value = 0

/decl/material/solid/metal/steel/holographic/get_recipes(reinf_mat)
	return list()

/decl/material/solid/metal/stainlesssteel
	name = "stainless steel"
	lore_text = "A reflective alloy of steel and chromium. Used for its reflective and sturdy properties."
	wall_support_value = MAT_VALUE_HEAVY
	integrity = 175
	burn_armor = 10
	color = "#a5a5a5"
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	reflectiveness = MAT_VALUE_MIRRORED
	value = 1.3

/decl/material/solid/metal/aluminium
	name = "aluminium"
	lore_text = "A low-density ductile metal with a silvery-white sheen."
	integrity = 125
	weight = MAT_VALUE_LIGHT
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
	color = "#cccdcc"
	hitsound = 'sound/weapons/smash.ogg'
	taste_description = "metal"
	default_solid_form = /obj/item/stack/material/shiny

/decl/material/solid/metal/aluminium/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/grenade(src)

/decl/material/solid/metal/aluminium/holographic
	name = "holoaluminium"
	shard_type = SHARD_NONE
	conductive = 0
	hidden_from_codex = TRUE

/decl/material/solid/metal/aluminium/holographic/get_recipes(reinf_mat)
	return list()

/decl/material/solid/metal/plasteel
	name = "plasteel"
	lore_text = "An alloy of steel and platinum. When regular high-tensile steel isn't tough enough to get the job done, the smart consumer turns to frankly absurd alloys of steel and platinum."
	integrity = 400
	melting_point = 6000
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
	color = "#a8a9b2"
	explosion_resistance = 25
	brute_armor = 8
	burn_armor = 10
	hardness = MAT_VALUE_VERY_HARD
	stack_origin_tech = "{'materials':2}"
	hitsound = 'sound/weapons/smash.ogg'
	value = 1.4
	reflectiveness = MAT_VALUE_MATTE
	default_solid_form = /obj/item/stack/material/reinforced

/decl/material/solid/metal/plasteel/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/ai_core(src)
	. += new/datum/stack_recipe/furniture/crate(src)
	. += new/datum/stack_recipe/grip(src)

/decl/material/solid/metal/titanium
	name = "titanium"
	lore_text = "A light, strong, corrosion-resistant metal. Perfect for cladding high-velocity ballistic supply pods."
	brute_armor = 10
	burn_armor = 8
	integrity = 200
	melting_point = 3000
	weight = MAT_VALUE_LIGHT
	icon_base = 'icons/turf/walls/metal.dmi'
	wall_flags = PAINT_PAINTABLE
	door_icon_base = "metal"
	color = "#d1e6e3"
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	value = 1.5
	explosion_resistance = 25
	hardness = MAT_VALUE_VERY_HARD
	stack_origin_tech = "{'materials':2}"
	hitsound = 'sound/weapons/smash.ogg'
	reflectiveness = MAT_VALUE_MATTE
	default_solid_form = /obj/item/stack/material/reinforced

/decl/material/solid/metal/titanium/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/ai_core(src)
	. += new/datum/stack_recipe/furniture/crate(src)
	. += new/datum/stack_recipe/grip(src)

/decl/material/solid/metal/plasteel/ocp
	name = "osmium-carbide plasteel"
	integrity = 200
	melting_point = 12000
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
	color = "#9bc6f2"
	brute_armor = 4
	burn_armor = 20
	stack_origin_tech = "{'materials':3}"
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	value = 1.8

/decl/material/solid/metal/osmium
	name = "osmium"
	lore_text = "An extremely hard form of platinum."
	color = "#9999ff"
	stack_origin_tech = "{'materials':5}"
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	value = 1.3

/decl/material/solid/metal/platinum
	name = "platinum"
	lore_text = "A very dense, unreactive, precious metal. Has many industrial uses, particularly as a catalyst."
	color = "#deddff"
	weight = MAT_VALUE_VERY_HEAVY
	wall_support_value = MAT_VALUE_VERY_HEAVY
	stack_origin_tech = "{'materials':2}"
	ore_compresses_to = /decl/material/solid/metal/osmium
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "raw platinum"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "shiny"
	value = 1.5
	sparse_material_weight = 8
	rich_material_weight = 10
	ore_type_value = ORE_EXOTIC
	ore_data_value = 4

/decl/material/solid/metal/iron
	name = "iron"
	lore_text = "A ubiquitous, very common metal. The epitaph of stars and the primary ingredient in Earth's core."
	color = "#5c5454"
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_MATTE
	taste_description = "metal"

/decl/material/solid/metal/iron/affect_ingest(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/decl/material/solid/metal/tin
	name = "tin"
	lore_text = "A soft metal that can be cut without much force. Used in many alloys."
	color = "#c5c5a8"
	hardness = MAT_VALUE_SOFT + 10
	construction_difficulty = MAT_VALUE_EASY_DIY
	reflectiveness = MAT_VALUE_MATTE

/decl/material/solid/metal/lead
	name = "lead"
	lore_text = "A very soft, heavy and poisonous metal. You probably shouldn't lick it."
	color = "#3f3f4d"
	hardness = MAT_VALUE_SOFT
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_MATTE
	taste_description = "metallic sugar"
	toxicity = 1

/decl/material/solid/metal/zinc
	name = "zinc"
	lore_text = "A dull-looking metal with some use in alloying."
	color = "#92aae4"
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_MATTE

/decl/material/solid/metal/chromium
	name = "chromium"
	lore_text = "A heavy metal with near perfect reflectiveness. Used in stainless alloys."
	color = "#dadada"
	integrity = 200
	burn_armor = 15 // Strong against laser weaponry, but not as good as OCP.
	melting_point = 6000
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
	value = 1.5
	weight = MAT_VALUE_VERY_HEAVY
	hardness = MAT_VALUE_HARD + 10
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	reflectiveness = MAT_VALUE_MIRRORED

// Adminspawn only, do not let anyone get this.
/decl/material/solid/metal/alienalloy
	name = "dense alloy"
	color = "#6c7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = MAT_VALUE_VERY_HEAVY
	wall_support_value = MAT_VALUE_VERY_HEAVY
	hidden_from_codex = TRUE
	value = 3
	default_solid_form = /obj/item/stack/material/cubes

// Likewise.
/decl/material/solid/metal/alienalloy/elevatorium
	name = "elevator panelling"
	color = "#666666"
	hidden_from_codex = TRUE
	default_solid_form = /obj/item/stack/material/sheet

/decl/material/solid/metal/tungsten
	name = "tungsten"
	lore_text = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	color = "#dcdcdc"
	value = 0.5
