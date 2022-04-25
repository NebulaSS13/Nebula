//	Observer Pattern Implementation: Direction Set
//		Registration type: /atom
//
//		Raised when: An /atom changes dir using the set_dir() proc.
//
//		Arguments that the called proc should expect:
//			/atom/dir_changer: The instance that changed direction
//			/old_dir: The dir before the change.
//			/new_dir: The dir after the change.

/decl/observ/dir_set
	name = "Direction Set"
	expected_type = /atom
	flags = OBSERVATION_NO_GLOBAL_REGISTRATIONS

/decl/observ/dir_set/register(var/atom/dir_changer, var/datum/listener, var/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(dir_changer.loc, /atom/movable))	// We don't care about registering to turfs.
		register(dir_changer.loc, dir_changer, /atom/proc/recursive_dir_set)

/*********************
* Direction Handling *
*********************/

/atom/set_dir(ndir)
	var/old_dir = dir
	// This attempts to mimic BYOND's handling of diagonal directions and cardinal icon states.
	if((atom_flags & ATOM_FLAG_BLOCK_DIAGONAL_FACING) && !IsPowerOfTwo(ndir))
		if(old_dir & ndir)
			ndir = old_dir
		else
			ndir &= global.adjacentdirs[old_dir]
	. = ..(ndir)
	if(old_dir != dir)
		events_repository.raise_event(/decl/observ/dir_set, src, old_dir, dir)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	var/decl/observ/dir_set/dir_set_event = GET_DECL(/decl/observ/dir_set)
	if(dir_set_event.has_listeners(am))
		events_repository.register(/decl/observ/dir_set, src, am, /atom/proc/recursive_dir_set)

/atom/movable/Exited(var/atom/movable/am, atom/new_loc)
	. = ..()
	events_repository.unregister(/decl/observ/dir_set, src, am, /atom/proc/recursive_dir_set)
