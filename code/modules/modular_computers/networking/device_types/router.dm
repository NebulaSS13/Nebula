
/datum/extension/network_device/broadcaster/router/New(datum/holder, n_id, n_key, c_type)
	..()
	broadcast()

/datum/extension/network_device/broadcaster/router/proc/broadcast()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		net = new(network_id)
	if(!net.router)
		net.set_router(src)
		SSnetworking.process_reconnections(network_id)

/datum/extension/network_device/broadcaster/router/proc/is_router()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		return FALSE
	return (net.router == src)

/datum/extension/network_device/broadcaster/router/set_new_id(new_id, user)
	if(is_router())
		var/datum/computer_network/net = SSnetworking.networks[network_id]
		net.change_id(new_id)
		to_chat(user, SPAN_NOTICE("Network '[network_id]' ID changed to '[new_id]'."))
		network_id = new_id
	else
		network_id = new_id
		broadcast()
		var/datum/computer_network/net = SSnetworking.networks[network_id]
		if(net.router == src)
			to_chat(user, SPAN_NOTICE("Hosting the network '[network_id]'."))
		else
			to_chat(user, SPAN_NOTICE("Broadcasting on the network '[network_id]'."))

/datum/extension/network_device/broadcaster/router/set_new_key(new_key, user)
	if(is_router())
		var/datum/computer_network/net = SSnetworking.networks[network_id]
		key = new_key
		net.network_key = new_key
		to_chat(user, SPAN_NOTICE("Network '[network_id]' key changed to '[new_key]'."))
	else
		..()