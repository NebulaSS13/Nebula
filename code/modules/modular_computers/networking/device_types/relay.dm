/datum/extension/network_device/broadcaster/relay
	expected_type = /obj/machinery

/datum/extension/network_device/broadcaster/relay/connect()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		return FALSE
	return net.add_device(src)

/datum/extension/network_device/broadcaster/relay/long_range
	long_range = TRUE
