SUBSYSTEM_DEF(pathfinding)
	name       = "Pathfinding"
	priority   = SS_PRIORITY_PATHFINDING
	init_order = SS_INIT_MISC_LATE
	wait       = 1

	var/list/pending        = list()
	var/list/processing     = list()
	var/list/mover_metadata = list()

	VAR_PRIVATE/static/_default_adjacency_call = TYPE_PROC_REF(/turf, CardinalTurfsWithAccess)
	VAR_PRIVATE/static/_default_distance_call  = TYPE_PROC_REF(/turf, Distance)

/atom/movable
	var/waiting_for_path

/atom/movable/proc/path_found(list/path)
	SHOULD_CALL_PARENT(TRUE)
	waiting_for_path = null

/atom/movable/proc/path_not_found()
	SHOULD_CALL_PARENT(TRUE)
	waiting_for_path = null

/datum/controller/subsystem/pathfinding/proc/dequeue_mover(atom/movable/mover, include_processing = TRUE)
	if(!istype(mover))
		return
	mover.waiting_for_path = null
	pending        -= mover
	mover_metadata -= mover
	if(include_processing)
		processing -= mover

// Hook to allow legacy use of AStar* to reuse the callback refs
/datum/controller/subsystem/pathfinding/proc/find_path_immediate(start, end, max_nodes, max_node_depth = 30, min_target_dist = 0, min_node_dist, id, datum/exclude, check_tick = FALSE)
	return find_path_astar(start, end, _default_adjacency_call, _default_distance_call, max_nodes, max_node_depth, min_target_dist, min_node_dist, id, exclude, check_tick)

/datum/controller/subsystem/pathfinding/proc/enqueue_mover(atom/movable/mover, atom/target, datum/pathfinding_metadata/metadata)
	if(!istype(mover) || mover.waiting_for_path)
		return FALSE
	if(!istype(target))
		return FALSE
	pending |= mover
	pending[mover] = target
	if(istype(metadata))
		mover_metadata[mover] = metadata
	mover.waiting_for_path = world.time
	return TRUE

/datum/controller/subsystem/pathfinding/stat_entry(msg)
	. = ..("Q:[length(pending)] P:[length(processing)]")

/datum/controller/subsystem/pathfinding/fire(resumed)

	if(!resumed)
		processing = pending?.Copy()

	var/atom/movable/mover
	var/atom/target
	var/datum/pathfinding_metadata/metadata
	var/i = 0

	while(i < processing.len)

		i++
		mover  = processing[i]
		target = processing[mover]
		metadata = mover_metadata[mover]
		dequeue_mover(mover, include_processing = FALSE)

		if(!QDELETED(mover) && !QDELETED(target))
			try_find_path(mover, target, metadata)

		if (MC_TICK_CHECK)
			processing.Cut(1, i+1)
			return

	processing.Cut()

/datum/controller/subsystem/pathfinding/proc/try_find_path(atom/movable/mover, atom/target, datum/pathfinding_metadata/metadata, adjacency_call = _default_adjacency_call, distance_call = _default_distance_call)

	var/started_pathing = world.time
	mover.waiting_for_path = started_pathing

	var/list/path = find_path_astar(
		get_turf(mover),
		target,
		adjacency_call,
		distance_call,
		(metadata?.max_nodes || null),
		(metadata?.max_node_depth || 250),
		metadata?.min_target_dist,
		metadata?.min_node_depth,
		(metadata?.id || mover.GetIdCard()),
		metadata?.obstacle,
		check_tick = TRUE
	)
	if(mover.waiting_for_path == started_pathing)
		if(length(path))
			mover.path_found(path)
		else
			mover.path_not_found()

/datum/pathfinding_metadata
	var/max_nodes        = null
	var/max_node_depth   = 250
	var/atom/id          = null
	var/min_target_dist  = null
	var/min_node_depth   = null
	var/obstacle         = null

/datum/pathfinding_metadata/New(_max_nodes, _max_node_depth, _id, _min_target_dist, _min_node_depth, _obstacle)

	id        = _id
	obstacle  = _obstacle
	max_nodes = _max_nodes

	if(!isnull(_max_node_depth))
		max_node_depth  = _max_node_depth
	if(!isnull(_min_target_dist))
		min_target_dist = _min_target_dist
	if(!isnull(_min_node_depth))
		min_node_depth  = _min_node_depth
