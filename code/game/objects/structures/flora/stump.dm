////////////////////////////////////////
// Stumps
////////////////////////////////////////
/obj/structure/flora/stump
	name         = "stump"
	hitsound     = 'sound/effects/hit_wood.ogg'
	var/log_type = /obj/item/stack/material/log

/obj/structure/flora/stump/get_material_health_modifier()
	return 2.5 //Make stumps worth removing with shovels instead of bashing them

/obj/structure/flora/stump/can_cut_down(obj/item/I, mob/user)
	return IS_SHOVEL(I)

/obj/structure/flora/stump/cut_down(obj/item/I, mob/user)
	if(I.do_tool_interaction(TOOL_SHOVEL, user, src, 8 SECONDS))
		. = ..()

/obj/structure/flora/stump/create_dismantled_products(turf/T)
	if(log_type)
		LAZYADD(., new log_type(T, rand(2,3), material?.type, reinf_material?.type))
	. = ..()

//Base tree stump
/obj/structure/flora/stump/tree
	name       = "tree stump"
	icon       = 'icons/obj/flora/tree_stumps.dmi'
	w_class    = ITEM_SIZE_HUGE
	pixel_x    = -16 //All trees are offset 16 pixels
	material   = /decl/material/solid/organic/wood/oak

//dead trees
/obj/structure/flora/stump/tree/dead
	name       = "dead tree stump"
	icon_state = "tree_1"

/obj/structure/flora/stump/tree/dead/init_appearance()
	icon_state = "tree_[rand(1, 6)]"

//pine trees
/obj/structure/flora/stump/tree/pine
	icon_state = "pine_1"
	material   = /decl/material/solid/organic/wood/oak // TODO: pine

/obj/structure/flora/stump/tree/pine/init_appearance()
	icon_state = "pine_[rand(1, 3)]"

//christmas tree
/obj/structure/flora/stump/tree/pine/xmas
	icon_state = "pine_c"

/obj/structure/flora/stump/tree/towercap
	icon_state = "towercap_1"
	material   = /decl/material/solid/organic/wood/fungal

/obj/structure/flora/stump/tree/ebony
	icon_state = "ebony_1"
	material   = /decl/material/solid/organic/wood/ebony

/obj/structure/flora/stump/tree/mahogany
	icon_state = "mahogany_1"
	material   = /decl/material/solid/organic/wood/mahogany

/obj/structure/flora/stump/tree/maple
	icon_state = "maple_1"
	material   = /decl/material/solid/organic/wood/maple

/obj/structure/flora/stump/tree/yew
	icon_state = "yew_1"
	material   = /decl/material/solid/organic/wood/yew

/obj/structure/flora/stump/tree/walnut
	icon_state = "walnut_1"
	material   = /decl/material/solid/organic/wood/walnut
