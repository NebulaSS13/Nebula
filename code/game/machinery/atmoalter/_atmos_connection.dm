// Extension for allowing an atom to be connected to an atmospherics connector port.
/datum/extension/atmospherics_connection
	expected_type = /atom/movable
	base_type = /datum/extension/atmospherics_connection

	var/toggle_anchor // Whether to toggle anchor holder on connect/disconnect
	var/obj/machinery/atmospherics/portables_connector/connected_port

	var/datum/gas_mixture/merged_mixture

/datum/extension/atmospherics_connection/New(datum/holder, _toggle_anchor, _merged_mixture)
	. = ..()
	toggle_anchor = _toggle_anchor
	merged_mixture = _merged_mixture

/datum/extension/atmospherics_connection/Destroy()
	merged_mixture = null
	disconnect()
	. = ..()

/datum/extension/atmospherics_connection/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return FALSE

	var/atom/movable/movable_holder = holder

	//Make sure are close enough for a valid connection
	if(new_port.loc != movable_holder.loc)
		return FALSE

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = holder
	connected_port.on = 1 //Activate port updates

	if(toggle_anchor)
		movable_holder.anchored = TRUE //Prevent movement

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(holder)

	if(network && !network.gases.Find(merged_mixture))
		network.gases += merged_mixture
		network.update = 1

	return TRUE

/datum/extension/atmospherics_connection/proc/disconnect()
	if(!connected_port)
		return FALSE

	var/datum/pipe_network/network = connected_port.return_network(holder)
	if(network)
		network.gases -= merged_mixture

	var/atom/movable/movable_holder = holder

	if(toggle_anchor)
		movable_holder.anchored = FALSE

	connected_port.connected_device = null
	connected_port = null

	return TRUE

/datum/extension/atmospherics_connection/proc/update_connected_network()
	if(!connected_port)
		return

	var/datum/pipe_network/network = connected_port.return_network(holder)
	if(network)
		network.update = 1

/datum/extension/atmospherics_connection/proc/update_merged_mixture(datum/gas_mixture/new_mixture)
	if(merged_mixture == new_mixture)
		return TRUE

	if(!connected_port)
		return FALSE

	var/datum/pipe_network/network = connected_port.return_network(holder)

	if(!network)
		return FALSE

	network.gases.Remove(merged_mixture)
	if(!network.gases.Find(new_mixture))
		network.gases += new_mixture

	network.update = 1
	return TRUE