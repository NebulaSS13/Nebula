#define MAX_BARRICADE_TAPE_LENGTH 32                //Maximum length of a continuous line of tape someone can place down.
#define TAPE_BARRICADE_V_NEIGHBORS (NORTH | SOUTH)
#define TAPE_BARRICADE_H_NEIGHBORS (EAST  | WEST)
#define TAPE_BARRICADE_IS_CORNER_NEIGHBORS(X) ((X ^ TAPE_BARRICADE_V_NEIGHBORS) && (X ^ TAPE_BARRICADE_H_NEIGHBORS))
#define TAPE_BARRICADE_IS_V_NEIGHBORS(X) ((X & TAPE_BARRICADE_V_NEIGHBORS) == TAPE_BARRICADE_V_NEIGHBORS && !((X & TAPE_BARRICADE_H_NEIGHBORS) == TAPE_BARRICADE_H_NEIGHBORS)) //Check we have neighbors connection on the vertical plane
#define TAPE_BARRICADE_IS_H_NEIGHBORS(X) ((X & TAPE_BARRICADE_H_NEIGHBORS) == TAPE_BARRICADE_H_NEIGHBORS && !((X & TAPE_BARRICADE_V_NEIGHBORS) == TAPE_BARRICADE_V_NEIGHBORS)) //Check we have neighbors connection on the horizontal plane
#define TAPE_BARRICADE_IS_3W_V_NEIGHBORS(X) (TAPE_BARRICADE_IS_V_NEIGHBORS(X) && ((X & TAPE_BARRICADE_H_NEIGHBORS) > 0))
#define TAPE_BARRICADE_IS_3W_H_NEIGHBORS(X) (TAPE_BARRICADE_IS_H_NEIGHBORS(X) && ((X & TAPE_BARRICADE_V_NEIGHBORS) > 0))
#define TAPE_BARRICADE_IS_4W_NEIGHBORS(X) (((X & TAPE_BARRICADE_V_NEIGHBORS) == TAPE_BARRICADE_V_NEIGHBORS) && ((X & TAPE_BARRICADE_H_NEIGHBORS) == TAPE_BARRICADE_H_NEIGHBORS))
#define CONNECTION_BITS_TO_TEXT(X) "[(X & WEST) > 0][(X & EAST) > 0][(X & SOUTH) > 0][(X & NORTH) > 0]"
#define TAPE_BARRICADE_GET_NB_NEIGHBORS(X) (((X & NORTH) > 0) + ((X & SOUTH) > 0) + ((X & EAST) > 0) + ((X & WEST) > 0))

var/global/list/image/hazard_overlays //Cached hazard floor overlays for the barricade tape

////////////////////////////////////////////////////////////////////
// Barricade Tape Template
////////////////////////////////////////////////////////////////////
//Singletons with data on the various templates of barricade tape
/decl/barricade_tape_template
	var/tape_kind         = "barricade"                   //Used as a prefix to the word "tape" when refering to the tape and roll
	var/tape_desc         = "A tape barricade."           //Description for the tape barricade
	var/roll_desc         = "A roll of barricade tape."   //Description for the tape roll
	var/icon_file         = 'icons/policetape.dmi'        //Icon file used for both the tape and roll
	var/base_icon_state   = "tape"                        //For the barricade. Icon state used to fetch the applied tape directional icons for various states
	var/list/req_access                                   //Access required to automatically pass through tape barricades
	var/tape_color                                        //Color of the tape
	var/detail_overlay                                    //Overlay for the applied tape
	var/detail_color                                      //Color for the detail overlay

/decl/barricade_tape_template/proc/make_line_barricade(var/mob/user, var/turf/T, var/pdir)
	var/obj/structure/tape_barricade/bar = new(T,,,src)
	bar.add_fingerprint(user)
	return bar

/decl/barricade_tape_template/proc/make_door_barricade(var/mob/user, var/obj/door)
	var/obj/structure/tape_barricade/door/bar = new(get_turf(door))
	bar.set_tape_template(src)
	bar.set_dir(door.dir)
	bar.add_fingerprint(user)
	return bar

