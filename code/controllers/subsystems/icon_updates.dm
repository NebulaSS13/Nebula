SUBSYSTEM_DEF(icon_update)
	name = "Icon Updates"
	wait = 1
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT // If you make it not fire in lobby, you also have to remove atoms from queue in Destroy.

	// Linked lists, queue_refs[x] should have null or args stored in queue_args[x]
	var/list/queue_refs = list()	// Atoms

/datum/controller/subsystem/icon_update/stat_entry()
	..("Queue: [queue_refs.len]")

/datum/controller/subsystem/icon_update/Initialize()
	fire(FALSE, TRUE)

/datum/controller/subsystem/icon_update/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/cached_refs = queue_refs // local variables are quicker to access than instance variables. it's still the same list though
	if(!cached_refs.len)
		suspend()
		return

	var/static/count = 1 // proc-level static var, as with SSgarbage, in case a runtime makes this proc end early
	while (count <= length(cached_refs)) // if we kept a copy of the queue to avoid mutating it while we run, this could possibly be made a lot faster by just using a for loop?
		if(Master.map_loading) // we started loading a map mid-run, so stop and clean up
			break
		// Pops the atom from the queue
		var/atom/A = cached_refs[count++] // count is used to cut our list later and save time
		if(QDELETED(A))
			continue
		A.icon_update_queued = FALSE
		A.update_icon()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	cached_refs.Cut(1, count)
	count = 1

/atom
	var/icon_update_queued = FALSE

/atom/proc/queue_icon_update()
	// Skips if this is already queued
	if(icon_update_queued)
		return
	icon_update_queued = TRUE
	// This is faster than using Add() because BYOND.
	SSicon_update.queue_refs[++SSicon_update.queue_refs.len] = src

	// SSicon_update sleeps when it runs out of things in its
	// queue, so wake it up.
	if(!Master.map_loading) // Don't wake early if we're loading a map, it'll get woken up when the map loads.
		SSicon_update.wake()

/datum/controller/subsystem/icon_update/StartLoadingMap()
	suspend()

/datum/controller/subsystem/icon_update/StopLoadingMap()
	wake()
