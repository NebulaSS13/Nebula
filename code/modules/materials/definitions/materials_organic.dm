/decl/material/plastic
	name = "plastic"
	lore_text = "A generic polymeric material. Probably the most flexible and useful substance ever created by human science; mostly used to make disposable cutlery."
	stack_type = /obj/item/stack/material/plastic
	flags = MAT_FLAG_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_EGGSHELL
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = "{'materials':3}"
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	chemical_makeup = list(
		/decl/material/chem/toxin/plasticide = 1
	)
	reflectiveness = MAT_VALUE_SHINY
	wall_support_value = 10

/decl/material/plastic/holographic
	name = "holographic plastic"
	stack_type = null
	shard_type = SHARD_NONE
	hidden_from_codex = TRUE

/decl/material/plastic/holographic/get_recipes(reinf_mat)
	return list()

/decl/material/cardboard
	name = "cardboard"
	lore_text = "What with the difficulties presented by growing plants in orbit, a stock of cardboard in space is probably more valuable than gold."
	stack_type = /obj/item/stack/material/cardboard
	flags = MAT_FLAG_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#aaaaaa"
	hardness = MAT_VALUE_SOFT
	brute_armor = 1
	weight = MAT_VALUE_EXTREMELY_LIGHT - 5
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = "{'materials':1}"
	door_icon_base = "wood"
	destruction_desc = "crumples"
	conductive = 0
	value = 0.5
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = 0

/decl/material/cloth //todo
	name = "cotton"
	use_name = "cotton"
	icon_colour = "#ffffff"
	stack_origin_tech = "{'materials':2}"
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MAT_FLAG_PADDING
	brute_armor = 1
	conductive = 0
	stack_type = null
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_DULL
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	wall_support_value = 0

/decl/material/cloth/yellow
	name = "yellow"
	use_name = "yellow cloth"
	icon_colour = "#ffbf00"

/decl/material/cloth/teal
	name = "teal"
	use_name = "teal cloth"
	icon_colour = "#00e1ff"

/decl/material/cloth/black
	name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"

/decl/material/cloth/green
	name = "green"
	use_name = "green cloth"
	icon_colour = "#b7f27d"

/decl/material/cloth/purple
	name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9933ff"

/decl/material/cloth/blue
	name = "blue"
	use_name = "blue cloth"
	icon_colour = "#46698c"

/decl/material/cloth/beige
	name = "beige"
	use_name = "beige cloth"
	icon_colour = "#ceb689"

/decl/material/cloth/lime
	name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62e36c"

/decl/material/carpet
	name = "red"
	use_name = "red upholstery"
	icon_colour = "#9d2300"
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	conductive = 0
	stack_type = null
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_DULL
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	wall_support_value = 0
	hidden_from_codex = TRUE

/decl/material/skin
	name = "skin"
	stack_type = /obj/item/stack/material/generic/skin
	icon_colour = "#9e8c72"
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	integrity = 50
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	explosion_resistance = 1
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = 0
	value = 1.2
	var/tans_to = MAT_LEATHER_GENERIC

/decl/material/skin/lizard
	name = "lizardskin"
	icon_colour = "#626952"
	tans_to = MAT_LEATHER_LIZARD
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT

/decl/material/skin/insect
	name = "chitin"
	icon_colour = "#7a776d"
	tans_to = MAT_LEATHER_CHITIN
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_VERY_LIGHT
	brute_armor = 2

/decl/material/skin/fur
	name = "fur"
	icon_colour = "#7a726d"
	tans_to = MAT_LEATHER_FUR
/decl/material/skin/fur/gray

/decl/material/skin/fur/white

/decl/material/skin/fur/orange
	icon_colour = COLOR_ORANGE

/decl/material/skin/fur/black
	icon_colour = COLOR_GRAY20

/decl/material/skin/fur/heavy
	icon_colour = COLOR_GUNMETAL

/decl/material/skin/goat
	icon_colour = COLOR_SILVER

/decl/material/skin/cow
	icon_colour = COLOR_GRAY40

/decl/material/skin/shark
	name = "sharkskin"
	icon_colour = COLOR_PURPLE_GRAY

/decl/material/skin/fish
	icon_colour = COLOR_BOTTLE_GREEN
	name = "fishskin"

/decl/material/skin/fish/purple
	icon_colour = COLOR_PALE_PURPLE_GRAY

/decl/material/skin/feathers
	name = "feathers"
	icon_colour = COLOR_SILVER

/decl/material/skin/feathers/purple
	icon_colour = COLOR_PALE_PURPLE_GRAY

/decl/material/skin/feathers/blue
	icon_colour = COLOR_SKY_BLUE

/decl/material/skin/feathers/green
	icon_colour = COLOR_BOTTLE_GREEN

/decl/material/skin/feathers/brown
	icon_colour = COLOR_BEASTY_BROWN

/decl/material/skin/feathers/red
	icon_colour = COLOR_RED

/decl/material/skin/feathers/black
	icon_colour = COLOR_GRAY15

/decl/material/bone
	name = "bone"
	sheet_singular_name = "length"
	sheet_plural_name = "lengths"
	icon_colour = "#f0edc7"
	stack_type = /obj/item/stack/material/generic/bone
	ignition_point = T0C+1100
	melting_point = T0C+1800
	conductive = 0
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	hitsound = 'sound/weapons/smash.ogg'
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_LIGHT
	reflectiveness = MAT_VALUE_MATTE
	wall_support_value = 22

/decl/material/bone/fish
	name = "fishbone"
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT

/decl/material/bone/cartilage
	name = "cartilage"
	hardness = 0
	weight = MAT_VALUE_EXTREMELY_LIGHT

/decl/material/leather
	name = "leather"
	icon_colour = "#5c4831"
	stack_origin_tech = "{'materials':2}"
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0
	stack_type = /obj/item/stack/material/generic/skin
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	integrity = 50
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_EXTREMELY_LIGHT
	reflectiveness = MAT_VALUE_MATTE
	wall_support_value = 0

/decl/material/leather/synth
	name = "synthleather"
	icon_colour = "#1f1f20"
	ignition_point = T0C+150
	melting_point = T0C+100

/decl/material/leather/lizard
	name = "scaled hide"
	icon_colour = "#434b31"
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_LIGHT
	reflectiveness = MAT_VALUE_SHINY

/decl/material/leather/fur
	name = "tanned pelt"

/decl/material/leather/chitin
	name = "treated chitin"
	integrity = 100
	icon_colour = "#5c5a54"
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_NORMAL
	brute_armor = 2
	wall_support_value = 14
