/decl/material/solid/gemstone
	flags                   = MAT_FLAG_UNMELTABLE
	cut_delay               = 60
	color                   = COLOR_DIAMOND
	opacity                 = 0.4
	shard_name              = SHARD_SHARD
	tableslam_noise         = 'sound/effects/Glasshit.ogg'
	conductive              = 0
	ore_icon_overlay        = "gems"
	default_solid_form      = /obj/item/stack/material/gemstone
	abstract_type           = /decl/material/solid/gemstone
	sound_manipulate        = 'sound/foley/pebblespickup1.ogg'
	sound_dropped           = 'sound/foley/pebblesdrop1.ogg'
	exoplanet_rarity_plant  = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas    = MAT_RARITY_NOWHERE
	dissolves_in            = MAT_SOLVENT_IMMUNE
	dissolves_into          = null
	hardness                = MAT_VALUE_VERY_HARD
	reflectiveness          = MAT_VALUE_VERY_SHINY
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY

/decl/material/solid/gemstone/diamond
	name                    = "diamond"
	uid                     = "solid_diamond"
	lore_text               = "An extremely hard allotrope of carbon. Valued for its use in industrial tools."
	melting_point           = 4300
	boiling_point           = null
	ignition_point          = null
	brute_armor             = 10
	burn_armor              = 50 // Diamond walls are immune to fire, therefore it makes sense for them to be almost undamageable by burn damage type.
	stack_origin_tech       = @'{"materials":6}'
	hardness                = MAT_VALUE_VERY_HARD + 20
	ore_name                = "rough diamonds"
	ore_result_amount       = 1
	ore_spread_chance       = 10
	ore_scan_icon           = "mineral_rare"
	xarch_source_mineral    = /decl/material/gas/ammonia
	value                   = 1.8
	sparse_material_weight  = 5
	rich_material_weight    = 5
	ore_type_value          = ORE_PRECIOUS
	ore_data_value          = 2

/decl/material/solid/gemstone/crystal
	name              = "crystal"
	uid               = "solid_crystal"
	value             = 2
	hidden_from_codex = TRUE

/decl/material/solid/gemstone/ruby
	name      = "ruby"
	lore_text = "A rich red stone sometimes found in marble."
	uid       = "solid_ruby"
	value     = 1.6
	color     = "#d00000"

/decl/material/solid/gemstone/sapphire
	name      = "sapphire"
	lore_text = "A deep blue gemstone sometimes found in clay or other sediment."
	uid       = "solid_sapphite"
	value     = 1.6
	color     = "#2983de"

/decl/material/solid/gemstone/topaz
	name      = "topaz"
	lore_text = "A golden gemstone sometimes found in granite."
	uid       = "solid_topaz"
	value     = 1.6
	color     = "#f7b92d"
