/decl/material/solid/plastic
	name = "plastic"
	lore_text = "A generic polymeric material. Probably the most flexible and useful substance ever created by human science; mostly used to make disposable cutlery."
	stack_type = /obj/item/stack/material/plastic
	flags = MAT_FLAG_BRITTLE
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	color = COLOR_EGGSHELL
	door_icon_base = "plastic"
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_LIGHT
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = "{'materials':3}"
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_SHINY
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	taste_description = "plastic"
	fuel_value = 0.6
	burn_product = /decl/material/gas/carbon_monoxide // placeholder for more appropriate toxins
	dooropen_noise = 'sound/effects/doorcreaky.ogg'

/decl/material/solid/plastic/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/crate/plastic(src)
	. += new/datum/stack_recipe/bag(src)
	. += new/datum/stack_recipe/ivbag(src)
	. += create_recipe_list(/datum/stack_recipe/cartridge)
	. += create_recipe_list(/datum/stack_recipe/tile/light)
	. += new/datum/stack_recipe/hazard_cone(src)
	. += new/datum/stack_recipe/furniture/flaps(src)

/decl/material/solid/plastic/holographic
	name = "holographic plastic"
	stack_type = null
	shard_type = SHARD_NONE
	hidden_from_codex = TRUE

/decl/material/solid/plastic/holographic/get_recipes(reinf_mat)
	return list()

/decl/material/solid/cardboard
	name = "cardboard"
	lore_text = "What with the difficulties presented by growing plants in orbit, a stock of cardboard in space is probably more valuable than gold."
	stack_type = /obj/item/stack/material/cardboard
	flags = MAT_FLAG_BRITTLE
	integrity = 10
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	color = "#aaaaaa"
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
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT

/decl/material/solid/cardboard/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += create_recipe_list(/datum/stack_recipe/box)
	. += new/datum/stack_recipe/cardborg_suit(src)
	. += new/datum/stack_recipe/cardborg_helmet(src)
	. += new/datum/stack_recipe_list("folders", create_recipe_list(/datum/stack_recipe/folder))

/decl/material/solid/cloth //todo
	name = "cotton"
	use_name = "cotton"
	color = "#ffffff"
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
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT

/decl/material/solid/cloth/yellow
	name = "yellow"
	use_name = "yellow cloth"
	color = "#ffbf00"

/decl/material/solid/cloth/teal
	name = "teal"
	use_name = "teal cloth"
	color = "#00e1ff"

/decl/material/solid/cloth/black
	name = "black"
	use_name = "black cloth"
	color = "#505050"

/decl/material/solid/cloth/green
	name = "green"
	use_name = "green cloth"
	color = "#b7f27d"

/decl/material/solid/cloth/purple
	name = "purple"
	use_name = "purple cloth"
	color = "#9933ff"

/decl/material/solid/cloth/blue
	name = "blue"
	use_name = "blue cloth"
	color = "#46698c"

/decl/material/solid/cloth/beige
	name = "beige"
	use_name = "beige cloth"
	color = "#ceb689"

/decl/material/solid/cloth/lime
	name = "lime"
	use_name = "lime cloth"
	color = "#62e36c"

/decl/material/solid/carpet
	name = "red"
	use_name = "red upholstery"
	color = "#9d2300"
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
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	hidden_from_codex = TRUE

/decl/material/solid/plantmatter
	name = "plant matter"
	color = COLOR_GREEN_GRAY
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 1
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	integrity = 70
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_NORMAL
	explosion_resistance = 1
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = MAT_VALUE_LIGHT
	value = 0.8

/decl/material/solid/meat
	name = "meat"
	color = COLOR_DARK_RED
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 1
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	integrity = 60
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_NORMAL
	explosion_resistance = 1
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = MAT_VALUE_LIGHT
	value = 0.8

