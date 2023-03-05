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
		//log_debug("[src]([x],[y],[z]) mirroring [NT]([NT.x],[NT.y],[NT.z])")
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
		//log_debug("[src]([x],[y],[z]) mirroring [NT]([NT.x],[NT.y],[NT.z])")
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
		//log_debug("[src]([x],[y],[z]) mirroring [NT]([NT.x],[NT.y],[NT.z])")
		LAZYADD(., NT)

/turf/exterior/mimic_edge/proc/set_mimic_turf(var/_x, var/_y, var/_z)
	mimic_z = _z? _z : z
	mimic_x = _x
	mimic_y = _y
	refresh_vis_contents()

////////////////////////////////
// Transition Edges
////////////////////////////////

///Returns the a cardinal direction for a turf on the map that's beyon the transition edge
/proc/get_turf_transition_edge_direction(var/turf/T)
	var/datum/level_data/LD = SSmapping.levels_by_z[T.z]

	var/x_bef_left_transit   = T.x < LD.level_inner_min_x
	var/x_aft_right_transit  = T.x > LD.level_inner_max_x
	var/y_bef_bottom_transit = T.y < LD.level_inner_min_y
	var/y_aft_top_transit    = T.y > LD.level_inner_max_y

	if(x_bef_left_transit && !y_bef_bottom_transit && !y_aft_top_transit)
		return WEST
	else if(x_aft_right_transit && !y_bef_bottom_transit && !y_aft_top_transit)
		return EAST
	else if(y_bef_bottom_transit && !x_bef_left_transit && !x_aft_right_transit)
		return SOUTH
	else if(y_aft_top_transit && !x_bef_left_transit && !x_aft_right_transit)
		return NORTH
	else
		CRASH("Tried to get the transition edge direction of a corner turf!")


/proc/shared_transition_edge_get_mimic_turf(var/src_x, var/src_y, var/inner_min_x, var/inner_min_y, var/inner_max_x, var/inner_max_y)
	var/x_bef_left_transit   = src_x < inner_min_x
	var/x_aft_right_transit  = src_x > inner_max_x
	var/y_bef_bottom_transit = src_y < inner_min_y
	var/y_aft_top_transit    = src_y > inner_max_y

	var/translate_from_dir
	if(x_bef_left_transit && !y_bef_bottom_transit && !y_aft_top_transit)
		translate_from_dir = WEST
	else if(x_aft_right_transit && !y_bef_bottom_transit && !y_aft_top_transit)
		translate_from_dir = EAST
	else if(y_bef_bottom_transit && !x_bef_left_transit && !x_aft_right_transit)
		translate_from_dir = SOUTH
	else if(y_aft_top_transit && !x_bef_left_transit && !x_aft_right_transit)
		translate_from_dir = NORTH
	else
		//In this case we're in the corners of the map. We shouldn't mimic.
		return null

	var/newx = src_x
	var/newy = src_y
	switch(translate_from_dir)
		if(NORTH)
			newy = (inner_min_y - 1) + (src_y - inner_max_y)
		if(SOUTH)
			newy = (inner_max_y + 1) - (inner_min_y - src_y)
		if(EAST)
			newx = (inner_min_x - 1) + (src_x - inner_max_x)
		if(WEST)
			newx = (inner_max_x + 1) - (inner_min_x - src_x)

	return list(newx, newy)


/proc/shared_transition_edge_get_mimic_coordinates(var/turf/T, var/datum/level_data/target_ldat)
	if(!target_ldat)
		CRASH("Got transition_edge turf([T.x], [T.y], [T.z]) linking to a non-existent level!")
	var/list/coord = shared_transition_edge_get_mimic_turf(
		T.x,
		T.y,
		target_ldat.level_inner_min_x,
		target_ldat.level_inner_min_y,
		target_ldat.level_inner_max_x,
		target_ldat.level_inner_max_y
	)
	if(isnull(coord))
		log_warning("Transition turf at ([T.x], [T.y], [T.z]) was in a corner. That's likely a mistake!")
		coord = list(T.x, T.y)
	coord += target_ldat.level_z //Append z coordinate to x and y
	return coord

