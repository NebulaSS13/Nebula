/decl/material/solid/organic
	abstract_type = /decl/material/solid/organic
	ignition_point = T0C+500 // Based on loose ignition temperature of plastic
	accelerant_value = 0.1
	burn_product = /decl/material/gas/carbon_monoxide

/decl/material/solid/organic/plastic
	name = "plastic"
	uid = "solid_plastic"
	lore_text = "A generic polymeric material. Probably the most flexible and useful substance ever created by human science; mostly used to make disposable cutlery."
	flags = MAT_FLAG_BRITTLE
	icon_base = 'icons/turf/walls/plastic.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = 0
	use_reinf_state = null
	color = COLOR_EGGSHELL
	door_icon_base = "plastic"
	hardness = MAT_VALUE_FLEXIBLE + 10
	weight = MAT_VALUE_LIGHT
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = "{'materials':3}"
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_SHINY
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	taste_description = "plastic"
	accelerant_value = 0.6
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	default_solid_form = /obj/item/stack/material/panel
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/plastic/generate_recipes(var/reinforce_material)
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

/decl/material/solid/organic/plastic/holographic
	name = "holographic plastic"
	uid = "solid_holographic_plastic"
	shard_type = SHARD_NONE
	hidden_from_codex = TRUE
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/organic/plastic/holographic/get_recipes(reinf_mat)
	return list()

/decl/material/solid/organic/cardboard
	name = "cardboard"
	uid = "solid_cardboard"
	lore_text = "What with the difficulties presented by growing plants in orbit, a stock of cardboard in space is probably more valuable than gold."
	flags = MAT_FLAG_BRITTLE
	integrity = 10
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	use_reinf_state = null
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
	default_solid_form = /obj/item/stack/material/cardstock
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/cardboard/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += create_recipe_list(/datum/stack_recipe/box)
	. += new/datum/stack_recipe/cardborg_suit(src)
	. += new/datum/stack_recipe/cardborg_helmet(src)
	. += new/datum/stack_recipe_list("folders", create_recipe_list(/datum/stack_recipe/folder))

/decl/material/solid/organic/paper
	name                    = "paper"
	uid                     = "solid_paper"
	lore_text               = "Low tech writing medium made from cellulose fibers. Also used in wrappings and packaging."
	color                   = "#cfcece"
	stack_origin_tech       = "{'materials':1}"
	door_icon_base          = "wood"
	destruction_desc        = "tears"
	icon_base               = 'icons/turf/walls/solid.dmi'
	icon_reinf              = 'icons/turf/walls/reinforced.dmi'
	integrity               = 10 //Probably don't wanna go below 10, because of the health multiplier on things, that would result in a value smaller than 1.
	use_reinf_state         = null
	flags                   = MAT_FLAG_BRITTLE
	reflectiveness          = MAT_VALUE_DULL
	hardness                = MAT_VALUE_SOFT - 5
	wall_support_value      = MAT_VALUE_EXTREMELY_LIGHT - 9
	weight                  = MAT_VALUE_EXTREMELY_LIGHT - 9
	construction_difficulty = MAT_VALUE_EASY_DIY
	wall_flags              = PAINT_PAINTABLE | PAINT_STRIPABLE | WALL_HAS_EDGES
	brute_armor             = 0.5
	ignition_point          = T0C + 232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point           = T0C + 232
	conductive              = FALSE
	value                   = 0.25
	default_solid_form      = /obj/item/stack/material/bolt
	shard_type              = /obj/item/shreddedp
	exoplanet_rarity_plant  = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas    = MAT_RARITY_NOWHERE
	sound_manipulate        = 'sound/foley/paperpickup2.ogg'
	sound_dropped           = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/paper/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/paper_sheets(src)

/decl/material/solid/organic/cloth //todo
	name = "cotton"
	uid = "solid_cotton"
	use_name = "cotton"
	color = "#ffffff"
	stack_origin_tech = "{'materials':2}"
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MAT_FLAG_PADDING
	brute_armor = 1
	conductive = 0
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_DULL
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	default_solid_form = /obj/item/stack/material/bolt
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/cloth/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/cloak(src)
	. += new/datum/stack_recipe/banner(src)