////////////////////////////////////////////////////////////////////
// Barricade Tape Roll
////////////////////////////////////////////////////////////////////
/obj/item/stack/tape_roll/barricade_tape
	name               = "barricade tape roll"
	desc               = "A roll of high visibility, non-sticky barricade tape. Used to deter passersby from crossing it."
	icon               = 'icons/policetape.dmi'
	icon_state         = "tape"
	w_class            = ITEM_SIZE_SMALL
	var/tmp/unrolled   = 0                         //The amount of tape lenghts we've used so far while laying down a barricade
	var/tmp/turf/start                             //The turf we started unrolling from
	var/tmp/weakref/unroller                       //The mob currently unrolling us
	var/decl/barricade_tape_template/tape_template //Template containing details on how the tape roll will look and behave, along with what it will place down

/obj/item/stack/tape_roll/barricade_tape/Initialize()
	. = ..()
	apply_template()

/obj/item/stack/tape_roll/barricade_tape/Destroy()
	stop_unrolling()
	return ..()

/**Update our appearence and data to match the specified tape template. */
/obj/item/stack/tape_roll/barricade_tape/proc/apply_template()
	if(ispath(tape_template))
		tape_template = GET_DECL(tape_template)
	if(!tape_template)
		return

	SetName("[tape_template.tape_kind] tape roll")
	desc = tape_template.roll_desc
	icon = tape_template.icon_file
	set_color(tape_template.tape_color)
	update_icon()

/obj/item/stack/tape_roll/barricade_tape/on_update_icon()
	. = ..()
	if(ismob(loc))
		add_overlay(overlay_image(icon, start? "stop" : "start", flags = RESET_COLOR))

/obj/item/stack/tape_roll/barricade_tape/dropped(mob/user)
	stop_unrolling()
	update_icon()
	return ..()

/obj/item/stack/tape_roll/barricade_tape/on_picked_up(mob/user)
	stop_unrolling()
	update_icon()
	return ..()

/obj/item/stack/tape_roll/barricade_tape/attack_hand()
	update_icon()
	return ..()

/**Callback used when whoever holds us moved to a new turf. */
/obj/item/stack/tape_roll/barricade_tape/proc/user_moved_unrolling(var/mob/M, var/atom/old_loc, var/atom/new_loc)
	if(QDELETED(src))
		return //Destructor will handle the rest
	if(QDELETED(M) || !can_use(1) || M.incapacitated())
		stop_unrolling()
		return

	if((old_loc.x != new_loc.x && old_loc.y != new_loc.y) || old_loc.z != new_loc.z)
		to_chat(M, SPAN_WARNING("\The [src] can only be laid horizontally or vertically."))
		stop_unrolling()
		return
	//Use a length of tape and place a barricade line
	if(!place_line(M, new_loc, get_dir(old_loc, new_loc)))
		stop_unrolling()
		return
	if(get_dist(start, new_loc) >= MAX_BARRICADE_TAPE_LENGTH)
		to_chat(M, SPAN_WARNING("You've stretched this line of tape to the maximum!"))
		stop_unrolling()
		return

/obj/item/stack/tape_roll/barricade_tape/proc/stop_unrolling()
	if(!start && !unroller)
		return
	var/mob/_uroller = unroller.resolve()
	if(_uroller)
		events_repository.unregister(/decl/observ/moved, _uroller, src, .proc/user_moved_unrolling)
	unroller         = null
	start            = null
	slowdown_general = initial(slowdown_general)
	if(_uroller)
		to_chat(_uroller, SPAN_NOTICE("You stop unrolling \the [src]."))
	if(!QDELETED(src))
		update_icon()
	return TRUE

/obj/item/stack/tape_roll/barricade_tape/proc/start_unrolling(var/mob/user)
	if(start && unroller)
		return
	start    = get_turf(src)
	unroller = weakref(user)
	slowdown_general = initial(slowdown_general) + 2 //While unrolling you're slightly slower
	events_repository.unregister(/decl/observ/moved, user, src, .proc/user_moved_unrolling)
	events_repository.register(/decl/observ/moved, user, src, .proc/user_moved_unrolling)
	to_chat(user, SPAN_NOTICE("You start unrolling \the [src]."))
	//Place the first one immediately
	place_line(user, get_turf(user), user.dir)
	update_icon()
	return TRUE

