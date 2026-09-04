#define MAX_BARRICADE_TAPE_LENGTH 32 //Maximum length of a continuous line of tape someone can place down.
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
	material         = /decl/material/solid/organic/plastic
	max_health       = 5
	var/neighbors    = 0                              //Contains all the direction flags of all the neighboring tape_barricades
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
		if(!QDELETED(B))
			B.update_icon()

	if(!QDELETED(src))
		update_icon()

/**Updates our connection bits to keep track of the things we're connected to */
/obj/structure/tape_barricade/proc/build_connection_bits()
	neighbors = 0
	for (var/look_dir in global.cardinal)
		var/turf/target_turf = get_step(src, look_dir)
		if(target_turf)
			var/obj/structure/tape_barricade/B = locate(/obj/structure/tape_barricade) in target_turf
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

	if(user.check_intent(I_FLAG_HARM))
		user.visible_message(SPAN_DANGER("\The [user] tears \the [src]!"))
		physically_destroyed()
		return TRUE

	if (!user.check_intent(I_FLAG_HELP) || !allowed(user) || !user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
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

/obj/structure/tape_barricade/dismantle_structure(mob/user)
	for (var/obj/structure/tape_barricade/B in get_tape_line())
		if(B == src || QDELETED(B))
			continue
		if(B.neighbors & get_dir(B, src))
			B.physically_destroyed()
	. = ..()

/obj/structure/tape_barricade/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!is_lifted && ismob(mover))
		var/mob/M = mover
		if (!allowed(M) && M.check_intent(I_FLAG_HELP))
			return FALSE
	return ..()

/obj/structure/tape_barricade/Crossed(atom/movable/AM)
	. = ..()
	if(is_lifted || !isliving(AM))
		return
	var/mob/living/M = AM
	add_fingerprint(M)
	shake_animation(2)
	if (!allowed(M))	//only select few learn art of not crumpling the tape
		to_chat(M, SPAN_NOTICE("You are not supposed to go past \the [src]..."))
		if(!M.check_intent(I_FLAG_HELP))
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
		addtimer(CALLBACK(src, PROC_REF(on_unlift)), time, TIMER_UNIQUE)
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