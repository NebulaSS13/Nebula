/material/plastic
	display_name = "plastic"
	lore_text = "A generic polymeric material. Probably the most flexible and useful substance ever created by human science; mostly used to make disposable cutlery."
	stack_type = /obj/item/stack/material/plastic
	flags = MAT_FLAG_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_WHITE
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = "{'materials':3}"
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	chemical_makeup = list(
		/decl/reagent/toxin/plasticide = 1
	)
	reflectiveness = MAT_VALUE_SHINY
	wall_support_value = 10

/material/plastic/holographic
	display_name = "holographic plastic"
	stack_type = null
	shard_type = SHARD_NONE
	hidden_from_codex = TRUE

/material/plastic/holographic/get_recipes(reinf_mat)
	return list()

/material/cardboard
	display_name = "cardboard"
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

/material/cloth //todo
	display_name = "cotton"
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

/material/cloth/yellow
	display_name ="yellow"
	use_name = "yellow cloth"
	icon_colour = "#ffbf00"

/material/cloth/teal
	display_name = "teal"
	use_name = "teal cloth"
	icon_colour = "#00e1ff"

/material/cloth/black
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"

/material/cloth/green
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#b7f27d"

/material/cloth/purple
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9933ff"

/material/cloth/blue
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#46698c"

/material/cloth/beige
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#ceb689"

/material/cloth/lime
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62e36c"

/material/carpet
	display_name = "red"
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

/material/skin
	display_name = "skin"
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

/material/skin/lizard
	display_name = "lizardskin"
	icon_colour = "#626952"
	tans_to = MAT_LEATHER_LIZARD
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT

/material/skin/insect
	display_name = "chitin"
	icon_colour = "#7a776d"
	tans_to = MAT_LEATHER_CHITIN
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_VERY_LIGHT
	brute_armor = 2

/material/skin/fur
	display_name = "fur"
	icon_colour = "#7a726d"
	tans_to = MAT_LEATHER_FUR
/material/skin/fur/gray

/material/skin/fur/white

/material/skin/fur/orange
	icon_colour = COLOR_ORANGE

/material/skin/fur/black
	icon_colour = COLOR_GRAY20

/material/skin/fur/heavy
	icon_colour = COLOR_GUNMETAL

/material/skin/goat
	icon_colour = COLOR_SILVER

/material/skin/cow
	icon_colour = COLOR_GRAY40

/material/skin/shark
	display_name = "sharkskin"
	icon_colour = COLOR_PURPLE_GRAY

/material/skin/fish
	icon_colour = COLOR_BOTTLE_GREEN
	display_name = "fishskin"

/material/skin/fish/purple
	icon_colour = COLOR_PALE_PURPLE_GRAY

/material/skin/feathers
	display_name = "feathers"
	icon_colour = COLOR_SILVER

/material/skin/feathers/purple
	icon_colour = COLOR_PALE_PURPLE_GRAY

/material/skin/feathers/blue
	icon_colour = COLOR_SKY_BLUE

/material/skin/feathers/green
	icon_colour = COLOR_BOTTLE_GREEN

/material/skin/feathers/brown
	icon_colour = COLOR_BEASTY_BROWN

/material/skin/feathers/red
	icon_colour = COLOR_RED

/material/skin/feathers/black
	icon_colour = COLOR_GRAY15

/material/bone
	display_name = "bone"
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

/material/bone/fish
	display_name = "fishbone"
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT

/material/bone/cartilage
	display_name = "cartilage"
	hardness = 0
	weight = MAT_VALUE_EXTREMELY_LIGHT

/material/leather
	display_name = "leather"
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

/material/leather/synth
	display_name = "synthleather"
	icon_colour = "#1f1f20"
	ignition_point = T0C+150
	melting_point = T0C+100

/material/leather/lizard
	display_name = "scaled hide"
	icon_colour = "#434b31"
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_LIGHT
	reflectiveness = MAT_VALUE_SHINY

/material/leather/fur
	display_name = "tanned pelt"

/material/leather/chitin
	display_name = "treated chitin"
	integrity = 100
	icon_colour = "#5c5a54"
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_NORMAL
	brute_armor = 2
	wall_support_value = 14
