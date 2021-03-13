/datum/graph
	VAR_PRIVATE/list/nodes
	VAR_PRIVATE/list/edges

	VAR_PRIVATE/list/pending_connections
	VAR_PRIVATE/list/pending_disconnections
	VAR_PRIVATE/list/pending_movements

/datum/graph/New(var/list/nodes, var/list/edges, var/previous_owner = null)
	if(!length(nodes))
		CRASH("Invalid list of nodes: [log_info_line(nodes)]")
	if(length(nodes) > 1 && !istype(edges))
		CRASH("Invalid list of edges: [log_info_line(edges)]")
	for(var/n in nodes)
		var/datum/node/node = n
		if(node.graph && node.graph != previous_owner)
			CRASH("Attempted to add a node already belonging to a network")

	// TODO: Check that all edges refer to nodes in the graph and that the graph is coherent

	..()
	src.nodes = nodes
	src.edges = edges || list()

	for(var/n in nodes)
		var/datum/node/node = n
		node.graph = src

/datum/graph/Destroy(forced)
	if(!forced && (length(nodes) || LAZYLEN(pending_connections) || LAZYLEN(pending_disconnections)))
		PRINT_STACK_TRACE("Prevented attempt to delete a network that still has nodes: [length(nodes)] - [LAZYLEN(pending_connections)] - [LAZYLEN(pending_disconnections)]")
		return QDEL_HINT_LETMELIVE
	. = ..()

/datum/graph/proc/Connect(var/datum/node/node, var/list/neighbours, var/queue = TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!istype(neighbours))
		neighbours = list(neighbours)
	if(!length(neighbours))
		CRASH("Attempted to connect a node without declaring neighbours")
	if(length(nodes & neighbours) != length(neighbours))
		CRASH("Attempted to connect a node to neighbours not in the graph")

	var/list/neighbours_to_disconnect = LAZYACCESS(pending_disconnections, node)
	if(neighbours_to_disconnect)
		var/list/overlap = neighbours_to_disconnect & neighbours
		neighbours_to_disconnect -= overlap
		neighbours -= overlap
		if(neighbours_to_disconnect.len)
			LAZYSET(pending_disconnections, node, neighbours_to_disconnect)
		else
			LAZYREMOVE(pending_disconnections, node)

	var/list/neighbours_to_connect = LAZYACCESS(pending_connections, node)
	if(neighbours_to_connect)
		neighbours |= neighbours_to_connect

	if(neighbours.len)
		LAZYSET(pending_connections, node, neighbours)

	if(queue)
		SSgraphs_update.Queue(src)
	return TRUE

/datum/graph/proc/Disconnect(var/datum/node/node, var/list/neighbours, var/queue = TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(neighbours && !istype(neighbours))
		neighbours = list(neighbours)
	neighbours = neighbours || edges[node] // A null list of neighbours implies all neighbours
	if(!neighbours && length(nodes) == 1)
		neighbours = list() // A graph with only a single node is not likely to have edges and then, and only then, we allow neighbours to be null
	if(length(neighbours) && length(nodes & neighbours) != length(neighbours))
		CRASH("Attempted keep a node connected to neighbours not in the graph: [json_encode(nodes)], [json_encode(neighbours)]")
	if(!(node in nodes) && !(node in pending_connections))
		CRASH("Attempted disconnect a node that is not in the graph")

	var/list/neighbours_to_connect = LAZYACCESS(pending_connections, node)
	if(neighbours_to_connect)
		var/list/overlap = neighbours_to_connect & neighbours
		neighbours_to_connect -= overlap
		neighbours -= overlap
		if(neighbours_to_connect.len)
			LAZYSET(pending_connections, node, neighbours_to_connect)
		else
			LAZYREMOVE(pending_connections, node)

	var/list/neighbours_to_disconnect = LAZYACCESS(pending_disconnections, node)
	if(neighbours_to_disconnect)
		neighbours |= neighbours_to_disconnect

	if(neighbours.len)
		LAZYSET(pending_disconnections, node, neighbours)

	if(queue)
		SSgraphs_update.Queue(src)
	return TRUE

/datum/graph/proc/Merge(var/datum/graph/other)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(!other)
		return

	OnMerge(other)

	for(var/n in other.nodes)
		var/datum/node/node = n
		node.graph = src
	nodes += other.nodes
	edges += other.edges

	other.ProcessPendingMovements()
	for(var/other_node_to_be_connected in other.pending_connections)
		var/other_neighbours = other.pending_connections[other_node_to_be_connected]
		pending_connections[other_node_to_be_connected] = other_neighbours
	for(var/other_node_to_be_disconnected in other.pending_disconnections)
		var/other_formed_neighbours = other.pending_disconnections[other_node_to_be_disconnected]
		pending_disconnections[other_node_to_be_disconnected] = other_formed_neighbours

	other.nodes.Cut()
	other.edges.Cut()
	LAZYCLEARLIST(other.pending_connections)
	LAZYCLEARLIST(other.pending_disconnections)
	qdel(other)

// Subtypes that need to handle merging in specific ways should override this proc
/datum/graph/proc/OnMerge(var/datum/graph/other)
	SHOULD_NOT_SLEEP(TRUE)
	return

// Here subgraphs is a list of a list of nodes
/datum/graph/proc/Split(var/list/subgraphs)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	var/list/new_subgraphs = list()
	for(var/subgraph in subgraphs)
		if(length(subgraph) == 1)
			var/datum/node/N = subgraph[1] // Doing QDELETED(subgraph[1]) will result in multiple list index calls
			if(QDELETED(N))
				continue
		new_subgraphs += new type(subgraph, edges & subgraph, src)

	OnSplit(new_subgraphs)
	nodes.Cut()
	edges.Cut()
	qdel(src)

// Here subgraphs is a list of a list graphs (with their own lists of nodes and edges)
// Subtypes that need to handle splitting in specific ways should override this proc
// The original graph still has the same nodes/edges as before the split but will be deleted after this proc returns
/datum/graph/proc/OnSplit(var/list/datum/graph/subgraphs)
	SHOULD_NOT_SLEEP(TRUE)
	return

/datum/graph/proc/Moved(var/datum/node/physical/node)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!istype(node))
		CRASH("Invalid node type: [log_info_line(node)]")
	if(!(node in nodes) && !(node in pending_connections))
		CRASH("Attempted move a node that is not in the graph")

	LAZYDISTINCTADD(pending_movements, node)
	SSgraphs_update.Queue(src)

