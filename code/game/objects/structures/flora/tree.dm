//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = 1
	density = 1
	pixel_x = -16
	layer = ABOVE_HUMAN_LAYER
	var/protects_against_weather = FALSE

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	protects_against_weather = TRUE

/obj/structure/flora/tree/pine/Initialize()
	. = ..()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name = "\improper Christmas tree"
	desc = "O Christmas tree, O Christmas tree..."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/Initialize()
	. = ..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/Initialize()
	. = ..()
	icon_state = "tree_[rand(1, 6)]"
