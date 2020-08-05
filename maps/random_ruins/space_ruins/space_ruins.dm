// Hey! Listen! Update \config\space_ruin_blacklist.txt with your new ruins!
/turf/simulated/wall/diamond
	color = COLOR_SKY_BLUE
	icon_state = "stone"
	material = /decl/material/solid/gemstone/diamond

/datum/map_template/ruin/space
	prefix = "maps/random_ruins/space_ruins/"
	cost = 1

/datum/map_template/ruin/space/multi_zas_test
	name = "Multi-ZAS Test"
	id = "multi_zas_test"
	description = "if this has vacuum in it, that's not good!"
	suffixes = list("multi_zas_test.dmm")
	cost = 1