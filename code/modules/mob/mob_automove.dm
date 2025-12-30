/mob
	/// Simple general-use reference for mob automoves. May be unused or replaced on subtypes.
	var/atom/_automove_target

/mob/stop_automove()
	_automove_target = null
	return ..()

/mob/path_found(list/path)
	..()
	if(islist(path) && length(path) > 1)
		path.Cut(1, 2) // Remove the first turf since it's going to be our origin.
		if(length(path))
			start_automove(path)

/mob/path_not_found()
	..()
	stop_automove()

/// Called by get_movement_delay() to override the current move intent, in cases where an automove has a delay override.
/mob/proc/get_automove_delay()
	var/datum/automove_metadata/metadata = SSautomove.moving_metadata[src]
	return metadata?.move_delay

/mob/failed_automove()
	..()
	stop_automove()
	_automove_target = null
	return FALSE

/mob/start_automove(target, movement_type, datum/automove_metadata/metadata)
	_automove_target = target
	return ..()

// The AI datum may decide to track a target instead of using the mob reference.
/mob/get_automove_target(datum/automove_metadata/metadata)
	. = _automove_target || (istype(ai) && ai.get_automove_target()) || ..()
	if(islist(.))
		var/list/path = .
		while(length(path) && path[1] == get_turf(src))
			path.Cut(1,2)
		if(length(path))
			return path[1]
		return null

/mob/handle_post_automoved(atom/old_loc)
	if(istype(ai))
		ai.handle_post_automoved(old_loc)
		return
	if(!islist(_automove_target) || length(_automove_target) <= 0)
		return
	var/turf/body_turf = get_turf(src)
	if(!istype(body_turf))
		return
	var/list/_automove_target_list = _automove_target
	if(_automove_target_list[1] != body_turf)
		return
	if(length(_automove_target_list) > 1)
		_automove_target_list.Cut(1, 2)
	else
		_automove_target_list = null
		stop_automove()

// We do some early checking here to avoid doing the same checks repeatedly by calling SelfMove().
/mob/can_do_automated_move(variant_move_delay)
	. = MayMove() && !incapacitated() && (!istype(ai) || ai.can_do_automated_move())
