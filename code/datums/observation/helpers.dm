/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	RAISE_EVENT(/decl/observ/moved, src, old_loc, new_loc)

/atom/movable/proc/move_to_turf(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

// Similar to above but we also follow into nullspace
/atom/movable/proc/move_to_turf_or_null(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T != loc)
		forceMove(T)

/atom/movable/proc/move_to_loc_or_null(var/atom/movable/am, var/old_loc, var/new_loc)
	if(new_loc != loc)
		forceMove(new_loc)

/atom/proc/recursive_dir_set(var/atom/a, var/old_dir, var/new_dir)
	set_dir(new_dir)

// Sometimes you just want to end yourself
/datum/proc/qdel_self()
	qdel(src)

/proc/register_all_movement(var/event_source, var/listener)
	events_repository.register(/decl/observ/moved, event_source, listener, TYPE_PROC_REF(/atom/movable, recursive_move))
	events_repository.register(/decl/observ/dir_set, event_source, listener, TYPE_PROC_REF(/atom, recursive_dir_set))

/proc/unregister_all_movement(var/event_source, var/listener)
	events_repository.unregister(/decl/observ/moved, event_source, listener, TYPE_PROC_REF(/atom/movable, recursive_move))
	events_repository.unregister(/decl/observ/dir_set, event_source, listener, TYPE_PROC_REF(/atom, recursive_dir_set))
