/obj/machinery/atmospherics/binary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2

	pipe_class = PIPE_CLASS_BINARY
	connect_dir_type = SOUTH | NORTH

/obj/machinery/atmospherics/binary/Initialize()
	air1 = new
	air2 = new

	air1.volume = 200
	air2.volume = 200
	. = ..()

/obj/machinery/atmospherics/binary/air_in_dir(direction)
	if(direction == dir)
		return air2
	else if(direction == turn(dir, 180))
		return air1

/obj/machinery/atmospherics/binary/deconstruction_pressure_check()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > (2 ATM))
		return FALSE
	return TRUE

// Will only be used if you set the anchorable obj flag.
/obj/machinery/atmospherics/binary/wrench_floor_bolts(user)
	. = ..()
	if(anchored)
		set_dir(dir) // making sure
		atmos_init()
		for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
			node.atmos_init()
		build_network()
		for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
			node.build_network()
	else
		for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
			node.disconnect(src)
		for(var/node in nodes_to_networks)
			QDEL_NULL(nodes_to_networks[node])
		nodes_to_networks = null