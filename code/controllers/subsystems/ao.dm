SUBSYSTEM_DEF(ao)
	name = "Ambient Occlusion"
	init_order = SS_INIT_MISC_LATE
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags = SS_NO_INIT

	var/list/queue = list()
	var/list/cache = list()

	var/updates_async = 0
	var/updates_sync = 0

/datum/controller/subsystem/ao/stat_entry()
	..("Q: [queue.len] T: { A: [updates_async] | S: [updates_sync] }")

/datum/controller/subsystem/ao/fire(resumed = 0, no_mc_tick = FALSE)
	var/list/curr = queue
	while (curr.len)
		var/turf/target = curr[curr.len]
		curr.len--

		if (!QDELETED(target))
			target.update_ao()
			updates_async++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/ao/StartLoadingMap()
	suspend()

/datum/controller/subsystem/ao/StopLoadingMap()
	wake()
