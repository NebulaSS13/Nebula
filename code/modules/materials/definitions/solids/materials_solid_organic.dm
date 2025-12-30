/decl/material/solid/organic
	abstract_type = /decl/material/solid/organic
	ignition_point = T0C+500 // Based on loose ignition temperature of plastic
	accelerant_value = 0.1
	burn_product = /decl/material/gas/carbon_monoxide
	boiling_point = null
	melting_point = null
	compost_value = 1
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
/* TODO: burn products for solids
	bakes_into_at_temperature = T0C+500
	bakes_into_material = /decl/material/solid/carbon
*/

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
	stack_origin_tech = @'{"materials":3}'
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
	tensile_strength = 0.75
	compost_value = 0

/decl/material/solid/organic/plastic/foam
	name = "foam"
	lore_text = "A plastic polymer in a sponge-like form, filled with air bubbles that make it springy and compressible."
	hardness = MAT_VALUE_SOFT + 5
	taste_description = "foam"
	color = COLOR_BLUE_GRAY // dunno why foam is this gray-teal color in my mind, but it is. maybe gray would also work
	uid = "solid_foam"

/decl/material/solid/organic/wax
	name = "wax"
	uid = "solid_wax"
	taste_description = "waxy blandness"
	lore_text = "A soft, easily melted substance produced by bees. Used to make candles."
	accelerant_value = 0.6
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_SHINY
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	default_solid_form = /obj/item/stack/material/bar
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'
	color = "#fffccc"
	door_icon_base = "plastic"
	hardness = MAT_VALUE_FLEXIBLE - 10
	weight = MAT_VALUE_LIGHT
	melting_point = 363
	ignition_point = 473
	boiling_point = 643
	compost_value = 0.2
	paint_verb = "colored"
	exoplanet_rarity_plant = MAT_RARITY_MUNDANE

/decl/material/solid/organic/plastic/holographic
	name = "holographic plastic"
	uid = "solid_holographic_plastic"
	holographic = TRUE

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
	hardness = MAT_VALUE_SOFT+5
	brute_armor = 1
	weight = MAT_VALUE_EXTREMELY_LIGHT - 5
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	stack_origin_tech = @'{"materials":1}'
	door_icon_base = "wood"
	destruction_desc = "crumples"
	destruction_sound = "pageturn"
	conductive = 0
	value = 0.5
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	default_solid_form = /obj/item/stack/material/cardstock
	exoplanet_rarity_plant = MAT_RARITY_EXOTIC
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'
	compost_value = 0.8

/decl/material/solid/organic/paper
	name                    = "paper"
	uid                     = "solid_paper"
	lore_text               = "Low tech writing medium made from cellulose fibers. Also used in wrappings and packaging."
	color                   = "#cfcece"
	stack_origin_tech       = @'{"materials":1}'
	door_icon_base          = "wood"
	destruction_desc        = "tears"
	destruction_sound       = "pageturn"
	icon_base               = 'icons/turf/walls/solid.dmi'
	icon_reinf              = 'icons/turf/walls/reinforced.dmi'
	integrity               = 10 //Probably don't wanna go below 10, because of the health multiplier on things, that would result in a value smaller than 1.
	use_reinf_state         = null
	flags                   = MAT_FLAG_BRITTLE
	reflectiveness          = MAT_VALUE_DULL
	hardness                = MAT_VALUE_FLEXIBLE-5
	wall_support_value      = MAT_VALUE_EXTREMELY_LIGHT - 9
	weight                  = MAT_VALUE_EXTREMELY_LIGHT - 9
	construction_difficulty = MAT_VALUE_EASY_DIY
	wall_flags              = PAINT_PAINTABLE | PAINT_STRIPABLE | WALL_HAS_EDGES
	brute_armor             = 0.5
	ignition_point          = T0C + 232 //"the temperature at which book-paper catches fire, and burns." close enough
	conductive              = FALSE
	value                   = 0.25
	default_solid_form      = /obj/item/stack/material/bolt
	shard_name              = SHARD_NONE
	shard_type              = /obj/item/shreddedp
	exoplanet_rarity_plant  = MAT_RARITY_EXOTIC
	sound_manipulate        = 'sound/foley/paperpickup2.ogg'
	sound_dropped           = 'sound/foley/paperpickup1.ogg'
	compost_value = 0.8
	paint_verb = "painted"

/decl/material/solid/organic/cloth
	name = "cotton"
	uid = "solid_cotton"
	color = "#ffffff"
	stack_origin_tech = @'{"materials":2}'
	door_icon_base = "wood"
	ignition_point = T0C+232
	flags = MAT_FLAG_PADDING
	brute_armor = 1
	conductive = 0
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_DULL
	hardness = MAT_VALUE_SOFT+5
	weight = MAT_VALUE_EXTREMELY_LIGHT
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	default_solid_form = /obj/item/stack/material/bolt
	dug_drop_type = /obj/item/stack/material/bolt
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'
	compost_value = 0.8
	has_textile_fibers = TRUE
	paint_verb = "dyed"

