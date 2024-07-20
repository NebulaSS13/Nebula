/decl/material/solid/organic/meat
	name = "meat"
	codex_name = "animal protein"
	uid = "solid_meat"
	taste_description = "umami"
	color = "#c03b2a"
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	conductive = 1
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
	fishing_bait_value = 1
	nutriment_animal = TRUE
	reagent_overlay = "soup_chunks"
	nutriment_factor = 10

/decl/material/solid/organic/meat/egg
	name = "egg yolk"
	codex_name = "egg yolk"
	taste_description = "egg"
	color = "#ffffaa"
	uid = "solid_egg"
	melting_point = 273
	boiling_point = 373
	reagent_overlay = "soup_dumplings"

/decl/material/solid/organic/meat/fish
	name  = "fish meat"
	codex_name = "fish protein"
	uid = "solid_meat_fish"
	color = "#ff9b9b"

/decl/material/solid/organic/meat/chicken
	name  = "chicken meat"
	codex_name = "chicken protein"
	uid = "solid_meat_chicken"
	color = "#e98a8a"

/decl/material/solid/organic/meat/gut
	name = "gut"
	codex_name = null
	uid = "solid_gut"
	color = "#ffd6d6"
	tans_to = /decl/material/solid/organic/leather/gut

/decl/material/solid/organic/skin
	name = "skin"
	uid = "solid_skin"
	color = "#9e8c72"
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
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
	fishing_bait_value = 0.75
	tans_to = /decl/material/solid/organic/leather
	compost_value = 0.8
	nutriment_animal = TRUE

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
	fishing_bait_value = 0

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

/decl/material/solid/organic/skin/fur/brown
	color = COLOR_DARK_BROWN
	uid = "solid_fur_brown"

/decl/material/solid/organic/skin/fur/heavy
	color = COLOR_GUNMETAL
	uid = "solid_fur_heavy"

/decl/material/solid/organic/skin/goat
	color = COLOR_SILVER
	uid = "solid_skin_goat"

/decl/material/solid/organic/skin/cow
	color = COLOR_GRAY40
	uid = "solid_skin_cow"

/decl/material/solid/organic/skin/deer
	color = COLOR_BROWN
	uid = "solid_skin_deer"

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
	fishing_bait_value = 0

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
	compost_value = 0.5
	nutriment_animal = TRUE

// Stub to stop eggs melting while being boiled.
/decl/material/solid/organic/bone/eggshell
	name                   = "eggshell"
	uid                    = "solid_eggshell"
	color                  = "#eae0c8"
	default_solid_form     = /obj/item/stack/material/lump
	hardness               = MAT_VALUE_FLEXIBLE
	weight                 = MAT_VALUE_VERY_LIGHT
	exoplanet_rarity_gas   = MAT_RARITY_NOWHERE
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE

// Stub for earrings. TODO: put it in clams
/decl/material/solid/organic/bone/pearl
	name                   = "pearl"
	uid                    = "solid_pearl"
	color                  = "#eae0c8"
	default_solid_form     = /obj/item/stack/material/lump
	hardness               = MAT_VALUE_FLEXIBLE
	weight                 = MAT_VALUE_VERY_LIGHT
	exoplanet_rarity_gas   = MAT_RARITY_NOWHERE
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE

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
