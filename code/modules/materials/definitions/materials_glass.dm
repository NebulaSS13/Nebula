
/material/glass
	display_name = "glass"
	lore_text = "A brittle, transparent material made from molten silicates. It is generally not a liquid."
	stack_type = /obj/item/stack/material/glass
	flags = MAT_FLAG_BRITTLE
	icon_colour = GLASS_COLOR
	opacity = 0.3
	integrity = 50
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = MAT_VALUE_RIGID + 10	
	reflectiveness = MAT_VALUE_SHINY
	melting_point = T0C + 100
	weight = MAT_VALUE_VERY_LIGHT
	brute_armor = 1
	burn_armor = 2
	door_icon_base = "stone"
	table_icon_base = "solid"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 4, "Windoor" = 5)
	hitsound = 'sound/effects/Glasshit.ogg'
	conductive = 0
	wall_support_value = 14

/material/glass/proc/is_reinforced()
	return (integrity > 75) //todo

/material/glass/is_brittle()
	return ..() && !is_reinforced()

/material/glass/phoron
	display_name = "borosilicate glass"
	lore_text = "An extremely heat-resistant form of glass."
	stack_type = /obj/item/stack/material/glass/phoronglass
	flags = MAT_FLAG_BRITTLE
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_LIGHT
	integrity = 70
	brute_armor = 2
	burn_armor = 5
	melting_point = T0C + 4000
	icon_colour = GLASS_COLOR_PHORON
	stack_origin_tech = "{'materials':4}"
	wire_product = null
	construction_difficulty = MAT_VALUE_HARD_DIY
	alloy_product = TRUE
	alloy_materials = list(MAT_GLASS = 2500, MAT_PLATINUM = 1250)
	value = 1.8