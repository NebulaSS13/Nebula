///////////////////////////////////////////////////////////////////////////
// Overlays
///////////////////////////////////////////////////////////////////////////

/atom/movable/overlay
	anchored = TRUE
	simulated = FALSE
	var/atom/master = null
	var/follow_proc = /atom/movable/proc/move_to_loc_or_null
	var/expected_master_type = /atom

/atom/movable/overlay/Initialize()
	if(!loc)
		PRINT_STACK_TRACE("[type] created in nullspace.")
		return INITIALIZE_HINT_QDEL
	master = loc
	if(expected_master_type && !istype(master, expected_master_type))
		return INITIALIZE_HINT_QDEL
	SetName(master.name)
	set_dir(master.dir)

	if(follow_proc && istype(master, /atom/movable))
		events_repository.register(/decl/observ/moved, master, src, follow_proc)
		SetInitLoc()

	events_repository.register(/decl/observ/destroyed, master, src, /datum/proc/qdel_self)
	events_repository.register(/decl/observ/dir_set, master, src, /atom/proc/recursive_dir_set)

	. = ..()

/atom/movable/overlay/proc/SetInitLoc()
	forceMove(master.loc)

/atom/movable/overlay/Destroy()
	if(istype(master, /atom/movable))
		events_repository.unregister(/decl/observ/moved, master, src)
	events_repository.unregister(/decl/observ/destroyed, master, src)
	events_repository.unregister(/decl/observ/dir_set, master, src)
	master = null
	. = ..()

/atom/movable/overlay/attackby(obj/item/I, mob/user)
	if (master)
		return master.attackby(I, user)

/atom/movable/overlay/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return master?.attack_hand(user)
