/obj/structure/network_cable
	name = "network cable"
	desc = "A cable used to connect computers and other devices into a local network."
	icon = 'icons/obj/structures/network_cable.dmi'
	icon_state = "dot"
	layer = WIRE_LAYER
	anchored = TRUE
	level = LEVEL_BELOW_PLATING
	var/datum/node/physical/network_node

/obj/structure/network_cable/Initialize(ml, _mat, _reinf_mat)
	..()
	var/turf/T = get_turf(src)
	hide(hides_under_flooring() && !T?.is_plating())
	network_node = new(src)
	network_node.graph = new(list(network_node))
	return INITIALIZE_HINT_LATELOAD

/obj/structure/network_cable/LateInitialize()
	. = ..()
	update_network()

/obj/structure/network_cable/Destroy()
	QDEL_NULL(network_node)
	for(var/dir in global.cardinal)
		var/turf/T = get_step(get_turf(src), dir)
		for(var/obj/structure/network_cable/cable in T)
			cable.update_icon()
	var/turf/T = get_turf(src)
	if(T?.is_open())
		for(var/obj/structure/network_cable/cable in GetBelow(src))
			cable.update_icon()
	var/turf/U = GetAbove(src)
	if(U?.is_open())
		for(var/obj/structure/network_cable/cable in U)
			cable.update_icon()
	. = ..()

/obj/structure/network_cable/handle_default_wirecutter_attackby(var/mob/user)
	var/turf/T = get_turf(src)
	if(T && do_after(user, 15) && !QDELETED(src))
		to_chat(user, SPAN_NOTICE("You cut \the [src]."))
		new/obj/item/stack/net_cable_coil(T, 1)
		qdel(src)

/obj/structure/network_cable/proc/update_network()
	var/list/graphs = list() // Associative list of graphs->list of nodes to add as neighbors.
	for(var/dir in global.cardinal)
		var/turf/T = get_step(get_turf(src), dir)
		for(var/obj/structure/network_cable/cable in T)
			var/datum/graph/G = cable.network_node.graph
			if(G)
				LAZYADD(graphs[G], cable.network_node)
			cable.update_icon()
	var/turf/T = get_turf(src)
	if(T?.is_open())
		for(var/obj/structure/network_cable/cable in GetBelow(src))
			var/datum/graph/G = cable.network_node.graph
			if(G)
				LAZYADD(graphs[G], cable.network_node)
			cable.update_icon()
	var/turf/U = GetAbove(src)
	if(U?.is_open())
		for(var/obj/structure/network_cable/cable in U)
			var/datum/graph/G = cable.network_node.graph
			if(G)
				LAZYADD(graphs[G], cable.network_node)
			cable.update_icon()

	for(var/datum/graph/G in graphs)
		G.Connect(network_node, graphs[G])
	update_icon()

/obj/structure/network_cable/CheckNodeNeighbours()
	// Check if connected nodes are no longer adjacent to the current node and disconnect from them.
	var/list/neighbours = network_node.ConnectedNodes()
	var/list/adj_nodes = list()
	var/list/ex_neighbours
	var/list/new_neighbours

	for(var/dir in global.cardinal)
		var/turf/T = get_step(get_turf(src), dir)
		for(var/obj/structure/network_cable/cable in T)
			adj_nodes |= cable.network_node
	var/turf/T = get_turf(src)
	if(T?.is_open())
		for(var/obj/structure/network_cable/cable in GetBelow(src))
			adj_nodes |= cable.network_node
	var/turf/U = GetAbove(src)
	if(U?.is_open())
		for(var/obj/structure/network_cable/cable in U)
			adj_nodes |= cable.network_node

	ex_neighbours = neighbours - adj_nodes
	new_neighbours = adj_nodes - neighbours
	if(length(ex_neighbours)) // Check length to ensure we don't accidentally completely disconnect the node from a graph.
		network_node.Disconnect()
	if(length(new_neighbours))
		network_node.Connect(new_neighbours[1]) // Pick a random new neighbour to connect to and get a new graph.
		for(var/datum/node/neighbour in new_neighbours.Copy(2))
			neighbour.Connect(network_node)		// Connect the other neighbours to the network node with its (new) graph.

	return TRUE

/obj/structure/network_cable/Move()
	. = ..()
	network_node.Moved()
	queue_icon_update()

/obj/structure/network_cable/forceMove()
	. = ..()
	if(network_node)
		network_node.Moved()
	queue_icon_update()

/obj/structure/network_cable/proc/get_graph()
	return network_node?.graph

/obj/structure/network_cable/on_update_icon()
	..()
	for(var/dir in global.cardinal)
		var/turf/T = get_step(get_turf(src), dir)
		for(var/obj/structure/network_cable/cable in T)
			if(!QDELETED(cable))
				add_overlay("cable[dir]")
	var/turf/T = get_turf(src)
	if(T?.is_open())
		var/turf/A = GetBelow(src)
		var/obj/structure/network_cable/cable = locate() in A
		if(cable)
			add_overlay("cable-down")
	var/turf/U = GetAbove(src)
	if(U?.is_open())
		var/obj/structure/network_cable/cable = locate() in U
		if(cable)
			add_overlay("cable-up")

/obj/structure/network_cable/terminal
	name = "network cable terminal"
	desc = "A network terminal directly connected to a network device."
	icon_state = "terminal"
	layer = WIRE_LAYER

/obj/structure/network_cable/terminal/handle_default_wirecutter_attackby(var/mob/user)
	var/turf/T = get_turf(src)
	if(T && do_after(user, 30) && !QDELETED(src))
		to_chat(user, SPAN_NOTICE("You pry off \the [src]."))
		new/obj/item/stack/net_cable_coil(T, 5)
		qdel(src)

/obj/item/stack/net_cable_coil
	name = "network cable coil"
	desc = "A coil of network cable, used to connect network devices over local networks."
	icon = 'icons/obj/items/net_cable_coil.dmi'
	icon_state = ICON_STATE_WORLD
	randpixel = 2
	amount = 20
	max_amount = 20
	singular_name = "length"
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 2
	throw_range = 5
	material = /decl/material/solid/glass
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT
	)
	matter_multiplier = 0.15
	item_state = "coil"

/obj/item/stack/net_cable_coil/single
	amount = 1

/obj/item/stack/net_cable_coil/afterattack(var/atom/A, var/mob/user, var/proximity, var/params)
	. = ..()
	if(!proximity)
		return
	if(isturf(A))
		var/turf/T = A
		if(!T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the plating first!"))
			return
		for(var/obj/structure/network_cable/C in A)
			to_chat(user, SPAN_WARNING("There's already a cable at that position!"))
			return
		if(do_after(user, 5, A) && use(1))
			new /obj/structure/network_cable(A)

/obj/item/stack/net_cable_coil/on_update_icon()
	. = ..()
	if(amount == 1)
		icon_state = "coil1"
		SetName("network cable piece")
	else if(amount == 2)
		icon_state = "coil2"
		SetName("network cable piece")
	else if(amount > 2 && amount != max_amount)
		icon_state = "coil"
		SetName(initial(name))
	else
		icon_state = "coil-max"
		SetName(initial(name))