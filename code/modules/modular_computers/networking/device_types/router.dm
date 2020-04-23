
/datum/extension/network_device/router
	connection_type = NETWORK_CONNECTION_WIRED

/datum/extension/network_device/router/New(datum/holder, n_id, n_key, c_type)
	..()
	broadcast()

/datum/extension/network_device/router/proc/broadcast()
	var/datum/computer_network/net = GLOB.computer_networks[network_id]
	if(!net)
		net = new(network_id)
	if(!net.router)
		net.set_router(src)

/datum/extension/network_device/router/proc/is_router()
	var/datum/computer_network/net = GLOB.computer_networks[network_id]
	if(!net)
		return FALSE
	return (net.router == src)

/datum/extension/network_device/router/set_new_id(new_id, user)
	if(is_router())
		var/datum/computer_network/net = GLOB.computer_networks[network_id]
		net.change_id(new_id)
		to_chat(user, SPAN_NOTICE("Network '[network_id]' ID changed to '[new_id]'."))
		network_id = new_id
	else
		network_id = new_id
		broadcast()
		var/datum/computer_network/net = GLOB.computer_networks[network_id]
		if(net.router == src)
			to_chat(user, SPAN_NOTICE("Hosting the network '[network_id]'."))
		else
			to_chat(user, SPAN_NOTICE("Broadcasting on the network '[network_id]'."))

/datum/extension/network_device/router/set_new_key(new_key, user)
	if(is_router())
		var/datum/computer_network/net = GLOB.computer_networks[network_id]
		key = new_key
		net.network_key = new_key
		to_chat(user, SPAN_NOTICE("Network '[network_id]' key changed to '[new_key]'."))
	else
		..()

/datum/extension/network_device/router/proc/get_broadcast_strength()
	var/obj/item/stock_parts/computer/network_card/network_card = get_network_card()
	if(!network_card)
		return 0
	return NETWORK_BASE_BROADCAST_STRENGTH * (network_card.long_range ? 2 : 1)

/datum/extension/network_device/router/proc/get_network_card()
	var/obj/machinery/M = holder
	if(istype(M))
		return M.get_component_of_type(/obj/item/stock_parts/computer/network_card)