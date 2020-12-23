//Z-level generation

var/subspace_level

/datum/map
	var/subspace_floor      = /turf/unsimulated/floor/subspace
	var/area/subspace_area  = /area/space/subspace

/datum/map/proc/generate_subspace()
	INCREMENT_WORLD_Z_SIZE

	global.subspace_level          = world.maxz
	GLOB.using_map.subspace_area   = new subspace_area

	GLOB.using_map.player_levels                            += global.subspace_level
	GLOB.using_map.sealed_levels                            += global.subspace_level
	GLOB.using_map.base_turf_by_z["[global.subspace_level]"] = GLOB.using_map.subspace_floor

	for(var/sx = 1, sx <= world.maxx, sx++)
		for(var/sy = 1, sy <= world.maxy, sy++)
			var/turf/T = locate(sx,sy,global.subspace_level)
			T.ChangeTurf(GLOB.using_map.subspace_floor)
			ChangeArea(T, GLOB.using_map.subspace_area)

/datum/map/setup_map()
	..()
	generate_subspace()

//Area

/area/space/subspace
	name             = "Subspace"
	dynamic_lighting = 0

/area/space/subspace/has_gravity()
	return 1

//Turf

/turf/unsimulated/floor/subspace
	name        = "\proper subspace"
	desc        = "Looks like eternity."

	icon        = 'icons/turf/space.dmi'
	icon_state  = "bluespace"
	color       = COLOR_SUBSPACE
	alpha       = 100

	initial_gas = list()

/turf/unsimulated/floor/subspace/Initialize()
	. = ..()
	alpha = rand(60,120)

/turf/unsimulated/floor/subspace/Entered(var/atom/movable/O, var/atom/oldloc)
	. = ..()
	if(isliving(O))
		var/mob/living/L = O
		if(!defense_check(L))
			L.dust()
		var/lastalpha = alpha
		alpha = 255
		animate(src,alpha = lastalpha,time = pick(5,10))

/mob/living/var/subspace_defense = 0 //time until subspace defense ends

/turf/unsimulated/floor/subspace/proc/defense_check(var/atom/movable/O)
	. = 0
	if(isliving(O))
		var/mob/living/L = O
		var/mob/living/carbon/human/H = L
		if(world.time < L.subspace_defense)               . = 1
		if(issilicon(L))                                  . = 1
		if(istype(H) && H.get_pressure_weakness(0) < 0.5) . = 1

//Visuals

/obj/effect/shift
	mouse_opacity = 0
	icon          = 'icons/effects/static.dmi'

/obj/effect/shift/Initialize()
	. = ..()
	icon_state = "[rand(1,9)] heavy"
	animate(src,alpha = 0,time = 5)
	QDEL_IN(src,5)

//Various helpers

/atom/movable/var/last_z

/proc/in_subspace(var/atom/A)
	return A.z == global.subspace_level

/proc/subspace_turf(var/turf/T)
	return locate(T.x,T.y,global.subspace_level)

//Subspace shifts

/proc/subspace_shift(var/atom/movable/A, var/newz = null, var/effect = /obj/effect/shift)
	var/turf/T = get_turf(A)
	if(!T) return
	var/turf/exit
	if(in_subspace(A))
		exit = locate(T.x,T.y,newz ? newz : A.last_z)
		new effect(exit)
	else
		A.last_z = A.z
		exit = locate(T.x,T.y,global.subspace_level)
		new effect(T)
	do_teleport(A,exit,0,/decl/teleport)

/proc/timed_shift(var/atom/movable/A,var/time)
	if(isliving(A))
		var/mob/living/L = A
		L.subspace_defense = world.time + time + 5
	subspace_shift(A)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/subspace_shift, A), time)

//Just throws things from one loc to another

/proc/subspace_channel(var/turf/start, var/turf/end, var/range = 3)
	var/list/success = list()
	for(var/atom/movable/A in range(start,range))
		A.throw_at(end,get_dist(start,end),80)
	for(var/atom/movable/A in range(end,  range))
		success += A
	return success

//Meant to be used in almost everything

/decl/teleport/subspace/teleport_target(var/atom/movable/target, var/atom/destination, var/precision)

	if(isliving(target))
		var/mob/living/L = target
		L.subspace_defense = world.time + 10

	if(!in_subspace(target)) subspace_shift(target)

	var/list/to_exit = subspace_channel(get_turf(target),subspace_turf(destination))
	for(var/atom/movable/A in to_exit)
		subspace_shift(A,destination.z)

	grabs_teleport(target,destination,precision)

//Grab things

/decl/teleport/teleport_target(var/atom/movable/target, var/atom/destination, var/precision)
	..()
	grabs_teleport(target,destination,precision)

/decl/teleport/proc/grabs_teleport(var/atom/movable/target, var/atom/destination, var/precision)

	var/mob/living/carbon/human/H = target
	if(!istype(H)) return

	for(var/obj/item/grab/G in H.contents)
		var/turf/grab_exit = locate(destination.x + (G.affecting.x - target.x), destination.y + (G.affecting.y - target.y), target.z)
		if(!can_teleport(G.affecting, grab_exit)) continue
		teleport_target(G.affecting, grab_exit, precision)