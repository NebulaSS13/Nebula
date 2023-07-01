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
		'icons/turf/walls/metal.dmi' = TRUE
	)
	dissolves_into = list(
		/decl/material/solid/silicon = 1
	)

/decl/material/solid/stone/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	if(wall_support_value >= 10)
		. += new/datum/stack_recipe/furniture/girder(src)
	. += new/datum/stack_recipe/furniture/planting_bed(src)
	. += new/datum/stack_recipe/fountain(src)

/decl/material/solid/stone/sandstone
	name = "sandstone"
	uid = "solid_sandstone"
	lore_text = "A clastic sedimentary rock. The cost of boosting it to orbit is almost universally much higher than the actual value of the material."
	value = 1.5

/decl/material/solid/stone/granite
	name                   = "granite"
	uid                    = "solid_granite"
	lore_text              = "A coarse-grained igneous rock formed by magma containing sillicon and alkali metal oxides."
	color                  = "#615f5f"
	exoplanet_rarity_plant = MAT_RARITY_MUNDANE
	exoplanet_rarity_gas   = MAT_RARITY_MUNDANE
	hardness               = MAT_VALUE_HARD + 5
	melting_point          = T0C + 1260
	brute_armor            = 15
	explosion_resistance   = 15
	integrity              = 500 //granite is very strong
	dissolves_into         = list(
		/decl/material/solid/silicon = 0.75,
		/decl/material/solid/bauxite = 0.15,
		/decl/material/solid/slag    = 0.10,
	)

/decl/material/solid/stone/ceramic
	name = "ceramic"
	uid = "solid_ceramic"
	lore_text = "A hard substance produced by firing clay in a kiln."
	color = COLOR_OFF_WHITE

/decl/material/solid/stone/marble
	name = "marble"
	uid = "solid_marble"
	lore_text = "A metamorphic rock largely sourced from Earth. Prized for use in extremely expensive decorative surfaces."
	color = "#aaaaaa"
	weight = MAT_VALUE_VERY_HEAVY
	wall_support_value = MAT_VALUE_VERY_HEAVY
	hardness = MAT_VALUE_HARD
	reflectiveness = MAT_VALUE_SHINY
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
	construction_difficulty = MAT_VALUE_HARD_DIY

/decl/material/solid/stone/concrete
	name = "concrete"
	uid = "solid_concrete"
	lore_text = "The most ubiquitous building material of old Earth, now in space. Consists of mineral aggregate bound with some sort of cementing solution."
	color = COLOR_GRAY
	value = 0.9
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	var/image/texture

/decl/material/solid/stone/concrete/Initialize()
	. = ..()
	texture = image('icons/turf/wall_texture.dmi', "concrete")
	texture.blend_mode = BLEND_MULTIPLY

/decl/material/solid/stone/concrete/get_wall_texture()
	return texture

/decl/material/solid/stone/cult
	name = "disturbing stone"
	uid = "solid_stone_cult"
	icon_base = 'icons/turf/walls/cult.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_cult.dmi'
	color = "#402821"
	shard_type = SHARD_STONE_PIECE
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	hidden_from_codex = TRUE
	reflectiveness = MAT_VALUE_DULL
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/stone/cult/place_dismantled_girder(var/turf/target)
	return list(new /obj/structure/girder/cult(target))

/decl/material/solid/stone/cult/reinforced
	name = "runic inscriptions"
	uid = "solid_runes_cult"
