/decl/material/solid/stone
	name = null
	color = "#d9c179"
	shard_type = SHARD_STONE_PIECE
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_HARD - 5
	reflectiveness = MAT_VALUE_MATTE
	brute_armor = 3
	conductive = 0
	stack_type = /obj/item/stack/material/generic/brick
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	dissolves_into = list(
		/decl/material/solid/silicon = 1
	)

/decl/material/solid/stone/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/planting_bed(src)

/decl/material/solid/stone/sandstone
	name = "sandstone"
	lore_text = "A clastic sedimentary rock. The cost of boosting it to orbit is almost universally much higher than the actual value of the material."
	stack_type = /obj/item/stack/material/sandstone
	value = 1.5

/decl/material/solid/stone/ceramic
	name = "ceramic"
	lore_text = "A hard substance produced by firing clay in a kiln."
	stack_type = /obj/item/stack/material/generic
	color = COLOR_OFF_WHITE

/decl/material/solid/stone/marble
	name = "marble"
	lore_text = "A metamorphic rock largely sourced from Earth. Prized for use in extremely expensive decorative surfaces."
	color = "#aaaaaa"
	weight = MAT_VALUE_VERY_HEAVY
	wall_support_value = MAT_VALUE_VERY_HEAVY
	hardness = MAT_VALUE_HARD
	reflectiveness = MAT_VALUE_SHINY
	brute_armor = 3
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
	construction_difficulty = MAT_VALUE_HARD_DIY

/decl/material/solid/stone/basalt
	name = "basalt"
	lore_text = "A ubiquitous volcanic stone."
	color = COLOR_DARK_GRAY
	stack_type = /obj/item/stack/material/generic
	weight = MAT_VALUE_VERY_HEAVY
	wall_support_value = MAT_VALUE_VERY_HEAVY
	hardness = MAT_VALUE_HARD
	reflectiveness = MAT_VALUE_SHINY
	construction_difficulty = MAT_VALUE_HARD_DIY

/decl/material/solid/stone/concrete
	name = "concrete"
	lore_text = "The most ubiquitous building material of old Earth, now in space. Consists of mineral aggregate bound with some sort of cementing solution."
	stack_type = /obj/item/stack/material/generic/brick
	color = COLOR_GRAY
	value = 0.9
	var/image/texture

/decl/material/solid/stone/concrete/New()
	..()
	texture = image('icons/turf/wall_texture.dmi', "concrete")
	texture.blend_mode = BLEND_MULTIPLY

/decl/material/solid/stone/concrete/get_wall_texture()
	return texture

/decl/material/solid/stone/cult
	name = "disturbing stone"
	icon_base = 'icons/turf/walls/cult.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_cult.dmi'
	color = "#402821"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	hidden_from_codex = TRUE
	reflectiveness = MAT_VALUE_DULL

/decl/material/solid/stone/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target)

/decl/material/solid/stone/cult/reinforced
	name = "runic inscriptions"
