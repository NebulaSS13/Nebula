#define MIMIC_EDGE_NAME "world's edge"
#define MIMIC_EDGE_DESC "Flatearther's nightmare."

////////////////////////////////
// Mimic Edges
////////////////////////////////

///Dummy mouse-opaque overlay to prevent people turning/shooting towards ACTUAL location of vis_content thing
/obj/effect/overlay/click_bait
	name = "distant terrain"
	desc = "You need to come over there to take a better look."
	mouse_opacity = MOUSE_OPACITY_PRIORITY

////////////////////////////////
// Shared Mimic Edges
////////////////////////////////

///Shared proc to provide the default vis_content for the edge_turf.
/proc/shared_mimic_edge_get_add_vis_contents(var/turf/edge_turf, var/turf/mimic_turf, var/list/vis_cnt)
	if(mimic_turf)
		edge_turf.density = mimic_turf.density
		edge_turf.opacity = mimic_turf.opacity
		//log_debug("[src]([x],[y],[z]) mirroring [NT]([NT.x],[NT.y],[NT.z])")
		LAZYADD(vis_cnt, mimic_turf)
	return vis_cnt

////////////////////////////////
// Simulated Mimic Edges
////////////////////////////////

///Simulated turf meant to replicate the appearence of another.
/turf/mimic_edge
	name             = MIMIC_EDGE_NAME
	desc             = MIMIC_EDGE_DESC
	icon             = null
	icon_state       = null
	density          = FALSE
	permit_ao        = FALSE //would need AO proxy
	blocks_air       = TRUE  //would need air zone proxy
	dynamic_lighting = FALSE //Would need lighting proxy
	abstract_type    = /turf/mimic_edge

	///Mimicked turf's x position
	var/mimic_x
	///Mimicked turf's y position
	var/mimic_y
	///Mimicked turf's z position
	var/mimic_z
	///Ref to the dummy overlay
	var/obj/effect/overlay/click_bait/click_eater

/turf/mimic_edge/Initialize(ml)
	. = ..()
	//Clear ourselves from the ambient queue
	AMBIENCE_DEQUEUE_TURF(src)
	//Need to put a mouse-opaque overlay there to prevent people turning/shooting towards ACTUAL location of vis_content things
	click_eater = new(src) //#TODO: get rid of that once we got proper proxy atom handling
	setup_mimic()

/turf/mimic_edge/Destroy()
	QDEL_NULL(click_eater) //Make sure we get rid of it if the turf is somehow replaced by map gen to prevent them accumulating.
	return ..()

/turf/mimic_edge/Crossed(atom/movable/O)
	. = ..()
	if(isobserver(O))
		var/turf/drop_turf = get_mimic_turf()
		if(drop_turf)
			O.forceMove(drop_turf)

/turf/mimic_edge/resolve_to_actual_turf()
	return get_mimic_turf()

//Properly install itself, and allow overriding how the target turf is picked
/turf/mimic_edge/proc/setup_mimic()
	return

/turf/mimic_edge/on_update_icon()
	return

/turf/mimic_edge/get_vis_contents_to_add()
	. = shared_mimic_edge_get_add_vis_contents(src, get_mimic_turf(), list())

/turf/mimic_edge/proc/get_mimic_turf()
	return mimic_x && mimic_y && mimic_z && locate(mimic_x, mimic_y, mimic_z)

/turf/mimic_edge/proc/set_mimic_turf(var/_x, var/_y, var/_z)
	mimic_z = _z? _z : z
	mimic_x = _x
	mimic_y = _y
	update_vis_contents()

//Prevent ambient completely, we're not a real turf
/turf/mimic_edge/set_ambient_light(color, multiplier)
	return
/turf/mimic_edge/update_ambient_light(no_corner_update)
	return
/turf/mimic_edge/update_ambient_light_from_z_or_area()
	return
/turf/mimic_edge/lighting_build_overlay(now)
	return

////////////////////////////////
// Transition Edges Shared
////////////////////////////////

///Returns the a cardinal direction for a turf on the map that's beyond the transition edge
/proc/get_turf_transition_edge_direction(var/turf/T, var/datum/level_data/target_ldat)
	var/within_west_transit  = T.x < target_ldat.level_inner_min_x //Is the turf X within the west transition edge?
	var/within_east_transit  = T.x > target_ldat.level_inner_max_x //Is the turf X within the east transition edge?
	var/within_south_transit = T.y < target_ldat.level_inner_min_y //Is the turf Y within the south transition edge?
	var/within_north_transit = T.y > target_ldat.level_inner_max_y //Is the turf Y within the north transition edge?

	//Filter out corners, since we can't mimic those properly
	if(within_west_transit  && !within_south_transit && !within_north_transit)
		return WEST
	if(within_east_transit  && !within_south_transit && !within_north_transit)
		return EAST
	if(within_south_transit && !within_west_transit  && !within_east_transit)
		return SOUTH
	if(within_north_transit && !within_west_transit  && !within_east_transit)
		return NORTH

	//Corners return null
	return null

