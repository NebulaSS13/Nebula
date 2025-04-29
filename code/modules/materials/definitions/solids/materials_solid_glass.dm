/decl/material/solid/glass
	name = "glass"
	codex_name = "silica glass"
	uid = "solid_glass"
	lore_text = "A brittle, transparent material made from molten silicates. It is generally not a liquid."
	flags = MAT_FLAG_BRITTLE
	color = GLASS_COLOR
	opacity = 0.3
	integrity = 50
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = MAT_VALUE_RIGID + 10
	door_icon_base = "metal"
	reflectiveness = MAT_VALUE_SHINY
	melting_point = 1674
	boiling_point = null
	ignition_point = null
	weight = MAT_VALUE_VERY_LIGHT
	brute_armor = 1
	burn_armor = 2
	table_icon_base = "solid"
	destruction_desc = "shatters"
	destruction_sound = "shatter"
	hitsound = 'sound/effects/Glasshit.ogg'
	conductive = 0
	wall_support_value = MAT_VALUE_LIGHT
	default_solid_form = /obj/item/stack/material/pane
	dissolves_in = MAT_SOLVENT_IMMUNE
	dissolves_into = null

/decl/material/solid/glass/proc/is_reinforced()
	return (integrity > 75) //todo

/decl/material/solid/glass/is_brittle()
	return ..() && !is_reinforced()

/decl/material/solid/glass/borosilicate
	name = "heat-resistant glass"
	codex_name = null
	uid = "solid_borosilicate_glass"
	lore_text = "An extremely heat-resistant form of glass."
	flags = MAT_FLAG_BRITTLE
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_LIGHT
	integrity = 70
	brute_armor = 2
	burn_armor = 5
	melting_point = 4274
	color = GLASS_COLOR_SILICATE
	stack_origin_tech = @'{"materials":4}'
	construction_difficulty = MAT_VALUE_HARD_DIY
	value = 1.8

/decl/material/solid/fiberglass
	name = "fiberglass"
	uid = "solid_fiberglass"
	lore_text = "A form of glass-reinforced plastic made from glass fibers and a polymer resin."
	dissolves_into = list(
		/decl/material/solid/glass = 0.7,
		/decl/material/solid/organic/plastic = 0.3
	)
	color = COLOR_OFF_WHITE
	opacity = 0.6
	melting_point = 1674
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_LIGHT
	integrity = 120
	icon_base = 'icons/turf/walls/plastic.dmi'
	icon_reinf = 'icons/turf/walls/reinforced.dmi'
	wall_flags = 0
	use_reinf_state = null
	door_icon_base = "plastic"
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_LIGHT
	stack_origin_tech = @'{"materials":3}'
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_MATTE
	wall_support_value = MAT_VALUE_LIGHT
	burn_product = /decl/material/gas/carbon_monoxide
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	default_solid_form = /obj/item/stack/material/sheet/reinforced
	tensile_strength = 1.2 // very good for line
