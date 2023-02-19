// Shared attackby behaviors that /turf/exterior/open also uses.
/proc/shared_open_turf_attackhand(var/turf/target, var/mob/user)
	for(var/atom/movable/M in target.below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attack_hand(user)

/proc/shared_open_turf_attackby(var/turf/target, obj/item/thing, mob/user)

	if(istype(thing, /obj/item/stack/material/rods))
		var/ladder = (locate(/obj/structure/ladder) in target)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE
		var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, target)
		if(lattice)
			return lattice.attackby(thing, user)
		var/obj/item/stack/material/rods/rods = thing
		if (rods.use(1))
			to_chat(user, SPAN_NOTICE("You lay down the support lattice."))
			playsound(target, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(target.x, target.y, target.z), rods.material.type)
		return TRUE

	if (istype(thing, /obj/item/stack/tile))
		var/obj/item/stack/tile/tile = thing
		tile.try_build_turf(user, target)
		return TRUE

	//To lay cable.
	if(IS_COIL(thing) && target.try_build_cable(thing, user))
		return TRUE

	for(var/atom/movable/M in target.below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attackby(thing, user)

	return FALSE

/// `direction` is the direction the atom is trying to leave by.
/turf/proc/CanZPass(atom/A, direction, check_neighbor_canzpass = TRUE)

	if(direction == UP)
		if(!HasAbove(z))
			return FALSE
		if(check_neighbor_canzpass)
			var/turf/T = GetAbove(src)
			if(!T.CanZPass(A, DOWN, FALSE))
				return FALSE

	else if(direction == DOWN)
		if(!is_open() || !HasBelow(z) || (locate(/obj/structure/catwalk) in src))
			return FALSE
		if(check_neighbor_canzpass)
			var/turf/T = GetBelow(src)
			if(!T.CanZPass(A, UP, FALSE))
				return FALSE

	// Hate calling Enter() directly, but that's where obstacles are checked currently.
	return Enter(A, A)

////////////////////////////////
// Open SIMULATED
////////////////////////////////
/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts
	z_flags = ZM_MIMIC_DEFAULTS | ZM_MIMIC_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS
	turf_flags = TURF_FLAG_BACKGROUND

/turf/simulated/open/flooded
	name = "open water"
	flooded = TRUE

/turf/simulated/open/update_dirt()
	return 0

/turf/simulated/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall(oldloc)

// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(var/atom/movable/AM)
	..()
	if(!QDELETED(AM))
		AM.fall()

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/turf/T = GetBelow(src); (istype(T) && T.is_open()); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/simulated/open/is_open()
	return TRUE

/turf/simulated/open/attackby(obj/item/C, mob/user)
	return shared_open_turf_attackby(src, C, user)

/turf/simulated/open/attack_hand(mob/user)
	return shared_open_turf_attackhand(src, user)

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return TRUE

/turf/simulated/open/cannot_build_cable()
	return 0

////////////////////////////////
// Open EXTERIOR
////////////////////////////////
/turf/exterior/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = 0
	pathweight = 100000
	z_flags = ZM_MIMIC_DEFAULTS | ZM_MIMIC_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS

/turf/exterior/open/flooded
	name = "open water"
	flooded = TRUE

/turf/exterior/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall(oldloc)

/turf/exterior/open/hitby(var/atom/movable/AM)
	..()
	if(!QDELETED(AM))
		AM.fall()

/turf/exterior/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/turf/T = GetBelow(src); (istype(T) && T.is_open()); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/exterior/open/is_open()
	return TRUE

/turf/exterior/open/attackby(obj/item/C, mob/user)
	return shared_open_turf_attackby(src, C, user)

/turf/exterior/open/attack_hand(mob/user)
	return shared_open_turf_attackhand(src, user)

/turf/exterior/open/cannot_build_cable()
	return 0

////////////////////////////////
// Mimic Edges
////////////////////////////////

///Dummy mouse-opaque overlay to prevent people turning/shooting towards ACTUAL location of vis_content thing
/obj/effect/overlay/click_bait
	name = "distant terrain"
	desc = "You need to come over there to take a better look."
	mouse_opacity = 2

////////////////////////////////
// Simulated Mimic Edges
////////////////////////////////

///Simulated turf meant to replicate the appearence of another.
/turf/simulated/mimic_edge
	name       = "world's edge"
	desc       = "Flatearther's nightmare."
	icon       = null
	icon_state = null
	density    = TRUE
	permit_ao  = FALSE
	blocks_air = TRUE
	dynamic_lighting = FALSE

	///Mimicked turf's x position
	var/mimic_x
	///Mimicked turf's y position
	var/mimic_y
	///Mimicked turf's z position
	var/mimic_z

/turf/simulated/mimic_edge/Initialize(ml)
	. = ..()
	//Need to put a mouse-opaque overlay there to prevent people turning/shooting towards ACTUAL location of vis_content things
	new /obj/effect/overlay/click_bait(src)
	setup_mimic()

//Properly install itself, and allow overriding how the target turf is picked
/turf/simulated/mimic_edge/proc/setup_mimic()
	return

/turf/simulated/mimic_edge/on_update_icon()
	return

/turf/simulated/mimic_edge/get_vis_contents_to_add()
	. = ..()
	var/turf/NT = mimic_x && mimic_y && mimic_z && locate(mimic_x, mimic_y, mimic_z)
	if(NT)
		opacity = NT.opacity
		log_debug("[src]([x],[y],[z]) mirroring [NT]([NT.x],[NT.y],[NT.z])")
		LAZYADD(., NT)

/turf/simulated/mimic_edge/proc/set_mimic_turf(var/_x, var/_y, var/_z)
	mimic_z = _z? _z : z
	mimic_x = _x
	mimic_y = _y
	refresh_vis_contents()

////////////////////////////////
// Unsimulated Mimic Edges
////////////////////////////////

/turf/unsimulated/mimic_edge
	name       = "world's edge"
	desc       = "Flatearther's nightmare."
	icon       = null
	icon_state = null
	density    = TRUE
	permit_ao  = FALSE
	blocks_air = TRUE
	dynamic_lighting = FALSE

	///Mimicked turf's x position
	var/mimic_x
	///Mimicked turf's y position
	var/mimic_y
	///Mimicked turf's z position
	var/mimic_z

/turf/unsimulated/mimic_edge/Initialize(ml)
	. = ..()
	//Need to put a mouse-opaque overlay there to prevent people turning/shooting towards ACTUAL location of vis_content things
	new /obj/effect/overlay/click_bait(src)
	setup_mimic()

//Properly install itself, and allow overriding how the target turf is picked
/turf/unsimulated/mimic_edge/proc/setup_mimic()
	return

/turf/unsimulated/mimic_edge/on_update_icon()
	return

/turf/unsimulated/mimic_edge/get_vis_contents_to_add()
	. = ..()
	var/turf/NT = mimic_x && mimic_y && mimic_z && locate(mimic_x, mimic_y, mimic_z)
	if(NT)
		opacity = NT.opacity
		log_debug("[src]([x],[y],[z]) mirroring [NT]([NT.x],[NT.y],[NT.z])")
		LAZYADD(., NT)

/turf/unsimulated/mimic_edge/proc/set_mimic_turf(var/_x, var/_y, var/_z)
	mimic_z = _z? _z : z
	mimic_x = _x
	mimic_y = _y
	refresh_vis_contents()

////////////////////////////////
// Exterior Mimic Edges
////////////////////////////////

///Exterior turf meant to replicate the appearence of another.
/turf/exterior/mimic_edge
	name       = "world's edge"
	desc       = "Flatearther's nightmare."
	icon       = null
	icon_state = null
	density    = TRUE
	permit_ao  = FALSE
	blocks_air = TRUE
	dynamic_lighting = FALSE

	///Mimicked turf's x position
	var/mimic_x
	///Mimicked turf's y position
	var/mimic_y
	///Mimicked turf's z position
	var/mimic_z

/turf/exterior/mimic_edge/Initialize(ml)
	. = ..()
	//Need to put a mouse-opaque overlay there to prevent people turning/shooting towards ACTUAL location of vis_content things
	new /obj/effect/overlay/click_bait(src)
	setup_mimic()

//Properly install itself, and allow overriding how the target turf is picked
/turf/exterior/mimic_edge/proc/setup_mimic()
	return

/turf/exterior/mimic_edge/on_update_icon()
	return

/turf/exterior/mimic_edge/get_vis_contents_to_add()
	. = ..()
	var/turf/NT = mimic_x && mimic_y && mimic_z && locate(mimic_x, mimic_y, mimic_z)
	if(NT)
		opacity = NT.opacity
		log_debug("[src]([x],[y],[z]) mirroring [NT]([NT.x],[NT.y],[NT.z])")
		LAZYADD(., NT)

/turf/exterior/mimic_edge/proc/set_mimic_turf(var/_x, var/_y, var/_z)
	mimic_z = _z? _z : z
	mimic_x = _x
	mimic_y = _y
	refresh_vis_contents()

////////////////////////////////
// Transition Edges
////////////////////////////////

///Returns the direction a turf on the map is in relation to the center of the world
/proc/get_turf_to_world_center_direction(var/turf/T)
	//Figure out turf orientation from the map center. (Don't use the helper procs, they don't behave like we want on the corner turfs)
	. = 0 //Make it a number so we don't end up returning a list
	var/halfmaxx = round(world.maxx/2) //get world center x
	var/halfmaxy = round(world.maxy/2) //get world center y
	if(T.x < halfmaxx)
		. |= WEST
	else
		. |= EAST

	if(T.y < halfmaxy)
		. |= SOUTH
	else
		. |= NORTH

/proc/shared_transition_edge_get_mimic_turf(var/src_x, var/src_y, var/level_max_width, var/level_max_height)
	var/mirrored_x = src_x
	if (src_x <= TRANSITIONEDGE)
		mirrored_x = src_x + (level_max_width - 2*TRANSITIONEDGE) - 1
	else if (src_x >= (level_max_width - TRANSITIONEDGE))
		mirrored_x = src_x - (level_max_width  - 2*TRANSITIONEDGE) + 1

	var/mirrored_y = src_y
	if(src_y <= TRANSITIONEDGE)
		mirrored_y = src_y + (level_max_height - 2*TRANSITIONEDGE) - 1
	else if (src_y >= (level_max_height - TRANSITIONEDGE))
		mirrored_y = src_y - (level_max_height - 2*TRANSITIONEDGE) + 1

	return list(mirrored_x, mirrored_y)

/proc/shared_transition_edge_get_mimic_coordinates(var/turf/T, var/datum/level_data/target_ldat)
	if(!target_ldat)
		CRASH("Got transition_edge turf([T.x], [T.y], [T.z]) linking to a non-existent level!")
	var/maxx = target_ldat?.level_max_width  ? target_ldat.level_max_width  : world.maxx
	var/maxy = target_ldat?.level_max_height ? target_ldat.level_max_height : world.maxy
	. = shared_transition_edge_get_mimic_turf(T.x, T.y, maxx, maxy)
	. += target_ldat?.level_z //Append z coordinate to x and y

/proc/shared_transition_edge_get_valid_level_data(var/turf/T)
	var/datum/level_data/ldat = SSmapping.levels_by_z[T.z]
	var/edge_dir         = get_turf_to_world_center_direction(T)
	var/connected_lvl_id = ldat.get_connected_level_id(edge_dir)

	if(!connected_lvl_id)
		CRASH("Got transition_edge turf([T.x], [T.y], [T.z]) in direction [dir2text(edge_dir)] that doesn't connect to anything!")
	return SSmapping.levels_by_id[connected_lvl_id]

/proc/shared_transition_edge_bumped(var/turf/T, var/atom/movable/AM, var/mimic_z)
	var/datum/level_data/LD = SSmapping.levels_by_z[mimic_z]
	var/maxx  = LD?.level_max_width  ? LD.level_max_width  : world.maxx
	var/maxy  = LD?.level_max_height ? LD.level_max_height : world.maxy
	var/new_x = AM.x
	var/new_y = AM.y

	//Get the position to teleport the thing to
	if(T.x <= TRANSITIONEDGE)
		new_x = maxx - TRANSITIONEDGE - 1
	else if (T.x >= (maxx - TRANSITIONEDGE))
		new_x = TRANSITIONEDGE + 1
	else if (T.y <= TRANSITIONEDGE)
		new_y = maxy - TRANSITIONEDGE - 1
	else if (T.y >= (maxy - TRANSITIONEDGE))
		new_y = TRANSITIONEDGE + 1

	//Teleport to the turf
	var/turf/dest = locate(new_x, new_y, mimic_z)
	if(dest && !dest.density)
		AM.forceMove(dest)
		//Move grabbed things
		if(isliving(AM))
			var/mob/living/L = AM
			for(var/obj/item/grab/G in L.get_active_grabs())
				G.affecting.forceMove(dest)

////////////////////////////////
// Transition Edges
////////////////////////////////

///When soemthing touches this turf, it gets transported to the connected level matching the direction of the edge on the map
#define IMPLEMENT_TRANSITION_EDGE(TURF_TYPE)\
TURF_TYPE/mimic_edge/transition/setup_mimic(){\
	var/list/coord = shared_transition_edge_get_mimic_coordinates(src, shared_transition_edge_get_valid_level_data(src));\
	set_mimic_turf(coord[1], coord[2], coord[3]);}\
\
TURF_TYPE/mimic_edge/transition/Bumped(atom/movable/AM){\
	. = ..();\
	shared_transition_edge_bumped(src, AM, mimic_z);}

IMPLEMENT_TRANSITION_EDGE(/turf/simulated)
IMPLEMENT_TRANSITION_EDGE(/turf/unsimulated)
IMPLEMENT_TRANSITION_EDGE(/turf/exterior)

#undef IMPLEMENT_TRANSITION_EDGE

////////////////////////////////
// Loop Edges
////////////////////////////////

///When something touches this turf, it gets transported to the symmetrically opposite turf it's mimicking.
#define IMPLEMENT_LOOP_EDGE(TURF_TYPE) \
TURF_TYPE/mimic_edge/transition/loop/set_mimic_turf(_x, _y, _z){. = ..(_x, _y);}\
\
TURF_TYPE/mimic_edge/transition/setup_mimic(){\
	var/list/coord = shared_transition_edge_get_mimic_coordinates(src, SSmapping.levels_by_z[src.z]);\
	set_mimic_turf(coord[1], coord[2], coord[3]);}

IMPLEMENT_LOOP_EDGE(/turf/simulated)
IMPLEMENT_LOOP_EDGE(/turf/unsimulated)
IMPLEMENT_LOOP_EDGE(/turf/exterior)

#undef IMPLEMENT_LOOP_EDGE