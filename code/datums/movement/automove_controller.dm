/// Implements automove logic; can be overridden on mob procs if you want to vary the logic from the below.
/decl/automove_controller
	// these could be proper bools but i assumed they were set up this way for a reason, like supporting other return values in the future
	var/completion_signal   = FALSE // Set to PROCESS_KILL if you want movement to stop processing when the atom reaches its target.
	var/failure_signal      = FALSE // Set to PROCESS_KILL if you want movement to stop processing when the atom fails to move.
	var/try_avoid_obstacles = TRUE  // Will try to move 90 degrees around an obstacle.

/decl/automove_controller/proc/check_move_completion(atom/movable/mover, datum/automove_metadata/metadata)
	// Null target means abandon pathing, regardless of return signals.
	var/atom/target = mover.get_automove_target(metadata)
	if(!istype(target))
		return TRUE

	// Cease automovement if we're already at the target.
	var/acceptable_move_dist = isnull(metadata?.acceptable_distance) ? mover.get_acceptable_automove_distance_from_target() : metadata.acceptable_distance
	var/current_distance = get_dist(mover, target)
	if(metadata?.avoid_target)
		return current_distance >= acceptable_move_dist
	else
		if(get_turf(mover) == get_turf(target))
			return TRUE
		if(ismovable(target) && (target.density && mover.density) && mover.Adjacent(target))
			return TRUE
		if(current_distance <= acceptable_move_dist)
			return TRUE
	return FALSE

/// Return PROCESS_KILL to terminate automovement. Will return completion_signal when the atom reaches its target and failure_signal if it fails to move.
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
			return

	if(check_move_completion(mover, metadata))
		mover.finished_automove()
		return completion_signal

	// Skip automovement if we aren't allowed to move yet.
	// This is for checks that are expected to fail sometimes (movedelay, incapacitation, etc), so we don't send the failure signal when this happens.
	if(!mover.can_do_automated_move(metadata?.move_delay))
		return

	var/avoid_target = metadata?.avoid_target
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
			return // no idea how we would get into this position

	var/old_next_move_time = mover.get_next_move_time() // to reset to later, so obstacle bumps don't let us ignore move delay
	if(mover.SelfMove(target_dir) && (old_loc != mover.loc))
		mover.handle_post_automoved(old_loc)
		// check if we're done, and if so, return the completion signal
		if(check_move_completion(mover, metadata))
			mover.finished_automove()
			return completion_signal
		return // we moved, so we didn't fail, but we also aren't finished yet
	else
		if(try_avoid_obstacles)
			// Try to move around any obstacle.
			var/static/list/_alt_dir_rot = list(45, -45)
			for(var/alt_dir in shuffle(_alt_dir_rot))
				mover.set_next_move_time(old_next_move_time)
				if(mover.SelfMove(turn(target_dir, alt_dir)) && (old_loc != mover.loc))
					mover.handle_post_automoved(old_loc)
					// check if we're done, and if so, return the completion signal
					if(check_move_completion(mover, metadata))
						mover.finished_automove()
						return completion_signal
					return // see above; we succeeded on the retry but aren't done moving

		mover.failed_automove()
		return failure_signal

/decl/automove_controller/stop_on_completion
	completion_signal = PROCESS_KILL

/decl/automove_controller/stop_on_fail_or_completion
	completion_signal = PROCESS_KILL
	failure_signal = PROCESS_KILL