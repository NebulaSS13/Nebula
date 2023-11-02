////////////////////////////////////////
// Stumps
////////////////////////////////////////
/obj/structure/flora/stump
	name = "stump"

/obj/structure/flora/stump/get_material_health_modifier()
	return 2.5 //Make stumps worth removing with shovels instead of bashing them

/obj/structure/flora/stump/can_cut_down(obj/item/I, mob/user)
	return IS_SHOVEL(I)

/obj/structure/flora/stump/cut_down(obj/item/I, mob/user)
	if(I.do_tool_interaction(TOOL_SHOVEL, user, src, 8 SECONDS))
		. = ..()

//Base tree stump
/obj/structure/flora/stump/tree
	name       = "tree stump"
	icon       = 'icons/obj/flora/tree_stumps.dmi'
	w_class    = ITEM_SIZE_HUGE
	pixel_x    = -16 //All trees are offset 16 pixels
	material   = /decl/material/solid/organic/wood

//dead trees
/obj/structure/flora/stump/tree/dead
	name       = "dead tree stump"
	icon_state = "tree_1"

/obj/structure/flora/stump/tree/dead/init_appearance()
	icon_state = "tree_[rand(1, 6)]"

//pine trees
/obj/structure/flora/stump/tree/pine
	icon_state = "pine_1"

/obj/structure/flora/stump/tree/pine/init_appearance()
	icon_state = "pine_[rand(1, 3)]"

//christmas tree
/obj/structure/flora/stump/tree/pine/xmas
	icon_state = "pine_c"