/proc/shared_transition_edge_get_valid_level_data(var/turf/T)
	var/datum/level_data/ldat = SSmapping.levels_by_z[T.z]
	var/edge_dir         = get_turf_transition_edge_direction(T)
	var/connected_lvl_id = ldat.get_connected_level_id(edge_dir)
	//log_debug("Got connected transition level id [connected_lvl_id] for turf [T]")

	if(!connected_lvl_id)
		CRASH("Got transition_edge turf([T.x], [T.y], [T.z]) in direction [dir2text(edge_dir)] that doesn't connect to anything!")
	return SSmapping.levels_by_id[connected_lvl_id]

/proc/shared_transition_edge_bumped(var/turf/T, var/atom/movable/AM, var/mimic_z)
	var/datum/level_data/LDsrc = SSmapping.levels_by_z[T.z]
	var/datum/level_data/LDdst = SSmapping.levels_by_z[mimic_z]
	var/new_x = AM.x
	var/new_y = AM.y

	//Get the position to teleport the thing to
	if(T.x <= LDsrc.level_inner_min_x)
		new_x = LDdst.level_inner_max_x
	else if (T.x >= LDsrc.level_inner_max_x)
		new_x = LDdst.level_inner_min_x
	else if (T.y <= LDsrc.level_inner_min_y)
		new_y = LDdst.level_inner_max_y
	else if (T.y >= LDsrc.level_inner_max_y)
		new_y = LDdst.level_inner_min_y
	else
		return //If we're teleporting into the same spot just quit early

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
/turf/simulated/mimic_edge/transition/setup_mimic()
	var/list/coord = shared_transition_edge_get_mimic_coordinates(src, shared_transition_edge_get_valid_level_data(src))
	set_mimic_turf(coord[1], coord[2], coord[3])
/turf/simulated/mimic_edge/transition/Bumped(atom/movable/AM)
	. = ..()
	shared_transition_edge_bumped(src, AM, mimic_z)

/turf/unsimulated/mimic_edge/transition/setup_mimic()
	var/list/coord = shared_transition_edge_get_mimic_coordinates(src, shared_transition_edge_get_valid_level_data(src))
	set_mimic_turf(coord[1], coord[2], coord[3])
/turf/unsimulated/mimic_edge/transition/Bumped(atom/movable/AM)
	. = ..()
	shared_transition_edge_bumped(src, AM, mimic_z)

/turf/exterior/mimic_edge/transition/setup_mimic()
	var/list/coord = shared_transition_edge_get_mimic_coordinates(src, shared_transition_edge_get_valid_level_data(src))
	set_mimic_turf(coord[1], coord[2], coord[3])
/turf/exterior/mimic_edge/transition/Bumped(atom/movable/AM)
	. = ..()
	shared_transition_edge_bumped(src, AM, mimic_z)

////////////////////////////////
// Loop Edges
////////////////////////////////

///When something touches this turf, it gets transported to the symmetrically opposite turf it's mimicking.
/turf/simulated/mimic_edge/transition/loop/set_mimic_turf(_x, _y, _z)
	. = ..(_x, _y)
/turf/simulated/mimic_edge/transition/loop/setup_mimic()
	var/list/coord = shared_transition_edge_get_mimic_coordinates(src, SSmapping.levels_by_z[src.z])
	set_mimic_turf(coord[1], coord[2], coord[3])

/turf/unsimulated/mimic_edge/transition/loop/set_mimic_turf(_x, _y, _z)
	. = ..(_x, _y)
/turf/unsimulated/mimic_edge/transition/loop/setup_mimic()
	var/list/coord = shared_transition_edge_get_mimic_coordinates(src, SSmapping.levels_by_z[src.z])
	set_mimic_turf(coord[1], coord[2], coord[3])

/turf/exterior/mimic_edge/transition/loop/set_mimic_turf(_x, _y, _z)
	. = ..(_x, _y)
/turf/exterior/mimic_edge/transition/loop/setup_mimic()
	var/list/coord = shared_transition_edge_get_mimic_coordinates(src, SSmapping.levels_by_z[src.z])
	set_mimic_turf(coord[1], coord[2], coord[3])