/decl/material/solid/organic/cloth/yellow
	name = "yellow"
	uid = "solid_cotton_yellow"
	use_name = "yellow cloth"
	adjective_name = "yellow"
	color = "#ffbf00"

/decl/material/solid/organic/cloth/teal
	name = "teal"
	uid = "solid_cotton_teal"
	use_name = "teal cloth"
	adjective_name = "teal"
	color = "#00e1ff"

/decl/material/solid/organic/cloth/black
	name = "black"
	uid = "solid_cotton_black"
	use_name = "black cloth"
	adjective_name = "black"
	color = "#505050"

/decl/material/solid/organic/cloth/green
	name = "green"
	uid = "solid_cotton_green"
	use_name = "green cloth"
	adjective_name = "green"
	color = "#b7f27d"

/decl/material/solid/organic/cloth/purple
	name = "purple"
	uid = "solid_cotton_purple"
	use_name = "purple cloth"
	adjective_name = "purple"
	color = "#9933ff"

/decl/material/solid/organic/cloth/blue
	name = "blue"
	uid = "solid_cotton_blue"
	use_name = "blue cloth"
	adjective_name = "blue"
	color = "#46698c"

/decl/material/solid/organic/cloth/beige
	name = "beige"
	uid = "solid_cotton_beige"
	use_name = "beige cloth"
	adjective_name = "beige"
	color = "#ceb689"

/decl/material/solid/organic/cloth/lime
	name = "lime"
	uid = "solid_cotton_lime"
	use_name = "lime cloth"
	adjective_name = "lime"
	color = "#62e36c"

/decl/material/solid/organic/cloth/red
	name = "red"
	uid = "solid_cotton_red"
	use_name = "red cloth"
	adjective_name = "red"
	color = "#9d2300"

/decl/material/solid/organic/carpet
	name = "red"
	uid = "solid_carpet"
	use_name = "red upholstery"
	adjective_name = "red"
	color = "#9d2300"
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_DULL
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	hidden_from_codex = TRUE
	default_solid_form = /obj/item/stack/material/bolt
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/plantmatter
	name = "plant matter"
	uid = "solid_plantmatter"
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
	default_solid_form = /obj/item/stack/material/slab
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/meat
	name = "meat"
	uid = "solid_meat"
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
	default_solid_form = /obj/item/stack/material/slab
	sound_manipulate = 'sound/foley/meat1.ogg'
	sound_dropped = 'sound/foley/meat2.ogg'
	hitsound = 'sound/effects/squelch1.ogg'

/decl/material/solid/organic/skin
	name = "skin"
	uid = "solid_skin"
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
	default_solid_form = /obj/item/stack/material/skin
	sound_manipulate = 'sound/foley/meat1.ogg'
	sound_dropped = 'sound/foley/meat2.ogg'
	hitsound = "punch"
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	var/tans_to = /decl/material/solid/organic/leather

/decl/material/solid/organic/skin/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/cloak(src)
	. += new/datum/stack_recipe/banner(src)
	. += new/datum/stack_recipe/shoes(src)

/decl/material/solid/organic/skin/lizard
	name = "lizardskin"
	uid = "solid_lizardskin"
	color = "#626952"
	tans_to = /decl/material/solid/organic/leather/lizard
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/organic/skin/insect
	name = "chitin"
	uid = "solid_chitin"
	color = "#7a776d"
	tans_to = /decl/material/solid/organic/leather/chitin
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_VERY_LIGHT
	brute_armor = 2
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/skin/fur
	name = "fur"
	uid = "solid_fur"
	color = "#7a726d"
	tans_to = /decl/material/solid/organic/leather/fur
	default_solid_form = /obj/item/stack/material/skin/pelt
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/skin/fur/gray
	uid = "solid_fur_gray"

/decl/material/solid/organic/skin/fur/white
	uid = "solid_fur_white"

/decl/material/solid/organic/skin/fur/orange
	color = COLOR_ORANGE
	uid = "solid_fur_orange"

/decl/material/solid/organic/skin/fur/black
	color = COLOR_GRAY20
	uid = "solid_fur_black"

