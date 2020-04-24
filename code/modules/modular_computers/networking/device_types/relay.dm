/datum/extension/network_device/broadcaster/relay
	connection_type = NETWORK_CONNECTION_WIRED
	var/long_range  = 0 		// TRUE if relay can cross z-chunk boundaries.

/datum/extension/network_device/broadcaster/relay/get_nearby_networks()
	if(long_range)
		return GLOB.computer_networks
	var/list/networks = list()
	for(var/network_id in GLOB.computer_networks)
		var/datum/computer_network/network = GLOB.computer_networks[network_id]
		var/list/broadcasters = network.relays + network.router
		for(var/datum/extension/network_device/D in broadcasters)
			if(ARE_Z_CONNECTED(get_z(D.holder), get_z(holder)))
				networks |= network_id
				break
	return networks

/datum/extension/network_device/broadcaster/relay/connect()
	var/datum/computer_network/net = GLOB.computer_networks[network_id]
	if(!net)
		return FALSE
	if(!long_range && !(network_id in get_nearby_networks()))
		return FALSE
	return net.add_device(src)