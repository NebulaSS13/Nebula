/mob
	/// Simple general-use reference for mob automoves. May be unused or replaced on subtypes.
	var/atom/_automove_target

/mob/stop_automove()
	_automove_target = null
	return ..()

/// Called by get_movement_delay() to override the current move intent, in cases where an automove has a delay override.
/mob/proc/get_automove_delay()
	var/datum/automove_metadata/metadata = SSautomove.moving_metadata[src]
	return metadata?.move_delay

/mob/start_automove(target, movement_type, datum/automove_metadata/metadata)
	_automove_target = target
	return ..()

// The AI datum may decide to track a target instead of using the mob reference.
/mob/get_automove_target(datum/automove_metadata/metadata)
	. = (istype(ai) && ai.get_automove_target()) || _automove_target || ..()

// We do some early checking here to avoid doing the same checks repeatedly by calling SelfMove().
/mob/can_do_automated_move(variant_move_delay)
	. = MayMove() && !incapacitated() && (!istype(ai) || ai.can_do_automated_move())