/**Place a tape line on the current turf. */
/obj/item/stack/tape_roll/barricade_tape/proc/place_line(var/mob/user, var/turf/T, var/pdir)
	if(T.is_open() || T.is_wall())
		to_chat(user, SPAN_WARNING("You can't place tape here!"))
		return
	if(locate(/obj/structure/tape_barricade) in T)
		return //Can't place 2 on the same tile!

	if(!can_use(1))
		to_chat(user, SPAN_WARNING("You are out of [tape_template.tape_kind] tape!"))
		return
	use(1)
	playsound(user, 'sound/effects/pageturn2.ogg', 50, TRUE)

	var/obj/structure/tape_barricade/barricade = tape_template.make_line_barricade(user, T, pdir)
	if(barricade)
		barricade.update_neighbors()
	return barricade

/obj/item/stack/tape_roll/barricade_tape/attack_self(mob/user)
	if(start)
		stop_unrolling()
		return
	if(!can_use(1))
		return //This shouldn't happen, but if it does, don't let them exploit it

	start_unrolling(user)

/obj/item/stack/tape_roll/barricade_tape/afterattack(var/atom/A, mob/user, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/door/airlock))
		if(!can_use(4))
			to_chat(user, SPAN_WARNING("There isn't enough [plural_name] in \the [src] to barricade \the [A]. You need at least 4 [plural_name]."))
			return
		tape_template.make_door_barricade(user, A)
		to_chat(user, SPAN_NOTICE("You finish placing \the [src]."))

////////////////////////////////////////////////////////////////////
// Tape Line Barricade
////////////////////////////////////////////////////////////////////
/obj/structure/tape_barricade
	name             = "tape line"
	desc             = "A line of barricade tape."
	icon             = 'icons/policetape.dmi'
	icon_state       = "tape_2w_0"
	dir              = SOUTH                          //This structure will try to turn its icon depending on what neighbors it has
	layer            = ABOVE_DOOR_LAYER
	pass_flags       = PASS_FLAG_TABLE                //About the height of table
	anchored         = TRUE
	material         = /decl/material/solid/plastic
	var/neighbors    = 0                              //Contains all the direction flags of all the neighboring tape_barricades
	var/nb_neighbors = 0                              //Keep track of our cached neighbors number
	var/is_lifted    = 0                              //Whether the tape is lifted and we're allowing everyone passage.
	var/is_crumpled  = 0                              //Whether the tape was damaged
	var/decl/barricade_tape_template/tape_template   //Details about the behavior and looks of the barricade

