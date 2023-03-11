/datum/overmap
	var/name
	var/assigned_z

	var/event_areas = 11
	var/map_size_x = 20
	var/map_size_y = 20

	var/overmap_edge_type = /turf/unsimulated/map/edge
	var/overmap_turf_type = /turf/unsimulated/map
	var/overmap_area_type = /area/overmap
	var/empty_level_type =  /datum/level_data/space

	var/list/valid_event_types

	/// list used to cache empty zlevels to avoid needless z-stack bloat
	var/list/cached_temporary_sectors = list()

/datum/overmap/New(var/_name)

	name = _name

	if(!name)
		PRINT_STACK_TRACE("Unnamed overmap datum instantiated: [type]")

	if(global.overmaps_by_name[name])
		PRINT_STACK_TRACE("Duplicate overmap datum instantiated: [type], [name], [overmaps_by_name[name]]")
	global.overmaps_by_name[name] = src

	generate_overmap()
	testing("Overmap build for [name] complete.")

	if(!assigned_z)
		PRINT_STACK_TRACE("Overmap datum generated null assigned z_level.")

	if(global.overmaps_by_z["[assigned_z]"])
		PRINT_STACK_TRACE("Duplicate overmap datum instantiated for z-level: [type], [assigned_z], [overmaps_by_name[name]]")
	global.overmaps_by_z["[assigned_z]"] = src

	for(var/event_type in subtypesof(/datum/overmap_event))
		var/datum/overmap_event/event = event_type
		if(initial(event.overmap_id) == name)
			LAZYADD(valid_event_types, event_type)

	..()

/datum/overmap/proc/populate_overmap()
	var/area/overmap/A = locate(overmap_area_type) || new overmap_area_type //level_data should have initialized the area
	for(var/square in block(locate(1, 1, assigned_z), locate(map_size_x, map_size_y, assigned_z)))
		var/turf/T = square
		if(T.x == map_size_x || T.y == map_size_y)
			T = T.ChangeTurf(overmap_edge_type)
		else
			T = T.ChangeTurf(overmap_turf_type)
		ChangeArea(T, A)

/datum/overmap/proc/generate_overmap()
	testing("Building overmap [name]...")
	SSmapping.increment_world_z_size(/datum/level_data/overmap)
	assigned_z = world.maxz
	testing("Putting [name] on [assigned_z].")
	populate_overmap()
	SSmapping.sealed_levels |= assigned_z
	. = TRUE

/datum/overmap/proc/travel(var/turf/space/T, var/atom/movable/A)
	if (!T || !A)
		return

	var/obj/effect/overmap/visitable/M = global.overmap_sectors[num2text(T.z)]
	if (!M)
		return

	if(A.overmap_can_discard())
		if(!QDELETED(A))
			qdel(A)
		return

	var/nx = 1
	var/ny = 1
	var/nz = 1

	if(T.x <= TRANSITIONEDGE)
		nx = world.maxx - TRANSITIONEDGE - 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
		nx = TRANSITIONEDGE + 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (T.y <= TRANSITIONEDGE)
		ny = world.maxy - TRANSITIONEDGE -2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
		ny = TRANSITIONEDGE + 2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	testing("[name]: [A] ([A.z],[A.y],[A.z]) travelling from [M] ([M.x],[M.y]).")

	var/turf/map = locate(M.x,M.y,assigned_z)
	var/obj/effect/overmap/visitable/TM
	for(var/obj/effect/overmap/visitable/O in map)
		if(O != M && (O.sector_flags & OVERMAP_SECTOR_IN_SPACE) && prob(50))
			TM = O
			break
	if(!TM)
		TM = create_temporary_sector(M.x,M.y)
	nz = pick(TM.map_z)

	var/turf/dest = locate(nx,ny,nz)
	if(dest && !dest.density)
		A.forceMove(dest)
		if(isliving(A))
			var/mob/living/L = A
			for(var/obj/item/grab/G in L.get_active_grabs())
				G.affecting.forceMove(dest)

	if(istype(M, /obj/effect/overmap/visitable/sector/temporary))
		var/obj/effect/overmap/visitable/sector/temporary/source = M
		if(source.can_die())
			source.forceMove(null)
			if(!QDELETED(source))
				testing("Caching [M] for future use")
				if(!length(cached_temporary_sectors[empty_level_type]))
					cached_temporary_sectors[empty_level_type] = list()
				cached_temporary_sectors[empty_level_type] |= source

/datum/overmap/proc/create_temporary_sector(x,y)

	// There's already a sector at this x/y
	var/obj/effect/overmap/visitable/sector/temporary/res = locate(x, y, assigned_z)
	if(istype(res) && !QDELETED(res))
		return res

	// We might have a sector cached we can give them.
	if(length(cached_temporary_sectors[empty_level_type]))
		res = pick_n_take(cached_temporary_sectors[empty_level_type])
		if(!length(cached_temporary_sectors[empty_level_type]))
			cached_temporary_sectors -= empty_level_type
		if(istype(res) && !QDELETED(res))
			res.forceMove(locate(x, y, assigned_z))
			return res

	// Create a new one.
	var/datum/level_data/level = SSmapping.increment_world_z_size(empty_level_type)
	return new /obj/effect/overmap/visitable/sector/temporary(null, x, y, level.level_z)

/datum/overmap/proc/discard_temporary_sector(var/obj/effect/overmap/visitable/sector/temporary/sector)
	if(!length(cached_temporary_sectors[empty_level_type]))
		return
	cached_temporary_sectors[empty_level_type] -= sector
	if(!length(cached_temporary_sectors[empty_level_type]))
		cached_temporary_sectors -= empty_level_type
