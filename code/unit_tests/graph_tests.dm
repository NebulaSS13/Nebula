/********
* Tests *
********/
/datum/unit_test/graph_test/simple_merge
	name = "Shall be able to merge simple graphs"

/datum/unit_test/graph_test/simple_merge/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")

	var/datum/graph/testing/graphA = new(list(nodeA), name = "Graph A")
	var/datum/graph/testing/graphB = new(list(nodeB), name = "Graph B")
	graphs += graphA
	graphs += graphB

	var/expected_nodes = list(nodeA, nodeB)
	var/expected_edges = list() // If one initialize using list(nodeA = list(nodeB)) it becomes list("nodeA" = list(nodeB)) which breaks things
	expected_edges[nodeA] = list(nodeB)
	expected_edges[nodeB] = list(nodeA)

	graphA.expecting_merge = TRUE
	graphA.on_check_expectations = new/datum/graph_expectation(expected_nodes, expected_edges)
	graphB.on_check_expectations = new/datum/graph_expectation/deleted()

	graphA.Connect(nodeB, nodeA)
	return TRUE


/datum/unit_test/graph_test/simple_split
	name = "Shall be able to split a simple graph"

/datum/unit_test/graph_test/simple_split/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB), edges)
	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeB)))

	graphs += graph

	graph.Disconnect(nodeB)
	return TRUE


/datum/unit_test/graph_test/deletion_split
	name = "Shall be able to handle node deletion"

/datum/unit_test/graph_test/deletion_split/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)
	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeC)))

	graphs += graph
	qdel(nodeB)
	return TRUE


/datum/unit_test/graph_test/self_connect
	name = "Shall be able to connect to self"

/datum/unit_test/graph_test/self_connect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)
	graphs += graph

	var/expected_edges = list()
	expected_edges[nodeA] = list(nodeB, nodeC)
	expected_edges[nodeB] = list(nodeA, nodeC)
	expected_edges[nodeC] = list(nodeB, nodeA)
	graph.on_check_expectations = new/datum/graph_expectation(list(nodeA, nodeB, nodeC), expected_edges)

	graph.Connect(nodeC, nodeA)

	return TRUE


/datum/unit_test/graph_test/partial_disconnect
	name = "Shall be able to handle a partial disconnect"

/datum/unit_test/graph_test/partial_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)

	var/expected_edges = list()
	expected_edges[nodeA] = list(nodeB)
	expected_edges[nodeB] = list(nodeA)

	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA, nodeB), expected_edges), new/datum/graph_expectation(list(nodeC)))
	graphs += graph

	graph.Disconnect(nodeB, nodeC)
	return TRUE


/datum/unit_test/graph_test/full_disconnect
	name = "Shall be able to handle a full disconnect"

/datum/unit_test/graph_test/full_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)

	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeB)), new/datum/graph_expectation(list(nodeC)))
	graphs += graph

	graph.Disconnect(nodeB)
	return TRUE


/datum/unit_test/graph_test/mutual_disconnect
	name = "Shall be able to handle a mutual disconnect"

/datum/unit_test/graph_test/mutual_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB), edges)

	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeB)))
	graphs += graph

	graph.Disconnect(nodeA)
	graph.Disconnect(nodeB)
	return TRUE


/datum/unit_test/graph_test/connected_graph_full_disconnect
	name = "Shall be able to handle a full disconnect in a connected graph"

/datum/unit_test/graph_test/connected_graph_full_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB, nodeC)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeA, nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)
	graphs += graph

	var/expected_edges = list()
	expected_edges[nodeA] = list(nodeC)
	expected_edges[nodeC] = list(nodeA)
	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA, nodeC), expected_edges), new/datum/graph_expectation(list(nodeB)))

	graph.Disconnect(nodeB)
	return TRUE


/datum/unit_test/graph_test/connected_graph_partial_disconnect
	name = "Shall be able to handle a partial disconnect in a connected graph"

/datum/unit_test/graph_test/connected_graph_partial_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB, nodeC)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeA, nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)
	graphs += graph

	var/expected_edges = list()
	expected_edges[nodeA] = list(nodeB, nodeC)
	expected_edges[nodeB] = list(nodeA)
	expected_edges[nodeC] = list(nodeA)
	graph.on_check_expectations = new/datum/graph_expectation(list(nodeA, nodeB, nodeC), expected_edges)

	graph.Disconnect(nodeB, nodeC)
	return TRUE

/datum/unit_test/graph_test/adjacent_disconnects
	name = "Shall be able to handle adjacent disconnects"

