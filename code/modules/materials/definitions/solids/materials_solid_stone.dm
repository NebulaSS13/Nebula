/decl/material/solid/stone
	name = null
	abstract_type = /decl/material/solid/stone
	color = "#d9c179"
	shard_type = SHARD_STONE_PIECE
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_HARD - 5
	reflectiveness = MAT_VALUE_MATTE
	brute_armor = 3
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	wall_blend_icons = list(
		'icons/turf/walls/solid.dmi' = TRUE,
		'icons/turf/walls/wood.dmi' = TRUE,
		'icons/turf/walls/brick.dmi' = TRUE,
		'icons/turf/walls/log.dmi' = TRUE,
		'icons/turf/walls/metal.dmi' = TRUE
	)
	dissolves_into = list(
		/decl/material/solid/silicon = 1
	)
	ore_result_amount = 4
	sound_manipulate = 'sound/foley/rockscrape.ogg'
	sound_dropped    = 'sound/foley/rockscrape.ogg'

/decl/material/solid/stone/sandstone
	name = "sandstone"
	uid = "solid_sandstone"
	lore_text = "A clastic sedimentary rock. The cost of boosting it to orbit is almost universally much higher than the actual value of the material."
	value = 1.5
	melting_point = T0C + 600
	hardness = MAT_VALUE_RIGID + 5

/decl/material/solid/stone/flint
	name      = "flint"
	uid       = "solid_flint"
	lore_text = "A hard, smooth stone traditionally used for making fire."
	value     = 3
	color     = "#615f5f"

/decl/material/solid/stone/granite
	name                   = "granite"
	uid                    = "solid_granite"
	lore_text              = "A coarse-grained igneous rock formed by magma containing sillicon and alkali metal oxides."
	color                  = "#615f5f"
	exoplanet_rarity_plant = MAT_RARITY_MUNDANE
	exoplanet_rarity_gas   = MAT_RARITY_MUNDANE
	hardness               = MAT_VALUE_HARD
	melting_point          = T0C + 1260
	brute_armor            = 15
	explosion_resistance   = 15
	integrity              = 500 //granite is very strong
	dissolves_into         = list(
		/decl/material/solid/silicon = 0.75,
		/decl/material/solid/bauxite = 0.15,
		/decl/material/solid/slag    = 0.10,
	)

/decl/material/solid/stone/pottery
	name = "fired clay"
	uid = "solid_pottery"
	lore_text = "A hard but brittle substance produced by firing clay in a kiln."
	color = "#cd8f75"
	adjective_name = "earthenware"
	melting_point = 2000 // Arbitrary, hotter than the kiln currently reaches.

/decl/material/solid/stone/ceramic
	name = "ceramic"
	uid = "solid_ceramic"
	lore_text = "A very hard, heat-resistant substance produced by firing glazed clay in a kiln."
	color = COLOR_OFF_WHITE
	melting_point = 6000 // Arbitrary, very heat-resistant.

	dissolves_in = MAT_SOLVENT_IMMUNE
	dissolves_into = null

/decl/material/solid/stone/marble
	name = "marble"
	uid = "solid_marble"
	lore_text = "A metamorphic rock largely sourced from Earth. Prized for use in extremely expensive decorative surfaces."
	color = "#aaaaaa"
	weight = MAT_VALUE_VERY_HEAVY
	wall_support_value = MAT_VALUE_VERY_HEAVY
	hardness = MAT_VALUE_HARD
	reflectiveness = MAT_VALUE_SHINY
	melting_point  = T0C + 1200
	brute_armor = 3
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	construction_difficulty = MAT_VALUE_HARD_DIY

/decl/material/solid/stone/basalt
	name = "basalt"
	uid = "solid_basalt"
	lore_text = "A ubiquitous volcanic stone."
	color = COLOR_DARK_GRAY
	weight = MAT_VALUE_VERY_HEAVY
	wall_support_value = MAT_VALUE_VERY_HEAVY
	hardness = MAT_VALUE_HARD
	reflectiveness = MAT_VALUE_SHINY
	melting_point  = T0C + 1200
	construction_difficulty = MAT_VALUE_HARD_DIY

/decl/material/solid/stone/concrete
	name = "concrete"
	uid = "solid_concrete"
	lore_text = "The most ubiquitous building material of old Earth, now in space. Consists of mineral aggregate bound with some sort of cementing solution."
	color = COLOR_GRAY
	value = 0.9
	melting_point  = T0C + 1200
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	var/image/texture

/decl/material/solid/stone/concrete/Initialize()
	. = ..()
	texture = image('icons/turf/wall_texture.dmi', "concrete")
	texture.blend_mode = BLEND_MULTIPLY

/decl/material/solid/stone/concrete/get_wall_texture()
	return texture
