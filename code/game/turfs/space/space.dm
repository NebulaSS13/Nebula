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

	/// If we're an edge.
	var/edge = 0
	/// Force this one to pretend it's an overedge turf.
	var/forced_dirs = 0 

/turf/space/update_ambient_light(var/mapload)
	if(config.starlight && (locate(/turf/simulated) in RANGE_TURFS(src, 1)))
		set_light(config.starlight, 0.75, l_color = SSskybox.background_color)
	else
		set_light(0)

/turf/space/Initialize(var/mapload)

	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_FLAG_INITIALIZED

	update_ambient_light(mapload)

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

/turf/space/LateInitialize()
	if(global.using_map.base_floor_area)
		var/area/new_area = locate(global.using_map.base_floor_area) || new global.using_map.base_floor_area
		ChangeArea(src, new_area)
	ChangeTurf(global.using_map.base_floor_type)

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/space/is_solid_structure()
	return locate(/obj/structure/lattice, src) //counts as solid structure if it has a lattice

/turf/space/attackby(obj/item/C, mob/user)

	if (istype(C, /obj/item/stack/material/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return L.attackby(C, user)
		var/obj/item/stack/material/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice(R.material.type)
			return TRUE

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (!S.use(1))
				return
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ChangeTurf(/turf/simulated/floor/airless)
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

/turf/space/proc/Sandbox_Spacemove(atom/movable/A)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||global.global_map.len)
		y_arr = global.global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		log_debug("Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		log_debug("Target Z = [target_z]")
		log_debug("Next X = [next_x]")

		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > global.global_map.len ? 1 : cur_x)
		y_arr = global.global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		log_debug("Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		log_debug("Target Z = [target_z]")
		log_debug("Next X = [next_x]")

		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global.global_map[cur_x]
		next_y = (--cur_y||y_arr.len)
		target_z = y_arr[next_y]
/*
		//debug
		log_debug("Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		log_debug("Next Y = [next_y]")
		log_debug("Target Z = [target_z]")

		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global.global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]
/*
		//debug
		log_debug("Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		log_debug("Next Y = [next_y]")
		log_debug("Target Z = [target_z]")

		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return

/turf/space/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE)
	return ..(N, tell_universe, TRUE, keep_air)

/turf/space/is_open()
	return TRUE

// Spooky turfs for shuttles and possible future transit use
/turf/space/infinity
	name = "\proper infinity"
	icon_state = "bluespace"
