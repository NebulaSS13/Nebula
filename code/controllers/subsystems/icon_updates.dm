SUBSYSTEM_DEF(icon_update)
	name = "Icon Updates"
	wait = 1
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT // If you make it not fire in lobby, you also have to remove atoms from queue in Destroy.

	// Linked lists, queue_refs[x] should have null or args stored in queue_args[x]
	var/list/queue_refs = list()	// Atoms
	var/list/queue_args = list()	// null or args

/datum/controller/subsystem/icon_update/stat_entry()
	..("Queue: [queue_refs.len]")

/datum/controller/subsystem/icon_update/Initialize()
	fire(FALSE, TRUE)

/datum/controller/subsystem/icon_update/fire(resumed = FALSE, no_mc_tick = FALSE)
	if(!queue_refs.len)
		suspend()
		return

	while (queue_refs.len)

		if(Master.map_loading)
			return

		// Pops the atom and it's args
		var/atom/A = queue_refs[queue_refs.len]
		var/myArgs = queue_args[queue_args.len]

		queue_refs.len -= 1
		queue_args.len -= 1

		if(QDELETED(A))
			continue

		A.icon_update_queued = FALSE

		if (islist(myArgs))
			A.update_icon(arglist(myArgs))
		else
			A.update_icon()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/atom
	var/icon_update_queued = FALSE

/atom/proc/queue_icon_update(...)
	// Skips if this is already queued
	if(!icon_update_queued)

		icon_update_queued = TRUE
		SSicon_update.queue_refs.Add(src)

		// Makes sure these are in sync, in case runtimes/badmin
		var/length = length(SSicon_update.queue_refs)
		SSicon_update.queue_args.len = length
		SSicon_update.queue_args[length] = args.len ? args : null

		// SSicon_update sleeps when it runs out of things in its
		// queue, so wake it up.
		if(!Master.map_loading) // Don't wake early if we're loading a map, it'll get woken up when the map loads.
			SSicon_update.wake()

/datum/controller/subsystem/icon_update/StartLoadingMap()
	suspend()

/datum/controller/subsystem/icon_update/StopLoadingMap()
	wake()