/// Returns the turf that's opposite to the specified turf, on the level specified.
/proc/shared_transition_edge_get_coordinates_turf_to_mimic(var/turf/T, var/datum/level_data/target_ldat)
	var/translate_from_dir = get_turf_transition_edge_direction(T, target_ldat)
	if(isnull(translate_from_dir))
		//In this case we're in the corners of the map. We shouldn't mimic.
		log_warning("Transition turf '[T]' at ([T.x], [T.y], [T.z]) was in a corner of the map. That's likely a mistake, since we can't mimic corners properly!")
		return list(T.x, T.y, T.z)

	var/newx = T.x
	var/newy = T.y
	switch(translate_from_dir)
		if(NORTH)
			newy = (target_ldat.level_inner_min_y - 1) + (T.y - target_ldat.level_inner_max_y) //The level_inner coords are inclusive, so we need to +- 1
		if(SOUTH)
			newy = (target_ldat.level_inner_max_y + 1) - (target_ldat.level_inner_min_y - T.y)
		if(EAST)
			newx = (target_ldat.level_inner_min_x - 1) + (T.x - target_ldat.level_inner_max_x)
		if(WEST)
			newx = (target_ldat.level_inner_max_x + 1) - (target_ldat.level_inner_min_x - T.x)

	return list(newx, newy, target_ldat.level_z)

///Grab the connected level data for the level connected in the direction the 'T' turf is in.
/proc/shared_transition_edge_get_valid_level_data(var/turf/T)
	var/datum/level_data/LD = SSmapping.levels_by_z[T.z]
	var/edge_dir            = get_turf_transition_edge_direction(T, LD)
	var/connected_lvl_id    = LD.get_connected_level_id(edge_dir)
	if(!connected_lvl_id)
		var/dirname = dir2text(edge_dir)
		CRASH("Got transition_edge turf '[T]' ([T.x], [T.y], [T.z]), in direction '[dirname]', but there is no connections in level_data '[LD]' for '[dirname]'!")
	return SSmapping.levels_by_id[connected_lvl_id]

///Handles teleporting an atom that touches a transition edge/loop edge.
/proc/shared_transition_edge_bumped(var/turf/T, var/atom/movable/AM, var/mimic_z)
	var/datum/level_data/LDsrc = SSmapping.levels_by_z[T.z]
	var/datum/level_data/LDdst = SSmapping.levels_by_z[mimic_z]
	var/new_x = AM.x
	var/new_y = AM.y

	//Get the position inside the destination level's bounds to teleport the thing to
	if(T.x < LDsrc.level_inner_min_x)
		new_x = LDdst.level_inner_max_x
	else if (T.x > LDsrc.level_inner_max_x)
		new_x = LDdst.level_inner_min_x
	else if (T.y < LDsrc.level_inner_min_y)
		new_y = LDdst.level_inner_max_y
	else if (T.y > LDsrc.level_inner_max_y)
		new_y = LDdst.level_inner_min_y
	else
		return //If we're teleporting into the same spot just quit early

	//Teleport to the turf
	var/turf/dest = locate(new_x, new_y, mimic_z)
	if(!dest)
		CRASH("Turf '[T]' failed to teleport '[AM]' to [new_x], [new_y], [mimic_z]. Couldn't locate turf!")
	if(dest.density)
		return //If the target turf is dense, just siltently do nothing.

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
/turf/mimic_edge/transition/setup_mimic()
	var/list/coord = shared_transition_edge_get_coordinates_turf_to_mimic(src, shared_transition_edge_get_valid_level_data(src))
	set_mimic_turf(coord[1], coord[2], coord[3])
/turf/mimic_edge/transition/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	if(!AM.simulated || AM.anchored || istype(AM, /obj/effect/overlay))
		return
	if(istype(AM, /obj/effect/projectile)) //#FIXME: Once we support projectiles going through levels properly remove this
		return
	shared_transition_edge_bumped(src, AM, mimic_z)

/turf/mimic_edge/transition/flooded
	flooded = /decl/material/liquid/water

////////////////////////////////
// Loop Edges
////////////////////////////////

///When something touches this turf, it gets transported to the symmetrically opposite turf it's mimicking.
/turf/mimic_edge/transition/loop/set_mimic_turf(_x, _y, _z)
	. = ..(_x, _y)
/turf/mimic_edge/transition/loop/setup_mimic()
	var/list/coord = shared_transition_edge_get_coordinates_turf_to_mimic(src, SSmapping.levels_by_z[src.z])
	set_mimic_turf(coord[1], coord[2], coord[3])

#undef MIMIC_EDGE_NAME
#undef MIMIC_EDGE_DESC