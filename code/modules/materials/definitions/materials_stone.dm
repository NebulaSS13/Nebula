/material/diamond
	display_name = "diamond"
	lore_text = "An extremely hard allotrope of carbon. Valued for its use in industrial tools."
	stack_type = /obj/item/stack/material/diamond
	flags = MAT_FLAG_UNMELTABLE
	cut_delay = 60
	icon_colour = COLOR_DIAMOND
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = MAT_VALUE_VERY_HARD + 20
	reflectiveness = MAT_VALUE_MIRRORED
	brute_armor = 10
	burn_armor = 50		// Diamond walls are immune to fire, therefore it makes sense for them to be almost undamageable by burn damage type.
	stack_origin_tech = "{'materials':6}"
	conductive = 0
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	ore_name = "rough diamonds"
	ore_compresses_to = MAT_DIAMOND
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_scan_icon = "mineral_rare"
	xarch_source_mineral = /decl/reagent/ammonia
	ore_icon_overlay = "gems"
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"
	value = 1.8

/material/diamond/crystal
	display_name = "crystal"
	hardness = MAT_VALUE_VERY_HARD
	reflectiveness = MAT_VALUE_VERY_SHINY
	stack_type = null
	ore_compresses_to = null
	hidden_from_codex = TRUE
	value = 2

/material/stone
	display_name = "sandstone"
	lore_text = "A clastic sedimentary rock. The cost of boosting it to orbit is almost universally much higher than the actual value of the material."
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#d9c179"
	shard_type = SHARD_STONE_PIECE
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_HARD - 5
	reflectiveness = MAT_VALUE_MATTE
	brute_armor = 3
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	chem_products = list(
		/decl/reagent/silicon = 20
		)
	value = 1.5

/material/stone/ceramic
	display_name = "ceramic"
	lore_text = "A hard substance produced by firing clay in a kiln."
	stack_type = /obj/item/stack/material/generic
	icon_colour = COLOR_OFF_WHITE

/material/stone/marble
	display_name = "marble"
	lore_text = "A metamorphic rock largely sourced from Earth. Prized for use in extremely expensive decorative surfaces."
	icon_colour = "#aaaaaa"
	weight = MAT_VALUE_VERY_HEAVY
	hardness = MAT_VALUE_HARD
	reflectiveness = MAT_VALUE_SHINY
	brute_armor = 3
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
	construction_difficulty = MAT_VALUE_HARD_DIY
	chem_products = null

/material/stone/concrete
	display_name = "concrete"
	lore_text = "The most ubiquitous building material of old Earth, now in space. Consists of mineral aggregate bound with some sort of cementing solution."
	stack_type = /obj/item/stack/material/generic/brick
	icon_colour = COLOR_GRAY
	value = 0.9
	var/image/texture

/material/stone/concrete/New()
	..()
	texture = image('icons/turf/wall_texture.dmi', "concrete")
	texture.blend_mode = BLEND_MULTIPLY

/material/stone/concrete/get_wall_texture()
	return texture
