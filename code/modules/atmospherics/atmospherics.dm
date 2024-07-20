/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/
/obj/machinery/atmospherics
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = ENVIRON

	var/power_rating //the maximum amount of power the machine can use to do work, affects how powerful the machine is, in Watts

	layer = EXPOSED_PIPE_LAYER

	var/connect_types = CONNECT_TYPE_REGULAR
	var/connect_dir_type = SOUTH // Assume your dir is SOUTH. What dirs should you connect to?
	var/icon_connect_type = "" //"-supply" or "-scrubbers"

	var/initialize_directions = 0
	var/pipe_color

	var/list/nodes_to_networks // lazylist of node -> network to which the node connection belongs if any

	var/atmos_initalized = FALSE
	var/build_icon = 'icons/obj/pipe-item.dmi'
	var/build_icon_state = "buildpipe"

	var/pipe_class = PIPE_CLASS_OTHER //If somehow something isn't set properly, handle it as something with zero connections. This will prevent runtimes.
	var/rotate_class = PIPE_ROTATE_STANDARD

/obj/machinery/atmospherics/Initialize()
	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null

	set_dir(dir) // Does full dir init.
	. = ..()

/obj/machinery/atmospherics/Destroy()
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
		node.disconnect(src)
	nodes_to_networks = null
	. = ..()

