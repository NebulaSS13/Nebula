
////////////////////////////////////////
// Trees
////////////////////////////////////////
/obj/structure/flora/tree
	name         = "tree"
	density      = TRUE
	pixel_x      = -16
	layer        = ABOVE_HUMAN_LAYER
	material     = /decl/material/solid/organic/wood
	w_class      = ITEM_SIZE_STRUCTURE
	hitsound     = 'sound/effects/hit_wood.ogg'
	snd_cut      = 'sound/effects/plants/tree_fall.ogg'
	var/protects_against_weather = TRUE
	var/stump_type //What kind of tree stump we're leaving behind

/obj/structure/flora/tree/get_material_health_modifier()
	return 2.5 //Prefer removing via tools than bashing

/obj/structure/flora/tree/can_cut_down(obj/item/I, mob/user)
	return IS_HATCHET(I) //Axes can bypass having to damage the tree to break it

/obj/structure/flora/tree/cut_down(obj/item/I, mob/user)
	if(I.do_tool_interaction(TOOL_HATCHET, user, src, 5 SECONDS))
		. = ..()

/obj/structure/flora/tree/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		var/obj/structure/flora/stump/stump = new stump_type(T, material, reinf_material)
		if(istype(stump))
			stump.icon_state = icon_state //A bit dirty maybe, but its probably not worth writing a whole system for this when we have 3 kinds of trees..
	. = ..()

/obj/structure/flora/tree/pine
	name         = "pine tree"
	desc         = "A pine tree."
	icon         = 'icons/obj/flora/pinetrees.dmi'
	icon_state   = "pine_1"
	stump_type   = /obj/structure/flora/stump/tree/pine

/obj/structure/flora/tree/pine/init_appearance()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name         = "\improper Christmas tree"
	desc         = "O Christmas tree, O Christmas tree..."
	icon         = 'icons/obj/flora/pinetrees.dmi'
	icon_state   = "pine_c"
	stump_type   = /obj/structure/flora/stump/tree/pine/xmas

/obj/structure/flora/tree/pine/xmas/init_appearance()
	return //Only one possible icon

/obj/structure/flora/tree/dead
	name                     = "dead tree"
	desc                     = "A dead looking tree."
	icon                     = 'icons/obj/flora/deadtrees.dmi'
	icon_state               = "tree_1"
	protects_against_weather = FALSE
	stump_type               = /obj/structure/flora/stump/tree/dead

/obj/structure/flora/tree/dead/init_appearance()
	icon_state = "tree_[rand(1, 6)]"
