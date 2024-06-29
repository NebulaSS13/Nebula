// These procs are a way to implement something like walk_to()/walk_away()
// while also preserving the full move chain for mobs. /obj and such can
// get away with walk(), but mobs need to set move delays, update glide size, etc.

/atom/movable/proc/get_default_automove_controller_type()
	return /decl/automove_controller

/// Cancels automoving and unregisters the atom from the subsystem, including the current processing run.
/atom/movable/proc/stop_automove()
	SHOULD_CALL_PARENT(TRUE)
	walk_to(src, 0) // Legacy call to stop BYOND's inbuilt movement.
	SSautomove.unregister_mover(src)

/// Registers an atom with SSautomove, including a move handler and metadata. Moving will begin next tick.
/atom/movable/proc/start_automove(target, movement_type, datum/automove_metadata/metadata)
	SHOULD_CALL_PARENT(TRUE)
	SSautomove.register_mover(src, (movement_type || get_default_automove_controller_type()), metadata)

/// Called when an atom is within the acceptable parameters for not moving further (ideal range). Does not necessarily imply the atom has unregistered (see stop_automove()).
/atom/movable/proc/finished_automove()
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/// Called by SSautomove when an atom fails to move in circumstances where it would like to. As with finished_automove, does not imply unregistering from SSautomove.
/atom/movable/proc/failed_automove()
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

// Jesus Christ why do I write such long proc names
/// Used by some mobs to vary the acceptable distance from target when automoving.
/atom/movable/proc/get_acceptable_automove_distance_from_target()
	return 0

/// Should return a reference to the current atom target.
/atom/movable/proc/get_automove_target(datum/automove_metadata/metadata)
	return null

/// Generalized entrypoint for checking CanMove and such on /mob.
/atom/movable/proc/can_do_automated_move(variant_move_delay)
	return FALSE