/datum/unit_test/graph_test/adjacent_disconnects/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")
	var/datum/node/test/nodeD = new("Node D")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB, nodeD)
	edges[nodeD] = list(nodeC)

	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC, nodeD), edges)
	graphs += graph

	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeD)))

	qdel(nodeB)
	qdel(nodeC)
	return TRUE

/datum/unit_test/graph_test/multiple_disconnects
	name = "Shall be able to handle multiple disconnects"

/datum/unit_test/graph_test/multiple_disconnects/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B") // Disconnects only from A
	var/datum/node/test/nodeC = new("Node C")
	var/datum/node/test/nodeD = new("Node D") // Disconnects from C and E
	var/datum/node/test/nodeE = new("Node E")
	var/datum/node/test/nodeF = new("Node F")
	var/datum/node/test/nodeG = new("Node G") // Deleted node
	var/datum/node/test/nodeH = new("Node H")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB, nodeD)
	edges[nodeD] = list(nodeC, nodeE)
	edges[nodeE] = list(nodeD, nodeF)
	edges[nodeF] = list(nodeE, nodeG)
	edges[nodeG] = list(nodeF, nodeH)
	edges[nodeH] = list(nodeG)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC, nodeD, nodeE, nodeF, nodeG, nodeH), edges)
	graphs += graph

	var/expected_graph_one = list(nodeA)

	var/expected_graph_two = list(nodeB, nodeC)
	var/expected_edges_two = list()
	expected_edges_two[nodeB] = list(nodeC)
	expected_edges_two[nodeC] = list(nodeB)

	var/expected_graph_three = list(nodeD)

	var/expected_graph_four = list(nodeE, nodeF)
	var/expected_edges_four = list()
	expected_edges_four[nodeE] = list(nodeF)
	expected_edges_four[nodeF] = list(nodeE)

	var/expected_graph_five = list(nodeH)

	graph.split_expectations = list(
		new/datum/graph_expectation(expected_graph_one),
		new/datum/graph_expectation(expected_graph_two, expected_edges_two),
		new/datum/graph_expectation(expected_graph_three),
		new/datum/graph_expectation(expected_graph_four, expected_edges_four),
		new/datum/graph_expectation(expected_graph_five),
		)

	graph.Disconnect(nodeB, nodeA)
	graph.Disconnect(nodeD)
	qdel(nodeG)
	return TRUE


/datum/unit_test/graph_test/connect_and_disconnect
	name = "Shall be able to handle a connect and disconnect"

/datum/unit_test/graph_test/connect_and_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")

	var/datum/graph/testing/graphA = new(list(nodeA), list())
	var/datum/graph/testing/graphB = new(list(nodeB), list())

	graphs += graphA
	graphs += graphB

	graphB.Connect(nodeA, nodeB)
	graphB.Disconnect(nodeA, nodeB)
	return TRUE


/datum/unit_test/graph_test/disconnect_and_connect
	name = "Shall be able to handle a disconnect and connect"

/datum/unit_test/graph_test/disconnect_and_connect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA)

	var/datum/graph/testing/graph = new(list(nodeA, nodeB), edges)
	graphs += graph

	graph.Disconnect(nodeA, nodeB)
	graph.Connect(nodeA, nodeB)
	return TRUE


/datum/unit_test/graph_test/move
	name = "Shall be able to handle movements"
	var/atom/movable/graph_test/hostA
	var/atom/movable/graph_test/hostB
	var/atom/movable/graph_test/hostC
	var/atom/movable/graph_test/hostD
	var/firstCheck = FALSE

/datum/unit_test/graph_test/move/start_test()
	var/turf/T = get_safe_turf()

	hostA = get_named_instance(/atom/movable/graph_test, T, "Host A");
	T = get_step(T, SOUTH)
	hostB = get_named_instance(/atom/movable/graph_test, T, "Host B");
	T = get_step(T, SOUTH)
	hostC = get_named_instance(/atom/movable/graph_test, T, "Host C");
	T = get_step(T, SOUTH)
	hostD = get_named_instance(/atom/movable/graph_test, T, "Host D");

	hostA.Connect(hostB)
	hostB.Connect(hostC)
	hostC.Connect(hostD)
	
	return TRUE