/obj/machinery/atmospherics/proc/atmos_init()
	atmos_initalized = TRUE
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
	nodes_to_networks = null
	for(var/direction in global.cardinal)
		if(direction & initialize_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if((target.initialize_directions & get_dir(target,src)) && check_connect_types(target, src))
					LAZYDISTINCTADD(nodes_to_networks, target)
	update_icon()

/obj/machinery/atmospherics/proc/nodes_in_dir(var/direction)
	. = list()
	for(var/node in nodes_to_networks)
		if(get_dir(src, node) == direction)
			. += node

/obj/machinery/atmospherics/proc/network_in_dir(var/direction)
	if(!LAZYLEN(nodes_to_networks))
		return
	for(var/node in nodes_in_dir(direction))
		if(nodes_to_networks[node])
			return nodes_to_networks[node]

/obj/machinery/atmospherics/hide(var/do_hide)
	if(do_hide && level == LEVEL_BELOW_PLATING)
		layer = PIPE_LAYER
	else
		reset_plane_and_layer()

/obj/machinery/atmospherics/proc/add_underlay(var/turf/T, var/obj/machinery/atmospherics/node, var/direction, var/icon_connect_type, var/default_state = "exposed")
	var/state = default_state
	if(node)
		if(!T.is_plating() && node.level == LEVEL_BELOW_PLATING && istype(node, /obj/machinery/atmospherics/pipe))
			state = "down"
		else
			state = "intact"

	var/image/I = image('icons/atmos/pipe_underlays.dmi', "[state][icon_connect_type]", dir = direction)
	I.color = color_cache_name(node)
	underlays += I

// Code sharing for non-pipe devices
/obj/machinery/atmospherics/proc/build_device_underlays(hide_hidden_pipes = TRUE)
	underlays.Cut()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/disconnected_directions = initialize_directions
	var/visible_directions = 0
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		var/node_dir = get_dir(src, node)
		disconnected_directions &= ~node_dir
		if(hide_hidden_pipes && !T.is_plating() && node.level == LEVEL_BELOW_PLATING && istype(node, /obj/machinery/atmospherics/pipe))
			continue
		else
			add_underlay(T, node, node_dir, node.icon_connect_type)
			visible_directions |= node_dir
	for(var/direction in global.cardinal)
		if(disconnected_directions & direction)
			add_underlay(T, null, direction) // adds a disconnected underlay there
			visible_directions |= direction

	return visible_directions // returns flag with all directions in which a visible underlay was added

/obj/machinery/atmospherics/proc/check_connect_types(obj/machinery/atmospherics/atmos1, obj/machinery/atmospherics/atmos2)
	return (atmos1.connect_types & atmos2.connect_types)

/obj/machinery/atmospherics/proc/check_connect_types_construction(obj/machinery/atmospherics/atmos1, obj/item/pipe/pipe2)
	return (atmos1.connect_types & pipe2.connect_types)

/obj/machinery/atmospherics/proc/color_cache_name(var/obj/machinery/atmospherics/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color

/obj/machinery/atmospherics/Process()
	last_flow_rate = 0
	last_power_draw = 0

	build_network()

/obj/machinery/atmospherics/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	// Check to see if should be added to network. Add self if so and adjust variables appropriately.
	// Note don't forget to have neighbors look as well!

	// Default behavior is: one network for all nodes in a given dir
	for(var/obj/machinery/atmospherics/node as anything in nodes_in_dir(get_dir(src, reference)))
		if(nodes_to_networks[node] != new_network)
			qdel(nodes_to_networks[node])
			nodes_to_networks[node] = new_network
			if(node != reference)
				node.network_expand(new_network, src)

	new_network.normal_members |= src

// argument null -> update all
/obj/machinery/atmospherics/proc/update_networks(direction)
	for(var/node in nodes_to_networks)
		if(direction && !(get_dir(src, node) & direction))
			continue
		var/datum/pipe_network/net = nodes_to_networks[node]
		net.update = 1

/obj/machinery/atmospherics/proc/build_network()
	// Called to build a network from this node
	for(var/node in nodes_to_networks)
		if(!nodes_to_networks[node])
			var/datum/pipe_network/net = new
			nodes_to_networks[node] = net
			net.normal_members += src
			net.build_network(node, src)

/obj/machinery/atmospherics/proc/return_network(obj/machinery/atmospherics/reference)
	// Returns pipe_network associated with connection to reference
	// Notes: should create network if necessary
	// Should never return null
	build_network()
	return LAZYACCESS(nodes_to_networks, reference)

/obj/machinery/atmospherics/proc/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	// Used when two pipe_networks are combining
	for(var/node in nodes_to_networks)
		if(nodes_to_networks[node] == old_network)
			nodes_to_networks[node] = new_network

	// Return a list of gas_mixture(s) in the object
	//		associated with reference pipe_network for use in rebuilding the networks gases list
	// Is permitted to return null
/obj/machinery/atmospherics/proc/return_network_air(datum/pipe_network/reference)
	var/directions = 0
	for(var/node in nodes_to_networks)
		if(nodes_to_networks[node] == reference)
			directions |= get_dir(src, node)
	for(var/direction in global.cardinal)
		if(!(direction & directions))
			continue
		var/air = air_in_dir(direction)
		if(air)
			LAZYDISTINCTADD(., air)

// implement internally
/obj/machinery/atmospherics/proc/air_in_dir(direction)

/obj/machinery/atmospherics/proc/disconnect(obj/machinery/atmospherics/reference)
	if(reference in nodes_to_networks)
		qdel(nodes_to_networks[reference])
		LAZYREMOVE(nodes_to_networks, reference)
		update_icon()

/obj/machinery/atmospherics/on_update_icon()
	return null

// returns all pipe's endpoints. You can override, but you may then need to use a custom /item/pipe constructor.
/obj/machinery/atmospherics/proc/get_initialize_directions()
	return base_pipe_initialize_directions(dir, connect_dir_type)

/proc/base_pipe_initialize_directions(dir, connect_dir_type)
	if(!dir)
		return 0
	if(!(dir in global.cardinal))
		return dir // You're on your own. Used for bent pipes.
	. = 0

	if(connect_dir_type & SOUTH)
		. |= dir
	if(connect_dir_type & NORTH)
		. |= turn(dir, 180)
	if(connect_dir_type & WEST)
		. |= turn(dir, -90)
	if(connect_dir_type & EAST)
		. |= turn(dir, 90)

/obj/machinery/atmospherics/set_dir(new_dir)
	. = ..()
	initialize_directions = get_initialize_directions()

// Used by constructors. Shouldn't generally be called from elsewhere.
/obj/machinery/proc/set_initial_level()
	var/turf/T = get_turf(src)
	if(T)
		level = (T.is_plating() ? LEVEL_BELOW_PLATING : LEVEL_ABOVE_PLATING)

/obj/machinery/atmospherics/proc/deconstruction_pressure_check()
	return TRUE

/obj/machinery/atmospherics/cannot_transition_to(state_path, mob/user)
	if(state_path == /decl/machine_construction/default/deconstructed)
		var/unwrench_time = 4 SECONDS
		if(!deconstruction_pressure_check())
			unwrench_time *= 2
			var/obj/item/wrench/pipe/wrench = user.get_active_held_item()
			if(!istype(wrench))
				return SPAN_WARNING("You cannot unwrench \the [src], the internal pressure is too extreme compared to the environment.")

		to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
		if(!do_after(user, unwrench_time, src))
			return MCS_BLOCK
	return ..()

// called after being built by hand, before the pipe item or circuit is deleted
/obj/machinery/atmospherics/proc/build(obj/item/builder)
	atmos_init()
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		node.atmos_init()
	build_network()
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		node.build_network()