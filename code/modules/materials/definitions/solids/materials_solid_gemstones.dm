/decl/material/solid/gemstone
	name = null
	flags = MAT_FLAG_UNMELTABLE
	cut_delay = 60
	color = COLOR_DIAMOND
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	reflectiveness = MAT_VALUE_MIRRORED
	conductive = 0
	ore_icon_overlay = "gems"
	default_solid_form = /obj/item/stack/material/gemstone
	abstract_type = /decl/material/solid/gemstone
	sound_manipulate = 'sound/foley/pebblespickup1.ogg'
	sound_dropped = 'sound/foley/pebblesdrop1.ogg'

/decl/material/solid/gemstone/diamond
	name = "diamond"
	uid = "solid_diamond"
	lore_text = "An extremely hard allotrope of carbon. Valued for its use in industrial tools."
	brute_armor = 10
	burn_armor = 50		// Diamond walls are immune to fire, therefore it makes sense for them to be almost undamageable by burn damage type.
	stack_origin_tech = "{'materials':6}"
	hardness = MAT_VALUE_VERY_HARD + 20
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	ore_name = "rough diamonds"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_scan_icon = "mineral_rare"
	xarch_source_mineral = /decl/material/gas/ammonia
	value = 1.8
	sparse_material_weight = 5
	rich_material_weight = 5
	ore_type_value = ORE_PRECIOUS
	ore_data_value = 2
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/gemstone/crystal
	name = "crystal"
	uid = "solid_crystal"
	hardness = MAT_VALUE_VERY_HARD
	reflectiveness = MAT_VALUE_VERY_SHINY
	hidden_from_codex = TRUE
	value = 2
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