/datum/unit_test/graph_test/move/check_result()
	if(!ReadyToCheckExpectations())
		return FALSE

	if(!firstCheck)
		firstCheck = TRUE

		var/datum/graph/G = hostA.node.graph
		if(G != hostB.node.graph || G != hostC.node.graph || G != hostD.node.graph)
			fail("Nodes not connected as expected")
			log_bad(log_info_line(hostA.node.graph))
			log_bad(log_info_line(hostB.node.graph))
			log_bad(log_info_line(hostC.node.graph))
			log_bad(log_info_line(hostD.node.graph))
			return TRUE

		var/edge_issues = 0

		var/edgesA = UNLINT(G.edges[hostA.node])
		var/edgesB = UNLINT(G.edges[hostB.node])
		var/edgesC = UNLINT(G.edges[hostC.node])
		var/edgesD = UNLINT(G.edges[hostD.node])
		if(length(edgesA) != 1 || !(hostB.node in edgesA))
			edge_issues++
			log_bad("Invalid edges - Host A: [log_info_line(edgesA)]")
		if(length(edgesB) != 2 || !(hostA.node in edgesB) || !(hostC.node in edgesB))
			edge_issues++
			log_bad("Invalid edges - Host B: [log_info_line(edgesB)]")
		if(length(edgesC) != 2 || !(hostB.node in edgesC) || !(hostD.node in edgesC))
			edge_issues++
			log_bad("Invalid edges - Host C: [log_info_line(edgesC)]")
		if(length(edgesD) != 1 || !(hostC.node in edgesD))
			edge_issues++
			log_bad("Invalid edges - Host D: [log_info_line(edgesD)]")

		if(edge_issues)
			fail("Invalid edges")
			return TRUE

		hostB.forceMove(get_step(hostB, EAST))
		hostC.forceMove(get_step(hostC, EAST))
		return FALSE
	
	var/total_issues = 0

	var/list/hostANeighours = hostA.node.ConnectedNodes()
	if(length(hostANeighours))
		log_bad("Node A had unexpected neighours: [english_list(hostANeighours)]")
		total_issues++

	var/list/hostBNeighours = hostB.node.ConnectedNodes()
	if(length(hostBNeighours) != 1 || !(hostC.node in hostBNeighours))
		log_bad("Node B had unexpected neighours: [english_list(hostBNeighours)]")
		total_issues++
	
	var/list/hostCNeighours = hostC.node.ConnectedNodes()
	if(length(hostCNeighours) != 1 || !(hostB.node in hostCNeighours))
		log_bad("NodeC had unexpected neighours: [english_list(hostCNeighours)]")
		total_issues++

	var/list/hostDNeighours = hostD.node.ConnectedNodes()
	if(length(hostDNeighours))
		log_bad("Node D had unexpected neighours: [english_list(hostDNeighours)]")
		total_issues++

	if(total_issues)
		fail("Encountered [total_issues] issue\s")
	else
		pass("Encountered no issues")

	QDEL_NULL(hostA)
	QDEL_NULL(hostB)
	QDEL_NULL(hostC)
	QDEL_NULL(hostD)
	return TRUE

/******************
* Base Test Setup *
******************/
/datum/unit_test/graph_test
	template = /datum/unit_test/graph_test
	async = TRUE
	var/list/graphs

/datum/unit_test/graph_test/New()
	..()
	graphs = list()
	name = "GRAPH: " + name

/datum/unit_test/graph_test/proc/ReadyToCheckExpectations()
	return length(SSgraphs_update.pending_graphs) == 0 && length(SSgraphs_update.current_run) == 0

/datum/unit_test/graph_test/check_result()
	if(!ReadyToCheckExpectations())
		return FALSE

	var/total_issues = 0
	for(var/datum/graph/testing/GT in graphs)
		for(var/issue in GT.CheckExpectations())
			log_bad("[GT.name] - [issue]")
			total_issues++

	if(total_issues)
		fail("Encountered [total_issues] issue\s")
	else
		pass("Encountered no issues")

	return TRUE


/**********
* Helpers *
**********/
/datum/node/test
	var/name

/datum/node/test/New(var/name)
	..()
	src.name = name

/datum/node/physical/test
	var/name

/datum/node/physical/test/New(var/name, var/atom/holder)
	..(holder)
	src.name = name

/atom/movable/graph_test
	var/datum/node/physical/node
	var/list/neighoursByDirection = list()

/atom/movable/graph_test/Initialize()
	..()
	node = new/datum/node/physical/test/("Node", src)
	new/datum/graph(list(node), list())

/atom/movable/graph_test/Destroy()
	QDEL_NULL(node)
	return ..()

/atom/movable/graph_test/forceMove()
	. = ..()
	node?.Moved()

/atom/movable/graph_test/proc/Connect(atom/movable/graph_test/neighbour)
	var/direction = get_dir(src, neighbour)
	neighoursByDirection[num2text(direction)] = neighbour
	neighbour.neighoursByDirection[num2text(GLOB.flip_dir[direction])] = src
	node.Connect(neighbour.node)

