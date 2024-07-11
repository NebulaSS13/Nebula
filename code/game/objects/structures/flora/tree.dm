
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

	/// What kind of log we leave behind.
	var/log_type = /obj/item/stack/material/log
	/// How many logs we leave behind.
	var/log_amount = 10
	/// Whether or not you can shelter under this tree.
	var/protects_against_weather = TRUE
	/// What kind of tree stump we leaving behind.
	var/stump_type
	/// How much to shake the tree when struck.
	/// Larger trees should have smaller numbers or it looks weird.
	var/shake_animation_degrees = 4
	/// Marker for repeating the cut sound effect and animation.
	var/someone_is_cutting = FALSE

/obj/structure/flora/tree/get_material_health_modifier()
	return 2.5 //Prefer removing via tools than bashing

/obj/structure/flora/tree/can_cut_down(obj/item/I, mob/user)
	return IS_HATCHET(I) //Axes can bypass having to damage the tree to break it

/obj/structure/flora/tree/cut_down(obj/item/I, mob/user)
	someone_is_cutting = TRUE
	if(I.do_tool_interaction(TOOL_HATCHET, user, src, 5 SECONDS))
		. = ..()
	someone_is_cutting = FALSE

/obj/structure/flora/tree/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	if(!ml && protects_against_weather)
		for(var/turf/T as anything in RANGE_TURFS(src, 1))
			AMBIENCE_QUEUE_TURF(T)

// I hate doing things that aren't cleanup in Destroy(), but this should still update even when admin-deleted.
/obj/structure/flora/tree/Destroy()
	var/list/turfs_to_update = RANGE_TURFS(src, 1)
	. = ..()
	if(protects_against_weather)
		for(var/turf/T in turfs_to_update)
			AMBIENCE_QUEUE_TURF(T)

/obj/structure/flora/tree/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	. = ..()
	if(!QDELETED(src) && damage >= 5)
		shake()

// We chop several times to cut down a tree.
/obj/structure/flora/tree/play_cut_sound(mob/user)
	shake()
	while(someone_is_cutting)
		sleep(1 SECOND)
		if(QDELETED(src))
			return
		shake()
		playsound(src, 'sound/items/axe_wood.ogg', 40, TRUE)
	if(QDELETED(src) || QDELETED(user) || !user.Adjacent(src))
		return
	return ..()

// Tree shake animation stolen from Polaris.
/obj/structure/flora/tree/proc/shake()
	set waitfor = FALSE
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Translate(0, 16*(icon_scale_y-1))
	animate(src, transform=turn(M, shake_animation_degrees * shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=M, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

/obj/structure/flora/tree/create_dismantled_products(turf/T)
	if(log_type)
		LAZYADD(., new log_type(T, rand(max(1,round(log_amount*0.5)), log_amount), material?.type, reinf_material?.type))
	if(stump_type)
		var/obj/structure/flora/stump/stump = new stump_type(T, material, reinf_material)
		stump.icon_state = icon_state //A bit dirty maybe, but its probably not worth writing a whole system for this when we have 3 kinds of trees...
		if(paint_color)
			stump.set_color()
	. = ..()

/obj/structure/flora/tree/pine
	name         = "pine tree"
	desc         = "A pine tree."
	icon         = 'icons/obj/flora/pinetrees.dmi'
	icon_state   = "pine_1"
	stump_type   = /obj/structure/flora/stump/tree/pine
	opacity      = TRUE

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

/obj/structure/flora/tree/dead/random/init_appearance()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree/dead/ebony
	icon_state = "dead_ebony_1"
	material   = /decl/material/solid/organic/wood/ebony
	stump_type = /obj/structure/flora/stump/tree/ebony

/obj/structure/flora/tree/dead/mahogany
	icon_state = "dead_mahogany_1"
	material   = /decl/material/solid/organic/wood/mahogany
	stump_type = /obj/structure/flora/stump/tree/mahogany

/obj/structure/flora/tree/dead/walnut
	icon_state = "dead_walnut_1"
	material   = /decl/material/solid/organic/wood/walnut
	stump_type = /obj/structure/flora/stump/tree/walnut

/obj/structure/flora/tree/dead/maple
	icon_state = "dead_maple_1"
	material   = /decl/material/solid/organic/wood/maple
	stump_type = /obj/structure/flora/stump/tree/maple

/obj/structure/flora/tree/dead/yew
	icon_state = "dead_yew_1"
	material   = /decl/material/solid/organic/wood/yew
	stump_type = /obj/structure/flora/stump/tree/yew

/obj/structure/flora/tree/softwood
	icon          = 'icons/obj/flora/softwood.dmi'
	abstract_type = /obj/structure/flora/tree/softwood

/obj/structure/flora/tree/softwood/towercap
	name       = "towercap mushroom"
	icon_state = "towercap_1"
	material   = /decl/material/solid/organic/wood/fungal
	stump_type = /obj/structure/flora/stump/tree/towercap

/obj/structure/flora/tree/hardwood
	icon          = 'icons/obj/flora/hardwood.dmi'
	abstract_type = /obj/structure/flora/tree/hardwood

/obj/structure/flora/tree/hardwood/ebony
	name       = "ebony tree"
	icon_state = "ebony_1"
	material   = /decl/material/solid/organic/wood/ebony
	stump_type = /obj/structure/flora/stump/tree/ebony

/obj/structure/flora/tree/hardwood/mahogany
	name       = "mahogany tree"
	icon_state = "mahogany_1"
	material   = /decl/material/solid/organic/wood/mahogany
	stump_type = /obj/structure/flora/stump/tree/mahogany
	opacity    = TRUE

/obj/structure/flora/tree/hardwood/maple
	name       = "maple tree"
	icon_state = "maple_1"
	material   = /decl/material/solid/organic/wood/maple
	stump_type = /obj/structure/flora/stump/tree/maple

/obj/structure/flora/tree/hardwood/yew
	name       = "yew tree"
	icon_state = "yew_1"
	material   = /decl/material/solid/organic/wood/yew
	stump_type = /obj/structure/flora/stump/tree/yew
	opacity    = TRUE

/obj/structure/flora/tree/hardwood/walnut
	name       = "walnut tree"
	icon_state = "walnut_1"
	material   = /decl/material/solid/organic/wood/walnut
	stump_type = /obj/structure/flora/stump/tree/walnut
