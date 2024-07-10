/turf/space
	name = "\proper space"
	plane = SPACE_PLANE
	icon = 'icons/turf/space.dmi'
	explosion_resistance = 3
	icon_state = "default"
	dynamic_lighting = FALSE
	temperature = T20C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	permit_ao = FALSE
	z_eventually_space = TRUE
	turf_flags = TURF_FLAG_BACKGROUND
	can_inherit_air = FALSE

	open_turf_type = /turf/space

	/// If we're an edge.
	var/edge = 0
	/// Force this one to pretend it's an overedge turf.
	var/forced_dirs = 0

/turf/space/Initialize()

	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_FLAG_INITIALIZED

	AMBIENCE_QUEUE_TURF(src)

	//We might be an edge
	if(y == world.maxy || forced_dirs & NORTH)
		edge |= NORTH
	else if(y == 1 || forced_dirs & SOUTH)
		edge |= SOUTH

	if(x == 1 || forced_dirs & WEST)
		edge |= WEST
	else if(x == world.maxx || forced_dirs & EAST)
		edge |= EAST

	if(edge) //Magic edges
		appearance = SSskybox.mapedge_cache["[edge]"]
	else //Dust
		appearance = SSskybox.dust_cache["[((x + y) ^ ~(x * y) + z) % 25]"]

	if(!HasBelow(z))
		return INITIALIZE_HINT_NORMAL

	var/turf/below = GetBelow(src)
	if(isspaceturf(below))
		return INITIALIZE_HINT_NORMAL

	var/area/A = below.loc
	if(!below.density && (A.area_flags & AREA_FLAG_EXTERNAL))
		return INITIALIZE_HINT_NORMAL

	return INITIALIZE_HINT_LATELOAD // oh no! we need to switch to being a different kind of turf!

/turf/space/LateInitialize()
	if(SSmapping.base_floor_area)
		var/area/new_area = locate(SSmapping.base_floor_area) || new SSmapping.base_floor_area
		ChangeArea(src, new_area)
	ChangeTurf(SSmapping.base_floor_type)

/turf/space/proc/toggle_transit(var/direction)
	if(edge)
		return

	if(!direction) //Stopping our transit
		appearance = SSskybox.dust_cache["[((x + y) ^ ~(x * y) + z) % 25]"]
	else if(direction & (NORTH|SOUTH)) //Starting transit vertically
		var/x_shift = SSskybox.phase_shift_by_x[x % (SSskybox.phase_shift_by_x.len - 1) + 1]
		var/transit_state = ((direction & SOUTH ? world.maxy - y : y) + x_shift) % 15
		appearance = SSskybox.speedspace_cache["NS_[transit_state]"]
	else if(direction & (EAST|WEST)) //Starting transit horizontally
		var/y_shift = SSskybox.phase_shift_by_y[y % (SSskybox.phase_shift_by_y.len - 1) + 1]
		var/transit_state = ((direction & WEST ? world.maxx - x : x) + y_shift) % 15
		appearance = SSskybox.speedspace_cache["EW_[transit_state]"]

	for(var/atom/movable/AM in src)
		if (AM.simulated && !AM.anchored)
			AM.throw_at(get_step(src, global.reverse_dir[direction]), 5, 1)

		if(istype(AM, /obj/effect/decal))
			qdel(AM)

/turf/space/Destroy()
	// Cleanup cached z_eventually_space values above us.
	if (above)
		var/turf/T = src
		while ((T = GetAbove(T)))
			T.z_eventually_space = FALSE

	return ..()

/turf/space/attackby(obj/item/C, mob/user)

	if (istype(C, /obj/item/stack/material/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return L.attackby(C, user)
		var/obj/item/stack/material/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(src, R.material.type)
			return TRUE

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (!S.use(1))
				return
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ChangeTurf(/turf/floor/airless)
			qdel(L)
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")
		return TRUE


// Ported from unstable r355

/turf/space/Entered(atom/movable/A)
	..()
	if(A && A.loc == src && !density) // !density so 'fake' space turfs don't fling ghosts everywhere
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE + 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE + 1))
			A.touch_map_edge(OVERMAP_ID_SPACE)

/turf/space/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE, var/update_open_turfs_above = TRUE)
	return ..(N, tell_universe, TRUE, keep_air, update_open_turfs_above)

/turf/space/is_open()
	return TRUE

// Spooky turfs for shuttles and possible future transit use
/turf/space/infinity
	name = "\proper infinity"
	icon_state = "bluespace"