/decl/material/solid/skin
	name = "skin"
	stack_type = /obj/item/stack/material/generic/skin
	color = "#9e8c72"
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
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	value = 1.2
	var/tans_to = /decl/material/solid/leather

/decl/material/solid/skin/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/cloak(src)
	. += new/datum/stack_recipe/shoes(src)

/decl/material/solid/skin/lizard
	name = "lizardskin"
	color = "#626952"
	tans_to = /decl/material/solid/leather/lizard
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT

/decl/material/solid/skin/insect
	name = "chitin"
	color = "#7a776d"
	tans_to = /decl/material/solid/leather/chitin
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_VERY_LIGHT
	brute_armor = 2

/decl/material/solid/skin/fur
	name = "fur"
	color = "#7a726d"
	tans_to = /decl/material/solid/leather/fur

/decl/material/solid/skin/fur/gray

/decl/material/solid/skin/fur/white

/decl/material/solid/skin/fur/orange
	color = COLOR_ORANGE

/decl/material/solid/skin/fur/black
	color = COLOR_GRAY20

/decl/material/solid/skin/fur/heavy
	color = COLOR_GUNMETAL

/decl/material/solid/skin/goat
	color = COLOR_SILVER

/decl/material/solid/skin/cow
	color = COLOR_GRAY40

/decl/material/solid/skin/shark
	name = "sharkskin"
	color = COLOR_PURPLE_GRAY

/decl/material/solid/skin/fish
	color = COLOR_BOTTLE_GREEN
	name = "fishskin"

/decl/material/solid/skin/fish/purple
	color = COLOR_PALE_PURPLE_GRAY

/decl/material/solid/skin/feathers
	name = "feathers"
	color = COLOR_SILVER

/decl/material/solid/skin/feathers/purple
	color = COLOR_PALE_PURPLE_GRAY

/decl/material/solid/skin/feathers/blue
	color = COLOR_SKY_BLUE

/decl/material/solid/skin/feathers/green
	color = COLOR_BOTTLE_GREEN

/decl/material/solid/skin/feathers/brown
	color = COLOR_BEASTY_BROWN

/decl/material/solid/skin/feathers/red
	color = COLOR_RED

/decl/material/solid/skin/feathers/black
	color = COLOR_GRAY15

/decl/material/solid/bone
	name = "bone"
	sheet_singular_name = "length"
	sheet_plural_name = "lengths"
	color = "#f0edc7"
	stack_type = /obj/item/stack/material/generic/bone
	ignition_point = T0C+1100
	melting_point = T0C+1800
	conductive = 0
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	hitsound = 'sound/weapons/smash.ogg'
	integrity = 75
	hardness = MAT_VALUE_RIGID
	reflectiveness = MAT_VALUE_MATTE
	weight = MAT_VALUE_NORMAL
	wall_support_value = MAT_VALUE_NORMAL

/decl/material/solid/bone/fish
	name = "fishbone"
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT

/decl/material/solid/bone/cartilage
	name = "cartilage"
	hardness = 0
	weight = MAT_VALUE_EXTREMELY_LIGHT

/decl/material/solid/leather
	name = "leather"
	color = "#5c4831"
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
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT

/decl/material/solid/leather/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/cloak(src)
	. += new/datum/stack_recipe/shoes(src)
	. += new/datum/stack_recipe/boots(src)

/decl/material/solid/leather/synth
	name = "synthleather"
	color = "#1f1f20"
	ignition_point = T0C+150
	melting_point = T0C+100

/decl/material/solid/leather/lizard
	name = "scaled hide"
	color = "#434b31"
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_LIGHT
	reflectiveness = MAT_VALUE_SHINY

/decl/material/solid/leather/fur
	name = "tanned pelt"

/decl/material/solid/leather/chitin
	name = "treated chitin"
	integrity = 100
	color = "#5c5a54"
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_NORMAL
	brute_armor = 2
	wall_support_value = MAT_VALUE_NORMAL
