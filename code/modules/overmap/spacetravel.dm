//list used to cache empty zlevels to avoid nedless map bloat
var/global/list/cached_temporary_sectors = list()

//Space stragglers go here
/obj/effect/overmap/visitable/sector/temporary
	name = "Deep Space"
	invisibility = 101
	sector_flags = OVERMAP_SECTOR_IN_SPACE

/obj/effect/overmap/visitable/sector/temporary/Initialize(mapload, var/nx, var/ny, var/nz)
	var/start_loc = locate(nx, ny, nz)
	forceMove(start_loc)
	start_x = nx // This is overmap position
	start_y = ny
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		testing("Temporary sector at [x],[y],[z] was created, corresponding zlevel is [nz].")

/obj/effect/overmap/visitable/sector/temporary/Destroy()

	for(var/num in map_z)
		global.overmap_sectors -= "[num]"

	var/datum/overmap/overmap = global.overmaps_by_z["[z]"]
	if(istype(overmap) && (overmap.map_turf_type in global.cached_temporary_sectors))
		global.cached_temporary_sectors[overmap.map_turf_type] -= src
		if(!length(global.cached_temporary_sectors[overmap.map_turf_type]))
			global.cached_temporary_sectors -= overmap.map_turf_type

	testing("Temporary sector at [x],[y],[z] was deleted.")

	return ..()

/obj/effect/overmap/visitable/sector/temporary/proc/can_die(var/mob/observer)
	testing("Checking if sector at [map_z[1]] can die.")
	for(var/mob/M in global.player_list)
		if(M != observer && (M.z in map_z))
			testing("There are people on it.")
			return 0
	return 1

/atom/movable/proc/overmap_can_discard()
	for(var/atom/movable/AM in contents)
		if(!AM.overmap_can_discard())
			return FALSE
	return TRUE

/mob/overmap_can_discard()
	return isnull(client)

/mob/living/carbon/human/overmap_can_discard()
	return isnull(client) && (!last_ckey || stat == DEAD)