/datum/graph/proc/ProcessPendingConnections()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	ProcessPendingMovements()

	while(LAZYLEN(pending_connections))
		var/datum/node/N = pending_connections[pending_connections.len]
		var/list/new_neighbours = pending_connections[N]
		pending_connections.len--

		if(N.graph != src)
			Merge(N.graph)
		nodes |= N

		if(N in edges)
			edges[N] |= new_neighbours
		else
			edges[N] = new_neighbours

		for(var/new_neighbour in new_neighbours)
			var/neighbour_edges = edges[new_neighbour]
			if(!neighbour_edges)
				neighbour_edges = list()
				edges[new_neighbour] = neighbour_edges
			neighbour_edges |= N

	LAZYCLEARLIST(pending_connections)
	if(!LAZYLEN(pending_disconnections))
		return

	for(var/pending_node_disconnect in pending_disconnections)
		var/pending_edge_disconnects = pending_disconnections[pending_node_disconnect]
		for(var/connected_node in pending_edge_disconnects)
			edges[connected_node] -= pending_node_disconnect

			if(!length(edges[connected_node]))
				edges -= connected_node

			// If the other node also wanted to disconnect from us, this has now been handled
			var/other_pending_edge_disconnects = pending_disconnections[connected_node]
			if(other_pending_edge_disconnects)
				other_pending_edge_disconnects -= src
				if(!length(other_pending_edge_disconnects))
					pending_disconnections -= connected_node

		edges[pending_node_disconnect] -= pending_edge_disconnects
		if(!length(edges[pending_node_disconnect]))
			edges -= pending_node_disconnect

	LAZYCLEARLIST(pending_disconnections)

	var/list/subgraphs = list()
	var/list/all_nodes = nodes.Copy()
	while(length(all_nodes))
		var/root_node = all_nodes[all_nodes.len]
		all_nodes.len--
		var/checked_nodes = list()
		var/list/nodes_to_traverse = list(root_node)
		while(length(nodes_to_traverse))
			var/node_to_check = nodes_to_traverse[nodes_to_traverse.len]
			nodes_to_traverse.len--
			checked_nodes += node_to_check
			nodes_to_traverse |= ((edges[node_to_check] || list()) - checked_nodes)
		all_nodes -= checked_nodes
		subgraphs[++subgraphs.len] = checked_nodes

	if(length(subgraphs) == 1)
		if(!length(nodes))
			qdel(src)
	else
		Split(subgraphs)

/datum/graph/proc/ProcessPendingMovements()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	while(LAZYLEN(pending_movements))
		var/datum/node/physical/N = pending_movements[pending_movements.len]
		pending_movements.len--
		if(!N.holder.CheckNodeNeighbours())
			PRINT_STACK_TRACE("Invalid override of CheckNodeNeighbours() - Shall return true: [log_info_line(N.holder)]")

	LAZYCLEARLIST(pending_movements)

/datum/graph/proc/ConnectedNodes(var/datum/node/node)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	RETURN_TYPE(/list)
	if(!(node in nodes))
		CRASH("Attempted check a node that is not in the graph")

	var/list/neighbours = edges[node]
	if(length(nodes) == 1) // A graph with only a single node is not likely to have edges and then, and only then, we allow neighbours to be null
		return neighbours ? neighbours.Copy() : list()
	else
		return neighbours.Copy()

/datum/graph/get_log_info_line()
	return "[..()] (nodes: [log_info_line(nodes)]) (edges: [log_info_line(edges)])"

/atom/proc/CheckNodeNeighbours()
	SHOULD_NOT_SLEEP(TRUE)
	return FALSE
