SUBSYSTEM_DEF(vis_contents_update)
	name = "Vis Contents"
	flags = SS_BACKGROUND
	wait = 1
	priority = SS_PRIORITY_VIS_CONTENTS
	init_order = SS_INIT_VIS_CONTENTS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/queue_refs = list()

/datum/controller/subsystem/vis_contents_update/stat_entry()
	..("Queue: [queue_refs.len]")

/datum/controller/subsystem/vis_contents_update/Initialize()
	fire(FALSE, TRUE)

/datum/controller/subsystem/vis_contents_update/StartLoadingMap()
	suspend()

/datum/controller/subsystem/vis_contents_update/StopLoadingMap()
	wake()

// Largely copied from SSicon_update.
/datum/controller/subsystem/vis_contents_update/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/cached_refs = queue_refs // cache the instance var for more speed
	if(!length(cached_refs))
		suspend()
		return
	var/i = 0
	while (i < length(cached_refs))
		if(Master.map_loading)
			break
		var/atom/A = cached_refs[++i]
		if(QDELETED(A))
			continue
		A.vis_update_queued = FALSE
		A.update_vis_contents()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	cached_refs.Cut(1, i+1)

/atom
	var/vis_update_queued = FALSE

/atom/proc/queue_vis_contents_update()
	if(vis_update_queued)
		return
	vis_update_queued = TRUE
	SSvis_contents_update.queue_refs[++SSvis_contents_update.queue_refs.len] = src
	if(SSvis_contents_update.suspended && !Master.map_loading) // Don't wake early if we're loading a map, it'll get woken up when the map loads.
		SSvis_contents_update.wake()

// Horrible colon syntax below is because vis_contents
// exists in /atom.vars, but will not compile. No idea why.
/atom/proc/add_vis_contents(adding)
	src:vis_contents |= adding

/atom/proc/remove_vis_contents(removing)
	src:vis_contents -= removing

/atom/proc/clear_vis_contents()
	src:vis_contents = null

/atom/proc/set_vis_contents(list/adding)
	src:vis_contents = adding

/atom/proc/get_vis_contents_to_add()
	return

/atom/proc/update_vis_contents()
	if(Master.map_loading || SSvis_contents_update.init_state == SS_INITSTATE_NONE || TICK_CHECK)
		queue_vis_contents_update()
		return
	vis_update_queued = FALSE
	var/new_vis_contents = get_vis_contents_to_add()
	if(length(new_vis_contents))
		set_vis_contents(new_vis_contents)
	else if(length(src:vis_contents))
		clear_vis_contents()

/image/proc/add_vis_contents(adding)
	vis_contents |= adding

/image/proc/remove_vis_contents(removing)
	vis_contents -= removing

/image/proc/clear_vis_contents()
	vis_contents.Cut()

/image/proc/set_vis_contents(list/adding)
	vis_contents = adding
