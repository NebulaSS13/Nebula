//	Observer Pattern Implementation: Moved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has moved using Move() or forceMove().
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that moved
//			/atom/old_loc: The loc before the move.
//			/atom/new_loc: The loc after the move.

/decl/observ/moved
	name = "Moved"
	expected_type = /atom/movable
	flags = OBSERVATION_NO_GLOBAL_REGISTRATIONS

/decl/observ/moved/register(var/atom/movable/mover, var/datum/listener, var/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(mover.loc, expected_type))
		register(mover.loc, mover, /atom/movable/proc/recursive_move)

/********************
* Movement Handling *
********************/

/atom/Entered(var/atom/movable/am, var/atom/old_loc)
	. = ..()
	events_repository.raise_event(/decl/observ/moved, am, old_loc, am.loc)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	var/decl/observ/moved/moved_event = GET_DECL(/decl/observ/moved)
	if(moved_event.has_listeners(am))
		events_repository.register(/decl/observ/moved, src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/new_loc)
	. = ..()
	events_repository.unregister(/decl/observ/moved, src, am, /atom/movable/proc/recursive_move)
