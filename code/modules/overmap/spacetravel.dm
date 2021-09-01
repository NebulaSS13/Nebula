//list used to cache empty zlevels to avoid nedless map bloat
var/global/list/cached_space = list()

//Space stragglers go here

/obj/effect/overmap/visitable/sector/temporary
	name = "Deep Space"
	invisibility = 101
	sector_flags = OVERMAP_SECTOR_IN_SPACE

/obj/effect/overmap/visitable/sector/temporary/Initialize(mapload, var/nx, var/ny, var/nz)
	var/start_loc = locate(1, 1, nz) // This will be moved to the overmap in ..(), but must start on this z level for init to function.
	forceMove(start_loc)
	start_x = nx // This is overmap position
	start_y = ny
	testing("Temporary sector at [x],[y] was created, corresponding zlevel is [nz].")
	. = ..()

/obj/effect/overmap/visitable/sector/temporary/Destroy()
	for(var/num in map_z)
		global.overmap_sectors -= "[num]"
	testing("Temporary sector at [x],[y] was deleted.")
	global.cached_space -= src
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
