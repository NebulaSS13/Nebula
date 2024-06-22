/// Implements automove logic; can be overridden on mob procs if you want to vary the logic from the below.
/decl/automove_controller
	var/completion_signal = FALSE // Set to TRUE if you want movement to stop processing when the atom reaches its target.
	var/failure_signal    = FALSE // Set to TRUE if you want movement to stop processing when the atom fails to move.

/decl/automove_controller/proc/handle_mover(atom/movable/mover, datum/automove_metadata/metadata)

	// Cease automovement if we got an invalid mover..
	if(!istype(mover))
		return PROCESS_KILL

	// Null target means abandon pathing, regardless of return signals.
	var/atom/target = mover.get_automove_target(metadata)
	if(!istype(target))
		return PROCESS_KILL

	// Return early if we are in the process of moving, as we will definitely fail MayMove at the end()
	if(ismob(mover))
		var/mob/mover_mob = mover
		if(mover_mob.moving)
			return TRUE

	// Cease automovement if we're already at the target.
	var/avoid_target = metadata?.avoid_target
	if(!avoid_target && (get_turf(mover) == get_turf(target) || (ismovable(target) && mover.Adjacent(target))))
		mover.finished_automove()
		return completion_signal

	// Cease movement if we're close enough to the target.
	var/acceptable_move_dist = isnull(metadata?.acceptable_distance) ? mover.get_acceptable_automove_distance_from_target() : metadata.acceptable_distance
	if(avoid_target ? (get_dist(mover, target) >= acceptable_move_dist) : (get_dist(mover, target) <= acceptable_move_dist))
		mover.finished_automove()
		return completion_signal

	// Cease automovement if we failed to move a turf.
	if(mover.can_do_automated_move(metadata?.move_delay))
		if(avoid_target)
			target = get_edge_target_turf(target, get_dir(target, mover))

		// Note for future coders: SelfMove() only confirms if a handler handled the move, not if the atom moved.
		var/old_loc = mover.loc

		// Try to move directly.
		var/target_dir = get_dir(mover, target)
		if(!target_dir)
			if(avoid_target)
				target_dir = pick(global.cardinal)
			else
				return TRUE // no idea how we would get into this position

		if(mover.SelfMove(target_dir) && (old_loc != mover.loc))
			return TRUE

		// Try to move around any obstacle.
		var/static/list/_alt_dir_rot = list(45, -45)
		for(var/alt_dir in shuffle(_alt_dir_rot))
			mover.reset_movement_delay()
			if(mover.SelfMove(turn(target_dir, alt_dir)) && (old_loc != mover.loc))
				return TRUE

		mover.failed_automove()

	return failure_signal
