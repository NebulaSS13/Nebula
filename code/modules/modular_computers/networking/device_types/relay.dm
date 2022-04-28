/datum/extension/network_device/broadcaster/relay
	connection_type = NETWORK_CONNECTION_STRONG_WIRELESS
	expected_type = /obj/machinery
	var/reconnect_time

/datum/extension/network_device/broadcaster/relay/get_nearby_networks()
	if(long_range)
		return SSnetworking.networks
	var/list/networks = list()
	for(var/network_id in SSnetworking.networks)
		var/datum/computer_network/network = SSnetworking.networks[network_id]
		var/list/broadcasters = network.relays + network.router
		for(var/datum/extension/network_device/D in broadcasters)
			if(ARE_Z_CONNECTED(get_z(D.holder), get_z(holder)))
				networks |= network_id
				break
	return networks

/datum/extension/network_device/broadcaster/relay/connect()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		return FALSE
	if(!long_range && !(network_id in get_nearby_networks()))
		return FALSE
	. = net.add_device(src)
	if(.)	
		reconnect_time = null

/datum/extension/network_device/broadcaster/relay/disconnect(net_down)
	. = ..()
	// Router went down, we should try to hook back up when it's up
	if(net_down)
		reconnect_time = world.time + 30 SECONDS
		START_PROCESSING(SSprocessing, src)

/datum/extension/network_device/broadcaster/relay/Process()
	if(world.time > reconnect_time)
		if(connect())
			return PROCESS_KILL
		reconnect_time = world.time + 30 SECONDS
	
/datum/extension/network_device/broadcaster/relay/long_range
	long_range = TRUE