/atom/movable/graph_test/CheckNodeNeighbours()
	// This is a lazy setup for ease of debugging
	// In a practical setup you'd preferably gather a list of neighbours to be disconnected and pass them in a single Disconnect-call
	// You'd possibly also verify the dir of this and neighbour nodes, to ensure that they're still facing each other properly
	for(var/direction in neighoursByDirection)
		var/atom/movable/graph_test/neighbour = neighoursByDirection[direction]
		var/turf/expected_loc = get_step(src, text2num(direction))
		if(neighbour.loc != expected_loc)
			node.Disconnect(neighbour.node)
			neighoursByDirection -= direction
	return TRUE

/datum/graph/testing
	var/name
	var/list/split_expectations
	var/expecting_merge
	var/datum/graph_expectation/on_check_expectations

	var/on_merge_was_called
	var/on_split_was_called
	var/issues

/datum/graph/testing/New(var/node, var/edges, var/name)
	..()
	src.name = name || "Graph"
	issues = list()

/datum/graph/testing/OnSplit(var/list/subgraphs)
	if(length(split_expectations) != subgraphs.len)
		issues += "Expected number of subgrapghs is [subgraphs.len], was [length(split_expectations)]"
	else if(length(split_expectations))
		var/list/unexpected_subgraphs = list()
		var/list/split_expectations_copy = split_expectations.Copy()
		for(var/subgraph in subgraphs)
			var/expectations_fulfilled = FALSE
			for(var/split_expectation in split_expectations_copy)
				var/datum/graph_expectation/GE = split_expectation
				if(!length(GE.CheckExpectations(subgraph)))
					split_expectations_copy -= GE
					expectations_fulfilled = TRUE
					break
			if(!expectations_fulfilled)
				unexpected_subgraphs += subgraph

		for(var/expected_graph in unexpected_subgraphs)
			issues += "Unexpected graph: [log_info_line(expected_graph)]"
		for(var/expected_split in split_expectations_copy)
			issues += "Unfulfilled split expectation: [log_info_line(expected_split)]"

	on_split_was_called = TRUE

/datum/graph/testing/OnMerge(datum/graph/other)
	on_merge_was_called = TRUE

/datum/graph/testing/proc/CheckExpectations()
	if(on_check_expectations)
		issues += on_check_expectations.CheckExpectations(src)
	if(length(split_expectations) && !on_split_was_called)
		issues += "Had split expectations but OnSplit was not called"
	if(!length(split_expectations) && on_split_was_called)
		issues += "Had no split expectations but OnSplit was called"
	if(expecting_merge != on_merge_was_called)
		issues += "Expected Merge: [expecting_merge ? "TRUE" : "FALSE"], but OnMerge was called: [on_merge_was_called ? "TRUE" : "FALSE"]"

	return issues

/datum/graph_expectation
	var/list/expected_nodes
	var/list/expected_edges

/datum/graph_expectation/New(var/expected_nodes, var/expected_edges)
	..()
	src.expected_nodes = expected_nodes || list()
	src.expected_edges = expected_edges || list()

/datum/graph_expectation/proc/CheckExpectations(var/datum/graph/graph)
	. = list()
	if(length(expected_nodes ^ (UNLINT(graph.nodes) || list())))
		. += "Expected the following nodes [log_info_line(expected_nodes)], was [log_info_line(UNLINT(graph.nodes))]"
	if(length(expected_edges ^ (UNLINT(graph.edges) || list())))
		. += "Expected the following edges [log_info_line(expected_edges)], was [log_info_line(UNLINT(graph.edges))]"

	for(var/datum/node/N in UNLINT(graph.nodes))
		if(N.graph != graph)
			. += "[log_info_line(N)]: Expected the following graph [log_info_line(graph)], was [N.graph]"

	for(var/node in expected_edges)
		var/expected_connections = expected_edges[node]
		var/actual_connections = UNLINT(graph.edges[node])
		if(length(expected_connections ^ actual_connections))
			. += "[log_info_line(node)]: Expected the following connections [log_info_line(expected_connections)], was [log_info_line(actual_connections)]"

/datum/graph_expectation/deleted/CheckExpectations(var/datum/graph/graph)
	. = ..()
	if(!QDELETED(graph))
		. += "Expected graph to be deleted, was not"

/datum/graph_expectation/get_log_info_line()
	return "Expected nodes: [log_info_line(expected_nodes)], expected edges: [log_info_line(expected_edges)]"
