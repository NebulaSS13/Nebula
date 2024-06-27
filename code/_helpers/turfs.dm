// Returns the atom sitting on the turf.
// For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
/proc/get_atom_on_turf(var/atom/movable/M)
	var/atom/mloc = M
	while(mloc && mloc.loc && !istype(mloc.loc, /turf/))
		mloc = mloc.loc
	return mloc

// Picks a turf without a mob from the given list of turfs, if one exists.
// If no such turf exists, picks any random turf from the given list of turfs.
/proc/pick_mobless_turf_if_exists(var/list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

/proc/get_random_turf_in_range(var/atom/origin, var/outer_range, var/inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	for(var/turf/T in orange(origin, outer_range))
		if(!isSealedLevel(T.z)) // Picking a turf outside the map edge isn't recommended
			if(T.x >= world.maxx-TRANSITIONEDGE || T.x <= TRANSITIONEDGE)	continue
			if(T.y >= world.maxy-TRANSITIONEDGE || T.y <= TRANSITIONEDGE)	continue
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T
	if(turfs.len)
		return pick(turfs)

/*
	Predicate helpers
*/

/proc/is_holy_turf(var/turf/T)
	return (T?.turf_flags & TURF_FLAG_HOLY)

/proc/is_not_holy_turf(var/turf/T)
	return !is_holy_turf(T)

/proc/turf_is_simulated(var/turf/T)
	return T.simulated

/proc/turf_contains_dense_objects(var/turf/T)
	return T.contains_dense_objects()

/proc/not_turf_contains_dense_objects(var/turf/T)
	return !turf_contains_dense_objects(T)

/proc/is_station_turf(var/turf/T)
	return T && isStationLevel(T.z)

/proc/IsTurfAtmosUnsafe(var/turf/T)
	if(isspaceturf(T)) // Space tiles
		return "Spawn location is open to space."
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return "Spawn location lacks atmosphere."
	return get_atmosphere_issues(air, 1)

/proc/IsTurfAtmosSafe(var/turf/T)
	return !IsTurfAtmosUnsafe(T)

/proc/is_below_sound_pressure(var/turf/T)
	var/datum/gas_mixture/environment = T ? T.return_air() : null
	var/pressure =  environment ? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE

/*
	Turf manipulation
*/

//Returns an assoc list that describes how turfs would be changed if the
//turfs in turfs_src were translated by shifting the src_origin to the dst_origin
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_origin.x)
		var/y_pos = (source.y - src_origin.y)
		var/z_pos = (source.z - src_origin.z)

		var/turf/target = locate(dst_origin.x + x_pos, dst_origin.y + y_pos, dst_origin.z + z_pos)
		if(!target)
			error("Null turf in translation @ ([dst_origin.x + x_pos], [dst_origin.y + y_pos], [dst_origin.z + z_pos])")
		turf_map[source] = target //if target is null, preserve that information in the turf map

	return turf_map


/proc/translate_turfs(var/list/translation, var/area/base_area = null, var/turf/base_turf, var/ignore_background, var/translate_air)
	. = list()
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			if(base_area)
				ChangeArea(target, get_area(source))
				. += transport_turf_contents(source, target, ignore_background, translate_air)
				ChangeArea(source, base_area)
			else
				. += transport_turf_contents(source, target, ignore_background, translate_air)
	//change the old turfs
	for(var/turf/source in translation)
		if(ignore_background && (source.turf_flags & TURF_FLAG_BACKGROUND))
			continue
		var/old_turf = source.prev_type || base_turf || get_base_turf_by_area(source)
		source.ChangeTurf(old_turf, keep_air = !translate_air)

//Transports a turf from a source turf to a target turf, moving all of the turf's contents and making the target a copy of the source.
//If ignore_background is set to true, turfs with TURF_FLAG_BACKGROUND set will only translate anchored contents.
//Returns the new turf, or list(new turf, source) if a background turf was ignored and things may have been left behind.
/proc/transport_turf_contents(turf/source, turf/target, ignore_background, translate_air)
	var/target_type = target.type
	var/turf/new_turf

	var/is_background = ignore_background && (source.turf_flags & TURF_FLAG_BACKGROUND)
	var/supported = FALSE // Whether or not there's an object in the turf which can support other objects.
	if(is_background)
		new_turf = target
	else
		new_turf = target.ChangeTurf(source.type, 1, 1, !translate_air)
		new_turf.transport_properties_from(source, translate_air)
		new_turf.prev_type = target_type

	for(var/obj/O in source)
		if(O.obj_flags & OBJ_FLAG_NOFALL)
			supported = TRUE
			break

	for(var/obj/O in source)
		if((O.movable_flags & MOVABLE_FLAG_ALWAYS_SHUTTLEMOVE) || (O.simulated && (!is_background || supported || (O.obj_flags & OBJ_FLAG_MOVES_UNSUPPORTED))))
			O.forceMove(new_turf)

	for(var/mob/M in source)
		if(is_background && !supported)
			continue
		if(isEye(M))
			continue // If we need to check for more mobs, I'll add a variable
		M.forceMove(new_turf)

	if(is_background)
		return list(new_turf, source)

	return new_turf