/obj/structure/tape_barricade/Initialize(ml, _mat, _reinf_mat, var/decl/barricade_tape_template/_tape_template)
	. = ..()
	if(!hazard_overlays)
		hazard_overlays = list()
		hazard_overlays["[NORTH]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "N")
		hazard_overlays["[EAST]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "E")
		hazard_overlays["[SOUTH]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "S")
		hazard_overlays["[WEST]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "W")
	set_tape_template(_tape_template)

/obj/structure/tape_barricade/LateInitialize()
	. = ..()
	build_connection_bits()
	update_neighbors()

/obj/structure/tape_barricade/Destroy()
	var/turf/old_loc = get_turf(src)
	. = ..()
	if(istype(old_loc))
		update_neighbors(old_loc)

/obj/structure/tape_barricade/proc/set_tape_template(var/decl/barricade_tape_template/tmpl)
	if(tmpl)
		tape_template = tmpl
	if(ispath(tape_template))
		tape_template = GET_DECL(tape_template)
	if(!tape_template)
		return

	SetName("[tape_template.tape_kind] tape line")
	desc       = tape_template.tape_desc
	icon       = tape_template.icon_file
	req_access = tape_template.req_access
	set_color(tape_template.tape_color)
	update_icon()

/**Cause neighbors to update their icon. */
/obj/structure/tape_barricade/proc/update_neighbors(var/location = loc)
	for (var/look_dir in global.cardinal)
		var/obj/structure/tape_barricade/B = locate(/obj/structure/tape_barricade, get_step(location, look_dir))
		if(B && !QDELETED(B))
			B.update_icon()

	if(!QDELETED(src))
		update_icon()

/**Updates our connection bits to keep track of the things we're connected to */
/obj/structure/tape_barricade/proc/build_connection_bits()
	neighbors = 0
	for (var/look_dir in global.cardinal)
		var/turf/target_turf = get_step(src, look_dir)
		var/obj/structure/tape_barricade/B = locate(/obj/structure/tape_barricade, target_turf)
		//We connect to walls and other tape_barricades
		if((B && !QDELETED(B)) || (!B && target_turf.is_wall()))
			neighbors |= look_dir

/**Allow sutypes to override with their own forced icon state name.*/
/obj/structure/tape_barricade/proc/icon_name_override()
	return

/obj/structure/tape_barricade/on_update_icon()
	. = ..()
	if(isnull(tape_template) || ispath(tape_template))
		return
	//Look up our neighbors
	build_connection_bits()

	var/icon_name = icon_name_override()
	if(!icon_name)
		//Build the icon state from whethere we've got a right angle with out neighbors or not
		if(TAPE_BARRICADE_IS_4W_NEIGHBORS(neighbors))
			set_dir(SOUTH)
			icon_name = "4w"

		//3 Ways
		else if(TAPE_BARRICADE_IS_3W_H_NEIGHBORS(neighbors))
			set_dir(neighbors & TAPE_BARRICADE_V_NEIGHBORS)
			icon_name = "3w"
		else if(TAPE_BARRICADE_IS_3W_V_NEIGHBORS(neighbors))
			set_dir(neighbors & TAPE_BARRICADE_H_NEIGHBORS)
			icon_name = "3w"

		//Lines
		else if(TAPE_BARRICADE_IS_H_NEIGHBORS(neighbors))
			set_dir(EAST)
			icon_name = "2w"
		else if(TAPE_BARRICADE_IS_V_NEIGHBORS(neighbors))
			set_dir(SOUTH)
			icon_name = "2w"

		//Endpoints/corners
		else
			if(neighbors > 0)
				set_dir(neighbors) //Make sure if we have no connections we don't set a bad dir
			icon_name = "dir"

	icon_state = "[tape_template.base_icon_state]_[icon_name]_[is_crumpled]"

	//Overlays
	if(tape_template.detail_overlay)
		var/image/ovr = overlay_image(icon, "[tape_template.base_icon_state]_[icon_name]_[tape_template.detail_overlay]", tape_template.detail_color, RESET_COLOR)
		ovr.dir = dir
		add_overlay(ovr)

/obj/structure/tape_barricade/attack_hand(mob/user)
	if (user.a_intent != I_HELP || !allowed(user) || !user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()

	if(TAPE_BARRICADE_IS_CORNER_NEIGHBORS(neighbors) || (TAPE_BARRICADE_GET_NB_NEIGHBORS(neighbors) > 2))
		to_chat(user, SPAN_WARNING("You can't lift up the pole. Try lifting the line itself."))
		return TRUE

	if(!allowed(user))
		user.visible_message(SPAN_NOTICE("\The [user] carelessly pulls \the [src] out of the way."))
		crumple()
	else
		user.visible_message(SPAN_NOTICE("\The [user] lifts \the [src], officially allowing passage."))

	for(var/obj/structure/tape_barricade/B in get_tape_line())
		B.lift(10 SECONDS) //~10 seconds
	return TRUE

/obj/structure/tape_barricade/dismantle()
	for (var/obj/structure/tape_barricade/B in get_tape_line())
		if(B == src || QDELETED(B))
			continue
		if(B.neighbors & get_dir(B, src))
			B.physically_destroyed()
	. = ..()

/obj/structure/tape_barricade/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!is_lifted && ismob(mover))
		var/mob/M = mover
		if (!allowed(M) && M.a_intent == I_HELP)
			return FALSE
	return ..()

/obj/structure/tape_barricade/Crossed(O)
	. = ..()
	if(!is_lifted && ismob(O))
		var/mob/M = O
		add_fingerprint(M)
		shake_animation(2)
		if (!allowed(M))	//only select few learn art of not crumpling the tape
			to_chat(M, SPAN_NOTICE("You are not supposed to go past \the [src]..."))
			if(M.a_intent != I_HELP)
				crumple()

/obj/structure/tape_barricade/proc/crumple()
	if(!is_crumpled)
		playsound(src, 'sound/effects/rip1.ogg', 60, TRUE)
		take_damage(5)
		is_crumpled = TRUE
		update_icon()

/**Temporarily lifts the tape line, allowing passage to anyone for the specified time, until the timer expires. */
/obj/structure/tape_barricade/proc/lift(var/time)
	if(!is_lifted)
		is_lifted = TRUE
		layer = ABOVE_HUMAN_LAYER
		pass_flags = PASS_FLAG_MOB
		pixel_y += 8
		addtimer(CALLBACK(src, .proc/on_unlift), time, TIMER_UNIQUE)
		playsound(src, 'sound/effects/pageturn2.ogg', 50, TRUE)

/**Called by timer when the tape line falls back in place. */
/obj/structure/tape_barricade/proc/on_unlift()
	is_lifted = FALSE
	pass_flags = initial(pass_flags)
	reset_plane_and_layer()
	pixel_y -= 8
	playsound(src, 'sound/effects/pageturn2.ogg', 20, TRUE)

// Returns a list of all tape objects connected to src, including itself.
/obj/structure/tape_barricade/proc/get_tape_line(var/list/ignored, var/line_index = 0)
	//Don't include more in the line than this
	if(line_index >= MAX_BARRICADE_TAPE_LENGTH)
		return list()

	var/list/dirs = list()
	if(neighbors & NORTH)
		dirs += NORTH
	if(neighbors & SOUTH)
		dirs += SOUTH
	if(neighbors & WEST)
		dirs += WEST
	if(neighbors & EAST)
		dirs += EAST

	//Grab all cached connected neighbors
	LAZYDISTINCTADD(ignored, src)
	var/list/obj/structure/tape_barricade/tapeline = list(src)
	for(var/look_dir in dirs)
		var/turf/T = get_step(src, look_dir)
		var/obj/structure/tape_barricade/B = locate() in T
		if(!QDELETED(B) && !(B in ignored))
			if(TAPE_BARRICADE_IS_CORNER_NEIGHBORS(neighbors) || (TAPE_BARRICADE_GET_NB_NEIGHBORS(neighbors) > 2))
				continue //We stop at intersections, and corners
			tapeline += B.get_tape_line(ignored, line_index + 1) //Pass us to prevent infinite loops, and adding us to the resulting line
	return tapeline

////////////////////////////////////////////////////////////////////
// Door Tape Barricade
////////////////////////////////////////////////////////////////////

//Barricade over a single door
/obj/structure/tape_barricade/door
	icon_state = "tape_door_0"
	layer      = ABOVE_DOOR_LAYER

/obj/structure/tape_barricade/door/update_neighbors()
	//We completely ignore neighbors
	neighbors = 0

/obj/structure/tape_barricade/door/icon_name_override()
	return "door" //Override the icon picking to pick this icon label instead

////////////////////////////////////////////////////////////////////
// Police Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/police
	tape_kind  = "police"
	tape_desc  = "A length of police tape.  Do not cross."
	roll_desc  = "A roll of police tape used to block off crime scenes from the public."
	tape_color = COLOR_RED
	req_access = list(access_security)

/obj/item/stack/tape_roll/barricade_tape/police
	tape_template = /decl/barricade_tape_template/police

//mapper type
/obj/structure/tape_barricade/police
	icon_state    = "tape_h_0"
	color         = COLOR_RED
	tape_template = /decl/barricade_tape_template/police

////////////////////////////////////////////////////////////////////
// Engineering Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/engineering
	tape_kind  = "engineering"
	tape_desc  = "A length of engineering tape. Better not cross it."
	roll_desc  = "A roll of engineering tape used to block off working areas from the public."
	tape_color = COLOR_ORANGE
	req_access = list(list(access_engine,access_atmospherics))

/obj/item/stack/tape_roll/barricade_tape/engineering
	tape_template = /decl/barricade_tape_template/engineering

//mapper type
/obj/structure/tape_barricade/engineering
	icon_state    = "tape_h_0"
	color         = COLOR_ORANGE
	tape_template = /decl/barricade_tape_template/engineering

////////////////////////////////////////////////////////////////////
// Atmospheric Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/atmos
	tape_kind       = "atmospherics"
	tape_desc       = "A length of atmospherics tape. Better not cross it."
	roll_desc       = "A roll of atmospherics tape used to block off working areas from the public."
	tape_color      = COLOR_BLUE_LIGHT
	req_access      = list(list(access_engine,access_atmospherics))
	base_icon_state = "stripetape"
	detail_overlay  = "stripes"
	detail_color    = COLOR_YELLOW

/obj/item/stack/tape_roll/barricade_tape/atmos
	tape_template = /decl/barricade_tape_template/atmos

//mapper type
/obj/structure/tape_barricade/atmos
	icon_state    = "stripetape_h_0"
	color         = COLOR_BLUE_LIGHT
	tape_template = /decl/barricade_tape_template/atmos

////////////////////////////////////////////////////////////////////
// Research Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/research
	tape_kind  = "research"
	tape_desc  = "A length of research tape. Better not cross it."
	roll_desc  = "A roll of research tape used to block off working areas from the public."
	tape_color = COLOR_WHITE
	req_access = list(access_research)

/obj/item/stack/tape_roll/barricade_tape/research
	tape_template = /decl/barricade_tape_template/research

//mapper type
/obj/structure/tape_barricade/research
	color         = COLOR_WHITE
	tape_template = /decl/barricade_tape_template/research

////////////////////////////////////////////////////////////////////
// Medical Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/medical
	tape_kind       = "medical"
	tape_desc       = "A length of medical tape. Better not cross it."
	roll_desc       = "A roll of medical tape used to block off working areas from the public."
	tape_color      = COLOR_PALE_BLUE_GRAY
	req_access      = list(access_medical)
	base_icon_state = "stripetape"
	detail_overlay  = "stripes"
	detail_color    = COLOR_PALE_BLUE_GRAY

/obj/item/stack/tape_roll/barricade_tape/medical
	tape_template = /decl/barricade_tape_template/medical

//mapper type
/obj/structure/tape_barricade/medical
	icon_state    = "stripetape_h_0"
	color         = COLOR_PALE_BLUE_GRAY
	tape_template = /decl/barricade_tape_template/medical

////////////////////////////////////////////////////////////////////
// Bureacratic Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/bureaucracy
	tape_kind       = "red"
	tape_desc       = "A length of bureaucratic red tape. Safely ignored, but darn obstructive sometimes."
	roll_desc       = "A roll of bureaucratic red tape used to block any meaningful work from being done."
	tape_color      = COLOR_RED
	base_icon_state = "stripetape"
	detail_overlay  = "stripes"
	detail_color    = COLOR_RED

/obj/item/stack/tape_roll/barricade_tape/bureaucracy
	tape_template = /decl/barricade_tape_template/bureaucracy

//mapper type
/obj/structure/tape_barricade/bureaucracy
	icon_state    = "stripetape_h_0"
	color         = COLOR_RED
	tape_template = /decl/barricade_tape_template/bureaucracy

#undef MAX_BARRICADE_TAPE_LENGTH
#undef TAPE_BARRICADE_IS_CORNER_NEIGHBORS
#undef TAPE_BARRICADE_V_NEIGHBORS
#undef TAPE_BARRICADE_H_NEIGHBORS
#undef TAPE_BARRICADE_IS_V_NEIGHBORS
#undef TAPE_BARRICADE_IS_H_NEIGHBORS
#undef TAPE_BARRICADE_IS_3W_V_NEIGHBORS
#undef TAPE_BARRICADE_IS_3W_H_NEIGHBORS
#undef TAPE_BARRICADE_IS_4W_NEIGHBORS
#undef CONNECTION_BITS_TO_TEXT
#undef TAPE_BARRICADE_GET_NB_NEIGHBORS