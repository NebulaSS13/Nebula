/material/plastic
	name = MAT_PLASTIC
	lore_text = "A generic polymeric material. Probably the most flexible and useful substance ever created by human science; mostly used to make disposable cutlery."
	stack_type = /obj/item/stack/material/plastic
	flags = MAT_FLAG_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_WHITE
	hardness = MAT_VALUE_SOFT
	weight = 5
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	chem_products = list(
				/datum/reagent/toxin/plasticide = 20
				)
	sale_price = 1

/material/plastic/holographic
	name = "holo" + MAT_PLASTIC
	display_name = MAT_PLASTIC
	stack_type = null
	shard_type = SHARD_NONE
	sale_price = null
	hidden_from_codex = TRUE

/material/cardboard
	name = MAT_CARDBOARD
	lore_text = "What with the difficulties presented by growing plants in orbit, a stock of cardboard in space is probably more valuable than gold."
	stack_type = /obj/item/stack/material/cardboard
	flags = MAT_FLAG_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#aaaaaa"
	hardness = MAT_VALUE_SOFT
	brute_armor = 1
	weight = 1
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	conductive = 0
	value = 0

/material/cloth //todo
	name = MAT_CLOTH
	display_name ="cotton"
	use_name = "cotton"
	icon_colour = "#ffffff"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MAT_FLAG_PADDING
	brute_armor = 1
	conductive = 0
	stack_type = null
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY

/material/cloth/carpet
	name = "carpet"
	display_name = "red"
	use_name = "red upholstery"
	icon_colour = "#9d2300"
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"

/material/cloth/yellow
	name = "yellow"
	display_name ="yellow"
	use_name = "yellow cloth"
	icon_colour = "#ffbf00"

/material/cloth/teal
	name = "teal"
	display_name = "teal"
	use_name = "teal cloth"
	icon_colour = "#00e1ff"

/material/cloth/black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"

/material/cloth/green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#b7f27d"

/material/cloth/puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9933ff"

/material/cloth/blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#46698c"

/material/cloth/beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#ceb689"

/material/cloth/lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62e36c"

/material/carpet
	name = MAT_CARPET
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

/material/skin
	name = MAT_SKIN_GENERIC
	stack_type = /obj/item/stack/material/generic/skin
	icon_colour = "#9e8c72"
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	value = 1
	integrity = 50
	hardness = MAT_VALUE_SOFT
	weight = 5
	explosion_resistance = 1
	var/tans_to = MAT_LEATHER_GENERIC

/material/skin/lizard
	name = MAT_SKIN_LIZARD
	icon_colour = "#626952"
	tans_to = MAT_LEATHER_LIZARD
	hardness = MAT_VALUE_FLEXIBLE
	weight = 10

/material/skin/insect
	name = MAT_SKIN_CHITIN
	icon_colour = "#7a726d"
	tans_to = MAT_LEATHER_CHITIN
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = 15
	brute_armor = 2

/material/skin/fur
	name = MAT_SKIN_FUR
	icon_colour = "#7a726d"
	tans_to = MAT_LEATHER_FUR

/material/skin/fur/gray
	name = MAT_SKIN_FUR_GRAY

/material/skin/fur/white
	name = MAT_SKIN_FUR_WHITE

/material/skin/fur/orange
	name = MAT_SKIN_FUR_ORANGE
	icon_colour = COLOR_ORANGE

/material/skin/fur/black
	name = MAT_SKIN_FUR_BLACK
	icon_colour = COLOR_GRAY20

/material/skin/fur/heavy
	name = MAT_SKIN_FUR_HEAVY
	icon_colour = COLOR_GUNMETAL

/material/skin/goat
	name = MAT_SKIN_GOATHIDE
	icon_colour = COLOR_SILVER

/material/skin/cow
	name = MAT_SKIN_COWHIDE
	icon_colour = COLOR_GRAY40

/material/skin/shark
	name = MAT_SKIN_SHARK
	icon_colour = COLOR_PURPLE_GRAY

/material/skin/fish
	name = MAT_SKIN_FISH
	icon_colour = COLOR_BOTTLE_GREEN

/material/skin/fish/purple
	name = MAT_SKIN_FISH_PURPLE
	icon_colour = COLOR_PALE_PURPLE_GRAY

/material/skin/feathers
	name = MAT_SKIN_FEATHERS
	icon_colour = COLOR_SILVER

/material/skin/feathers/purple
	name = MAT_SKIN_FEATHERS_PURPLE
	icon_colour = COLOR_PALE_PURPLE_GRAY

/material/skin/feathers/blue
	name = MAT_SKIN_FEATHERS_BLUE
	icon_colour = COLOR_SKY_BLUE

/material/skin/feathers/green
	name = MAT_SKIN_FEATHERS_GREEN
	icon_colour = COLOR_BOTTLE_GREEN

/material/skin/feathers/brown
	name = MAT_SKIN_FEATHERS_BROWN
	icon_colour = COLOR_BEASTY_BROWN

/material/skin/feathers/red
	name = MAT_SKIN_FEATHERS_RED
	icon_colour = COLOR_RED

/material/skin/feathers/black
	name = MAT_SKIN_FEATHERS_BLACK
	icon_colour = COLOR_GRAY15

/material/bone
	name = MAT_BONE_GENERIC
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
	weight = 18
	value = 1

/material/bone/fish
	name = MAT_BONE_FISH
	hardness = MAT_VALUE_FLEXIBLE
	weight = 13

/material/bone/cartilage
	name = MAT_BONE_CARTILAGE
	hardness = 0
	weight = 10

/material/leather
	name = MAT_LEATHER_GENERIC
	icon_colour = "#5c4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0
	stack_type = /obj/item/stack/material/generic/skin
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	value = 3
	integrity = 50
	hardness = MAT_VALUE_FLEXIBLE
	weight = 10

/material/leather/lizard
	name = MAT_LEATHER_LIZARD
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = 15

/material/leather/fur
	name = MAT_LEATHER_FUR

/material/leather/chitin
	name = MAT_LEATHER_CHITIN
	integrity = 100
	hardness = MAT_VALUE_HARD
	weight = 18
	brute_armor = 2
