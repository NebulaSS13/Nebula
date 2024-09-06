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
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src, angle = 0)
	angle = round(SIMPLIFY_DEGREES(angle), 90) // can only turn at right angles
	var/adj = 1
	var/opp = 0
	switch(angle)
		if(90)
			adj = 0
			opp = 1 // swap the X and Y axes
		if(180)
			adj = -1 // flip across the axes
			opp = 0
		if(270)
			adj = 0
			opp = -1 // swap the X and Y axes and then flip
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/dx = (source.x - src_origin.x)
		var/dy = (source.y - src_origin.y)
		var/dz = (source.z - src_origin.z)
		var/x_pos = dst_origin.x + dx * adj + dy * opp
		var/y_pos = dst_origin.y + dy * adj - dx * opp // y-axis is flipped in BYOND :(
		var/z_pos = dst_origin.z + dz

		var/turf/target = locate(x_pos, y_pos, z_pos)
		if(!target)
			error("Null turf in translation @ ([x_pos], [y_pos], [z_pos])")
		turf_map[source] = target //if target is null, preserve that information in the turf map

	return turf_map


/proc/translate_turfs(list/translation, area/base_area = null, turf/base_turf, ignore_background, translate_air, angle = 0)
	. = list()
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			if(base_area)
				ChangeArea(target, get_area(source))
				. += transport_turf_contents(source, target, ignore_background, translate_air, angle = angle)
				ChangeArea(source, base_area)
			else
				. += transport_turf_contents(source, target, ignore_background, translate_air, angle = angle)
	//change the old turfs
	for(var/turf/source in translation)
		if(ignore_background && (source.turf_flags & TURF_FLAG_BACKGROUND))
			continue
		var/old_turf = source.prev_type || base_turf || get_base_turf_by_area(source)
		var/turf/changed = source.ChangeTurf(old_turf, keep_air = !translate_air)
		changed.prev_type = null

// Currently used only for shuttles. If it gets generalized rename it.
/atom/proc/shuttle_rotate(angle)
	if(angle)
		set_dir(SAFE_TURN(dir, angle))
		addtimer(CALLBACK(src, PROC_REF(queue_icon_update)), 1)
		return TRUE

// Adjust pixel_x, pixel_y, etc. for things without directional_offset.
// This may cause issues with things that shouldn't rotate. Those should be using pixel_w and pixel_z, preferably!
/obj/shuttle_rotate(angle)
	. = ..()
	if(. && isnull(directional_offset) && (pixel_x || pixel_y))
		var/adj = cos(angle)
		var/opp = sin(angle)
		var/old_pixel_x = pixel_x
		var/old_pixel_y = pixel_y
		pixel_x = adj * old_pixel_x + opp * old_pixel_y
		pixel_y = adj * old_pixel_y + opp * old_pixel_x

/obj/structure/shuttle_rotate(angle)
	. = ..()
	if(.)
		addtimer(CALLBACK(src, PROC_REF(update_connections), TRUE), 1)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, queue_icon_update)), 1)

/obj/machinery/network/requests_console/shuttle_rotate(angle)
	. = ..(-angle) // for some reason directions are switched for these

/obj/machinery/firealarm/shuttle_rotate(angle)
	. = ..(-angle)

/obj/machinery/door/shuttle_rotate(angle)
	. = ..()
	if(.)
		addtimer(CALLBACK(src, PROC_REF(update_connections), TRUE), 1)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, queue_icon_update)), 1)

//Transports a turf from a source turf to a target turf, moving all of the turf's contents and making the target a copy of the source.
//If ignore_background is set to true, turfs with TURF_FLAG_BACKGROUND set will only translate anchored contents.
//Returns the new turf, or list(new turf, source) if a background turf was ignored and things may have been left behind.
/proc/transport_turf_contents(turf/source, turf/target, ignore_background, translate_air, angle = 0)
	var/target_type = target.type
	var/turf/new_turf
	// byond's coordinate system is weird so we have to invert the angle
	angle = -angle

	var/is_background = ignore_background && (source.turf_flags & TURF_FLAG_BACKGROUND)
	var/supported = FALSE // Whether or not there's an object in the turf which can support other objects.
	if(is_background)
		new_turf = target
	else
		new_turf = target.ChangeTurf(source.type, 1, 1, !translate_air)
		new_turf.transport_properties_from(source, translate_air)
		new_turf.shuttle_rotate(angle)
		new_turf.prev_type = target_type

	for(var/obj/O in source)
		if(O.obj_flags & OBJ_FLAG_NOFALL)
			supported = TRUE
			break

	for(var/obj/O in source)
		if((O.movable_flags & MOVABLE_FLAG_ALWAYS_SHUTTLEMOVE) || (O.simulated && (!is_background || supported || (O.obj_flags & OBJ_FLAG_MOVES_UNSUPPORTED))))
			O.forceMove(new_turf)
			O.shuttle_rotate(angle)

	for(var/mob/M in source)
		if(is_background && !supported)
			continue
		if(isEye(M))
			continue // If we need to check for more mobs, I'll add a variable
		M.forceMove(new_turf)
		M.shuttle_rotate(angle)

	if(is_background)
		return list(new_turf, source)

	return new_turf

/proc/get_dir_z_text(turf/origin, turf/target)

	origin = get_turf(origin)
	target = get_turf(target)

	if(!istype(origin) || !istype(target) || !(origin.z in SSmapping.get_connected_levels(target.z, include_lateral = TRUE)))
		return "somewhere"
	if(origin == target)
		return "right next to you"

	var/datum/level_data/origin_level = SSmapping.levels_by_z[origin.z]
	var/datum/level_data/target_level = SSmapping.levels_by_z[target.z]

	if(origin_level.z_volume_level_z < target_level.z_volume_level_z)
		. += "above and to"
	else if(origin_level.z_volume_level_z > target_level.z_volume_level_z)
		. += "below and to"

	var/origin_x = origin.x + origin_level.z_volume_level_x
	var/origin_y = origin.y + origin_level.z_volume_level_y
	var/target_x = target.x + target_level.z_volume_level_x
	var/target_y = target.y + target_level.z_volume_level_y

	if(origin_x == target_x)
		if(origin_y > target_y)
			. += "the south"
		else
			. += "the north"
	else if(origin_y == target_y)
		if(origin_x > target_x)
			. += "the west"
		else
			. += "the east"
	else
		if(origin_x > target_x)
			if(origin_y > target_y)
				. += "the southwest"
			else
				. += "the northwest"
		else
			if(origin_y > target_y)
				. += "the southeast"
			else
				. += "the northeast"
