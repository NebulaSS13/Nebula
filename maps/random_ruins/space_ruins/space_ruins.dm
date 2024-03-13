// Hey! Listen! Update \config\space_ruin_blacklist.txt with your new ruins!
/turf/wall/diamond
	color = COLOR_SKY_BLUE
	icon_state = "stone"
	material = /decl/material/solid/gemstone/diamond

/datum/map_template/ruin/space
	template_categories = list(MAP_TEMPLATE_CATEGORY_SPACE)
	prefix = "maps/random_ruins/space_ruins/"
	cost = 1

/datum/map_template/ruin/space/multi_zas_test
	name = "Multi-ZAS Test"
	description = "if this has vacuum in it, that's not good!"
	suffixes = list("multi_zas_test.dmm")
	cost = 1