/decl/material/solid/organic/skin/fur/heavy
	color = COLOR_GUNMETAL
	uid = "solid_fur_heavy"

/decl/material/solid/organic/skin/goat
	color = COLOR_SILVER
	uid = "solid_skin_goat"

/decl/material/solid/organic/skin/cow
	color = COLOR_GRAY40
	uid = "solid_skin_cow"

/decl/material/solid/organic/skin/shark
	name = "sharkskin"
	color = COLOR_PURPLE_GRAY
	uid = "solid_skin_shark"

/decl/material/solid/organic/skin/fish
	color = COLOR_BOTTLE_GREEN
	name = "fishskin"
	uid = "solid_skin_fish"

/decl/material/solid/organic/skin/fish/purple
	color = COLOR_PALE_PURPLE_GRAY
	uid = "solid_skin_carp"

/decl/material/solid/organic/skin/feathers
	name = "feathers"
	uid = "solid_feathers"
	color = COLOR_SILVER
	default_solid_form = /obj/item/stack/material/skin/feathers
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/skin/feathers/purple
	color = COLOR_PALE_PURPLE_GRAY
	uid = "solid_feathers_purple"

/decl/material/solid/organic/skin/feathers/blue
	color = COLOR_SKY_BLUE
	uid = "solid_feathers_blue"

/decl/material/solid/organic/skin/feathers/green
	color = COLOR_BOTTLE_GREEN
	uid = "solid_feathers_green"

/decl/material/solid/organic/skin/feathers/brown
	color = COLOR_BEASTY_BROWN
	uid = "solid_feathers_brown"

/decl/material/solid/organic/skin/feathers/red
	color = COLOR_RED
	uid = "solid_feathers_red"

/decl/material/solid/organic/skin/feathers/black
	color = COLOR_GRAY15
	uid = "solid_feathers_black"

/decl/material/solid/organic/bone
	name = "bone"
	uid = "solid_bone"
	color = "#f0edc7"
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
	default_solid_form = /obj/item/stack/material/bone
	sound_manipulate = 'sound/foley/stickspickup1.ogg'
	sound_dropped = 'sound/foley/sticksdrop1.ogg'

/decl/material/solid/organic/bone/generate_recipes(var/reinforce_material)
	. = ..()
	if(!reinforce_material && wall_support_value >= 10)
		. += new/datum/stack_recipe/furniture/girder(src)
		. += new/datum/stack_recipe/furniture/ladder(src)

/decl/material/solid/organic/bone/fish
	name = "fishbone"
	uid = "solid_fishbone"
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/organic/bone/cartilage
	name = "cartilage"
	uid = "solid_cartilage"
	hardness = 0
	weight = MAT_VALUE_EXTREMELY_LIGHT
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/organic/leather
	name = "leather"
	uid = "solid_leather"
	color = "#5c4831"
	stack_origin_tech = "{'materials':2}"
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	integrity = 50
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_EXTREMELY_LIGHT
	reflectiveness = MAT_VALUE_MATTE
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	default_solid_form = /obj/item/stack/material/skin
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/solid/organic/leather/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/cloak(src)
	. += new/datum/stack_recipe/banner(src)
	. += new/datum/stack_recipe/shoes(src)
	. += new/datum/stack_recipe/boots(src)

/decl/material/solid/organic/leather/synth
	name = "synthleather"
	uid = "solid_synthleather"
	color = "#1f1f20"
	ignition_point = T0C+150
	melting_point = T0C+100

/decl/material/solid/organic/leather/lizard
	name = "scaled hide"
	uid = "solid_scaled_hide"
	color = "#434b31"
	integrity = 75
	hardness = MAT_VALUE_FLEXIBLE + 5
	weight = MAT_VALUE_LIGHT
	reflectiveness = MAT_VALUE_SHINY

/decl/material/solid/organic/leather/fur
	name = "tanned pelt"
	uid = "solid_tanned_pelt"

/decl/material/solid/organic/leather/chitin
	name = "treated chitin"
	uid = "solid_treated_chitin"
	integrity = 100
	color = "#5c5a54"
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_NORMAL
	brute_armor = 2
	wall_support_value = MAT_VALUE_NORMAL