/decl/material/solid/organic/cloth/hemp
	name           = "hemp"
	adjective_name = "hempen"
	lore_text      = "Sturdy fibers from the hemp plant, woven into strong cloth."
	uid            = "solid_hemp"
	color          = "#b4a374"

/decl/material/solid/organic/cloth/linen
	name      = "linen"
	lore_text = "Fibers from the flax plant, woven into sturdy, absorbent cloth."
	uid       = "solid_linen"
	color     = "#eee4c7"

/decl/material/solid/organic/cloth/wool
	name           = "wool"
	adjective_name = "woolen"
	lore_text      = "Fibers from the wooly fleece of a sheep or similar animal."
	uid            = "solid_wool"
	color          = "#fbfcdb"

/decl/material/solid/organic/cloth/wool/diyaab
	name           = "diyaab wool"
	adjective_name = null // override base wool
	lore_text      = "Fibers from the wooly fleece of a diyaab."
	uid            = "solid_wool_diyaab"
	color          = "#c9eeff"

/decl/material/solid/organic/cloth/synthetic
	name = "nylon"
	uid = "solid_cloth_synthetic"
	melting_point = T0C+300 // plastic
	compost_value = 0

/decl/material/solid/organic/plantmatter
	name = "plant matter"
	uid = "solid_plantmatter"
	color = COLOR_GREEN_GRAY
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	conductive = 1
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_EASY_DIY
	integrity = 70
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_NORMAL
	explosion_resistance = 1
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = MAT_VALUE_LIGHT
	value = 0.8
	default_solid_form = /obj/item/stack/material/slab
	dug_drop_type = /obj/item/stack/material/slab
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'
	fishing_bait_value = 0.75
	allergen_flags = ALLERGEN_VEGETABLE
	exoplanet_rarity_plant = MAT_RARITY_MUNDANE

/// Used for plant products that aren't quite wood, but are still tougher than normal plant matter.
/decl/material/solid/organic/plantmatter/pith
	name = "plant pith"
	uid = "solid_plantpith"
	melting_point = null
	hardness = MAT_VALUE_FLEXIBLE
	value = 0.4

/decl/material/solid/organic/plantmatter/pith/husk
	name = "plant husk"
	uid = "solid_planthusk"

/decl/material/solid/organic/plantmatter/grass
	name = "grass"
	uid = "solid_grass"
	default_solid_form = /obj/item/stack/material/bundle
	melting_point = null // can grass melt??
	ignition_point = T0C+100
	tans_to = /decl/material/solid/organic/plantmatter/grass/dry
	tensile_strength = 0.2
	dug_drop_type = /obj/item/stack/material/bundle/grass // Sets drying_wetness etc

/decl/material/solid/organic/plantmatter/grass/dry
	name = "dried grass"
	uid = "solid_dry_grass"
	color = COLOR_BEIGE
	ignition_point = T0C+50
	tensile_strength = 0.5
	compost_value = 0.5
	dug_drop_type = /obj/item/stack/material/bundle // Unsets drying_wetness etc

/decl/material/solid/organic/leather
	name = "leather"
	uid = "solid_leather"
	color = "#5c4831"
	stack_origin_tech = @'{"materials":2}'
	flags = MAT_FLAG_PADDING
	ignition_point = T0C+300
	conductive = 0
	hidden_from_codex = TRUE
	construction_difficulty = MAT_VALUE_HARD_DIY
	integrity = 50
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_EXTREMELY_LIGHT
	reflectiveness = MAT_VALUE_MATTE
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	default_solid_form = /obj/item/stack/material/skin
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'
	tensile_strength = 0.8 // TODO: dried sinew? Should this be crappier than plastic/metal?
	compost_value = 0.2

/decl/material/solid/organic/leather/gut
	name = "dried gut"
	uid = "solid_dried_gut"
	color = "#736754"

/decl/material/solid/organic/leather/synth
	name = "synthleather"
	uid = "solid_synthleather"
	color = "#1f1f20"
	ignition_point = T0C+150
	melting_point = T0C+100 // Assuming synthetic leather.
	compost_value = 0
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE

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
	paint_verb = "dyed"

/decl/material/solid/organic/leather/chitin
	name = "treated chitin"
	uid = "solid_treated_chitin"
	integrity = 100
	color = "#5c5a54"
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_NORMAL
	brute_armor = 2
	wall_support_value = MAT_VALUE_NORMAL
