/decl/material/solid/glass
	name = "glass"
	lore_text = "A brittle, transparent material made from molten silicates. It is generally not a liquid."
	stack_type = /obj/item/stack/material/glass
	flags = MAT_FLAG_BRITTLE
	color = GLASS_COLOR
	opacity = 0.3
	integrity = 50
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = MAT_VALUE_RIGID + 10
	door_icon_base = "metal"
	reflectiveness = MAT_VALUE_SHINY
	melting_point = T100C
	weight = MAT_VALUE_VERY_LIGHT
	brute_armor = 1
	burn_armor = 2
	table_icon_base = "solid"
	destruction_desc = "shatters"
	hitsound = 'sound/effects/Glasshit.ogg'
	conductive = 0
	wall_support_value = MAT_VALUE_LIGHT

/decl/material/solid/glass/proc/is_reinforced()
	return (integrity > 75) //todo

/decl/material/solid/glass/is_brittle()
	return ..() && !is_reinforced()

/decl/material/solid/glass/borosilicate
	name = "borosilicate glass"
	lore_text = "An extremely heat-resistant form of glass."
	stack_type = /obj/item/stack/material/glass/borosilicate
	flags = MAT_FLAG_BRITTLE
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_LIGHT
	integrity = 70
	brute_armor = 2
	burn_armor = 5
	melting_point = T0C + 4000
	color = GLASS_COLOR_SILICATE
	stack_origin_tech = "{'materials':4}"
	construction_difficulty = MAT_VALUE_HARD_DIY
	value = 1.8