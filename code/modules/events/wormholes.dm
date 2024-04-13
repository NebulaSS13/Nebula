/datum/event/wormholes
	announceWhen = 10
	endWhen = 60

	var/list/pick_turfs = list()
	var/list/wormholes = list()
	var/shift_frequency = 3
	var/number_of_wormholes = 400

/datum/event/wormholes/setup(affected_z_levels = SSmapping.player_levels)
	if(affected_z_levels)
		affecting_z = affected_z_levels
	announceWhen = rand(0, 20)
	endWhen = rand(40, 80)

/datum/event/wormholes/start()
	var/list/areas = area_repository.get_areas_by_z_level()
	for(var/i in areas)
		var/area/A = areas[i]
		for(var/turf/T in A)
			if(!T.is_floor() || !T.simulated)
				continue
			if(!(T.z in affecting_z))
				continue
			if(isAdminLevel(T.z))
				continue
			if(turf_contains_dense_objects(T))
				continue
			pick_turfs += T

	for(var/i in 1 to min(length(pick_turfs), number_of_wormholes))
		var/turf/enter = pick_n_take(pick_turfs)
		var/turf/exit = pick_n_take(pick_turfs)

		wormholes += create_wormhole(enter, exit)

/datum/event/wormholes/announce()
	global.using_map.space_time_anomaly_detected_annoncement(affecting_z)

/datum/event/wormholes/tick()
	if(activeFor % shift_frequency == 0)
		for(var/obj/effect/portal/wormhole/O in wormholes)
			var/turf/T = pick(pick_turfs)
			if(T)
				O.forceMove(T)

/datum/event/wormholes/end()
	QDEL_NULL_LIST(wormholes)

/proc/create_wormhole(turf/enter, turf/exit)
	if(!enter || !exit)
		return
	var/obj/effect/portal/wormhole/W = new (enter)
	W.target = exit
	return W
