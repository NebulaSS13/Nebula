/decl/material/solid/wood
	name = "wood"
	uid = "solid_wood"
	liquid_name = "wood pulp"
	lore_text = "A fibrous structural material harvested from an indeterminable plant. Don't get a splinter."
	adjective_name = "wooden"
	color = WOOD_COLOR_GENERIC
	integrity = 75
	icon_base = 'icons/turf/walls/wood.dmi'
	wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	wall_blend_icons = list(
		'icons/turf/walls/solid.dmi' = TRUE,
		'icons/turf/walls/stone.dmi' = TRUE,
		'icons/turf/walls/metal.dmi' = TRUE
	)
	table_icon_base = "wood"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = MAT_VALUE_FLEXIBLE + 10
	brute_armor = 1
	weight = MAT_VALUE_NORMAL
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = "{'materials':1,'biotech':1}"
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	hitsound = 'sound/effects/woodhit.ogg'
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	dissolves_into = list(
		/decl/material/solid/carbon = 0.66,
		/decl/material/liquid/water = 0.34
	)
	value = 1.5
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = MAT_VALUE_NORMAL
	fuel_value = 0.8
	default_solid_form = /obj/item/stack/material/plank
	sound_manipulate = 'sound/foley/woodpickup1.ogg'
	sound_dropped = 'sound/foley/wooddrop1.ogg'

/decl/material/solid/wood/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return

	if(wall_support_value >= 10)
		. += new/datum/stack_recipe/furniture/girder(src)
		. += new/datum/stack_recipe/furniture/ladder(src)

	. += new/datum/stack_recipe/sandals(src)
	. += new/datum/stack_recipe/tile/wood(src)
	. += create_recipe_list(/datum/stack_recipe/furniture/chair/wood)
	. += new/datum/stack_recipe/furniture/sofa/m(src)
	. += new/datum/stack_recipe/furniture/sofa/l(src)
	. += new/datum/stack_recipe/furniture/sofa/r(src)
	. += new/datum/stack_recipe/crossbowframe(src)
	. += new/datum/stack_recipe/furniture/coffin/wooden(src)
	. += new/datum/stack_recipe/beehive_assembly(src)
	. += new/datum/stack_recipe/beehive_frame(src)
	. += new/datum/stack_recipe/furniture/bookcase(src)
	. += new/datum/stack_recipe/furniture/book_cart(src)
	. += new/datum/stack_recipe/zipgunframe(src)
	. += new/datum/stack_recipe/coilgun(src)
	. += new/datum/stack_recipe/stick(src)
	. += new/datum/stack_recipe/noticeboard(src)
	. += new/datum/stack_recipe/prosthetic/left_arm(src)
	. += new/datum/stack_recipe/prosthetic/right_arm(src)
	. += new/datum/stack_recipe/prosthetic/left_leg(src)
	. += new/datum/stack_recipe/prosthetic/right_leg(src)
	. += new/datum/stack_recipe/prosthetic/left_hand(src)
	. += new/datum/stack_recipe/prosthetic/right_hand(src)
	. += new/datum/stack_recipe/prosthetic/left_foot(src)
	. += new/datum/stack_recipe/prosthetic/right_foot(src)
	. += new/datum/stack_recipe/campfire(src)

/decl/material/solid/wood/mahogany/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/tile/mahogany(src)

/decl/material/solid/wood/maple/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/tile/maple(src)

/decl/material/solid/wood/ebony/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/tile/ebony(src)

/decl/material/solid/wood/walnut/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/tile/walnut(src)

/decl/material/solid/wood/holographic
	uid = "solid_holographic_wood"
	color = WOOD_COLOR_CHOCOLATE //the very concept of wood should be brown
	shard_type = SHARD_NONE
	value = 0
	hidden_from_codex = TRUE
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/wood/holographic/get_recipes(reinf_mat)
	return list()

/decl/material/solid/wood/mahogany
	name = "mahogany"
	uid = "solid_mahogany"
	adjective_name = "mahogany"
	lore_text = "Mahogany is prized for its beautiful grain and rich colour, and as such is typically used for fine furniture and cabinetry."
	color = WOOD_COLOR_RICH
	construction_difficulty = MAT_VALUE_HARD_DIY
	value = 1.6

/decl/material/solid/wood/maple
	name = "maple"
	uid = "solid_maple"
	adjective_name = "maple"
	lore_text = "Owing to its fast growth and ease of working, silver maple is a popular wood for flooring and furniture."
	color = WOOD_COLOR_PALE
	value = 1.8

/decl/material/solid/wood/ebony
	name = "ebony"
	uid = "solid_ebony"
	adjective_name = "ebony"
	lore_text = "Ebony is the name for a group of dark coloured, extremely dense, and fine grained hardwoods. \
				Despite gene modification to produce larger source trees and ample land to plant them on, \
				genuine ebony remains a luxury for the very wealthy thanks to the price fixing efforts of intergalactic luxuries cartels. \
				Most people will only ever touch ebony in small items, such as chess pieces, or the accent pieces of a fine musical instrument."
	color = WOOD_COLOR_BLACK
	weight = MAT_VALUE_HEAVY
	integrity = 100
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	value = 1.8

/decl/material/solid/wood/walnut
	name = "walnut"
	uid = "solid_walnut"
	adjective_name = "walnut"
	lore_text = "Walnut is a dense hardwood that polishes to a very fine finish. \
				Walnut is especially favoured for construction of figurines (where it contrasts with lighter coloured woods) and tables. \
				The ultimate aspiration of many professionals is an office with a vintage walnut desk, the bigger and heavier the better."
	color = WOOD_COLOR_CHOCOLATE
	weight = MAT_VALUE_NORMAL
	construction_difficulty = MAT_VALUE_HARD_DIY

/decl/material/solid/wood/bamboo
	name = "bamboo"
	uid = "solid_bamboo"
	liquid_name = "bamboo pulp"
	adjective_name = "bamboo"
	lore_text = "Bamboo is a fast-growing grass which can be used similar to wood after processing. Due to its swift growth \
				and high strength, various species of bamboo area common building materials in developing societies."
	color = WOOD_COLOR_PALE2
	weight = MAT_VALUE_VERY_LIGHT
	hardness = MAT_VALUE_RIGID

/decl/material/solid/wood/yew
	name = "yew"
	uid = "solid_yew"
	adjective_name = "yew"
	lore_text = "Although favoured in days past for the construction of bows, yew has a multitude of uses, including medicine. The yew \
				tree can live for nearly a thousand years thanks to its natural disease resistance."
	color = WOOD_COLOR_YELLOW
	dissolves_into = list(
		/decl/material/solid/carbon = 0.6,
		/decl/material/liquid/water = 0.3,
		/decl/material/liquid/heartstopper = 0.1
	)
	value = 1.8
