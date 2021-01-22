/datum/node
	var/datum/graph/graph

/datum/node/Destroy()
	graph.Disconnect(src)
	return ..()

/datum/node/proc/Connect(var/list/nodes)
	var/datum/node/N = nodes
	if(istype(nodes))
		N = nodes[1]
	N.graph.Connect(src, nodes)

/datum/node/proc/Disconnect(nodes)
	graph.Disconnect(src, nodes)

/datum/node/proc/ConnectedNodes()
	return graph.ConnectedNodes(src)


/datum/node/physical
	var/atom/holder

/datum/node/physical/New(var/atom/holder)
	..()
	if(!istype(holder))
		CRASH("Invalid holder: [log_info_line(holder)]");
	src.holder = holder

/datum/node/physical/Destroy()
	holder = null
	. = ..()

/datum/node/physical/proc/Moved()
	graph.Moved(src)

