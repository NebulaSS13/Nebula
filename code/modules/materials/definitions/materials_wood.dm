/material/wood
	display_name = "wood"
	lore_text = "A fibrous structural material harvested from an indeterminable plant. Don't get a splinter."
	adjective_name = "wooden"
	stack_type = /obj/item/stack/material/wood
	icon_colour = WOOD_COLOR_GENERIC
	integrity = 75
	icon_base = "wood"
	table_icon_base = "wood"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = MAT_VALUE_FLEXIBLE + 10
	brute_armor = 1
	weight = MAT_VALUE_LIGHT
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = "{'materials':1,'biotech':1}"
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"
	hitsound = 'sound/effects/woodhit.ogg'
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	chem_products = list(
				/decl/reagent/carbon = 10,
				/decl/reagent/water = 5
				)
	value = 1.5
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = 22

/material/wood/holographic
	icon_colour = WOOD_COLOR_CHOCOLATE //the very concept of wood should be brown
	stack_type = null
	shard_type = SHARD_NONE
	value = 0
	hidden_from_codex = TRUE

/material/wood/holographic/get_recipes(reinf_mat)
	return list()

/material/wood/mahogany
	display_name = "mahogany"
	adjective_name = "mahogany"
	lore_text = "Mahogany is prized for its beautiful grain and rich colour, and as such is typically used for fine furniture and cabinetry."
	icon_colour = WOOD_COLOR_RICH
	construction_difficulty = MAT_VALUE_HARD_DIY
	value = 1.6

/material/wood/maple
	display_name = "maple"
	adjective_name = "maple"
	lore_text = "Owing to its fast growth and ease of working, silver maple is a popular wood for flooring and furniture."
	icon_colour = WOOD_COLOR_PALE
	value = 1.8

/material/wood/ebony
	display_name = "ebony"
	adjective_name = "ebony"
	lore_text = "Ebony is the name for a group of dark coloured, extremely dense, and fine grained hardwoods. \
				Despite gene modification to produce larger source trees and ample land to plant them on, \
				genuine ebony remains a luxury for the very wealthy thanks to the price fixing efforts of intergalactic luxuries cartels. \
				Most people will only ever touch ebony in small items, such as chess pieces, or the accent pieces of a fine musical instrument."
	icon_colour = WOOD_COLOR_BLACK
	weight = MAT_VALUE_HEAVY
	integrity = 100
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	value = 1.8

/material/wood/walnut
	display_name = "walnut"
	adjective_name = "walnut"
	lore_text = "Walnut is a dense hardwood that polishes to a very fine finish. \
				Walnut is especially favoured for construction of figurines (where it contrasts with lighter coloured woods) and tables. \
				The ultimate aspiration of many professionals is an office with a vintage walnut desk, the bigger and heavier the better."
	icon_colour = WOOD_COLOR_CHOCOLATE
	weight = MAT_VALUE_NORMAL
	construction_difficulty = MAT_VALUE_HARD_DIY

/material/wood/bamboo
	display_name = "bamboo"
	adjective_name = "bamboo"
	lore_text = "Bamboo is a fast-growing grass which can be used similar to wood after processing. Due to its swift growth \
				and high strength, various species of bamboo area common building materials in developing societies."
	icon_colour = WOOD_COLOR_PALE2
	weight = MAT_VALUE_VERY_LIGHT
	hardness = MAT_VALUE_RIGID

/material/wood/yew
	display_name = "yew"
	adjective_name = "yew"
	lore_text = "Although favoured in days past for the construction of bows, yew has a multitude of uses, including medicine. The yew \
				tree can live for nearly a thousand years thanks to its natural disease resistance."
	icon_colour = WOOD_COLOR_YELLOW
	chem_products = list(
				/decl/reagent/carbon = 10,
				/decl/reagent/water = 5,
				/decl/reagent/toxin/heartstopper = 0.05
				)
	value = 1.8
