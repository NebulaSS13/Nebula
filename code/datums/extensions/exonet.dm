/datum/extension/exonet_device
	base_type = /datum/extension/exonet_device
	var/ennid 		= "" 	// Exonet network id. This is the name of the network we're connected to.
	var/netspeed	= 1		// How this device has connected to the network.

/datum/extension/exonet_device/New(datum/holder, var/_ennid, var/_netspeed)
	..()
	ennid = _ennid
	netspeed = _netspeed

// Convenience function for OnTopic usages when we need to prompt the user to change their network ennid. DRY impl.
/datum/extension/exonet_device/proc/do_change_ennid(var/mob/user)
	var/list/result = list()

	var/new_ennid = sanitize(input(user, "Enter exonet ennid or leave blank to cancel:", "Change ENNID"))
	if(!new_ennid)
		return
	var/new_key = sanitize(input(user, "Enter exonet keypass or leave blank if none:", "Change Key"))

	var/found = FALSE
	for(var/datum/exonet/network in get_nearby_networks(netspeed))
		if(network.ennid == new_ennid)
			// We found our network.
			result["ennid"] = new_ennid
			result["key"] = new_key
			found = TRUE
	if(!found)
		var/network_list = list()
		for(var/datum/exonet/network in get_nearby_networks(netspeed))
			network_list |= network.ennid
		if(!length(network_list))
			network_list |= "None"
		result["error"] = "Unable to find network with ennid '[new_ennid]'. Available networks: [jointext(network_list, ", ")]."
	return result

/datum/extension/exonet_device/proc/do_change_net_tag(var/mob/user)
	var/list/result = list()

	var/new_tag = sanitize(input(user, "Enter exonet network tag or leave blank to cancel:", "Change Network Tag"))
	if(!new_tag)
		return

	var/datum/exonet/network = get_local_network()
	if(!network)
		result["error"] = "Cannot change network tag while disconnected from network."
		return result
	for(var/network_device in network.network_devices)
		if(lowertext(get_network_tag(network_device)) == lowertext(new_tag))
			result["error"] = "Network tags must be unique."
			return result
	result["net_tag"] = new_tag
	return result

/datum/extension/exonet_device/proc/do_change_key(var/mob/user)

/datum/extension/exonet_device/proc/connect_network(var/mob/user, var/new_ennid, var/nic_netspeed, var/keydata)
	if(ennid == new_ennid)
		return "\The [holder] is already part of the '[ennid]' network."

	if(ennid)
		var/disconnect_result = disconnect_network(user)
		if(disconnect_result)
			return disconnect_result // There was a problem.


	var/datum/exonet/exonet = GLOB.exonets[new_ennid]
	if(!exonet)
		return "Error encountered when trying to register \the [holder] to the '[new_ennid]' network."
	else
		if(!exonet.router)
			return "Error encountered when trying to register \the [holder] to the '[new_ennid]' network."
		if(exonet.router.keydata != keydata)
			return "Invalid key. Unable to connect to network."
		exonet.add_device(holder, keydata)
		ennid = new_ennid
		netspeed = nic_netspeed
	return FALSE // This is a success.

/datum/extension/exonet_device/proc/disconnect_network(var/mob/user)
	if(!ennid)
		return

	var/datum/exonet/old_exonet = GLOB.exonets[ennid]
	if(old_exonet)
		old_exonet.remove_device(holder)
	return FALSE // This is a success.

/datum/extension/exonet_device/proc/broadcast_network(var/b_ennid, var/key)
	// Broadcasts an ENNID. If the network doesn't exist, it will create it.
	// If the network does exist, this will attempt to be added as a relay.
	var/datum/exonet/exonet = GLOB.exonets[b_ennid]
	if(!exonet)
		exonet = new(b_ennid)
		exonet.set_router(holder)
	else if(exonet.router.keydata != key)
		return // Security fail.	
	exonet.add_device(holder)
	ennid = b_ennid
	netspeed = NETWORKSPEED_ETHERNET

/datum/extension/exonet_device/proc/get_nearby_networks(var/nic_netspeed)
	var/list/results = list()
	for(var/ennid in GLOB.exonets)
		var/datum/exonet/exonet = GLOB.exonets[ennid]
		if(exonet.get_signal_strength(holder, nic_netspeed) > 0)
			results |= exonet
	return results

/datum/extension/exonet_device/proc/get_local_network()
	var/datum/exonet/network = GLOB.exonets[ennid]
	if(!network)
		return
	if(network.get_signal_strength(holder, netspeed) > 0)
		return network

/datum/extension/exonet_device/proc/get_all_networks()
	return GLOB.exonets

/datum/extension/exonet_device/proc/get_mainframes()
	var/datum/exonet/network = get_local_network()
	if(!network)
		return
	return network.mainframes

/datum/extension/exonet_device/proc/get_network_tag(var/obj/device)
	// Gets a friendly, unique name for a device on a local network.
	var/datum/exonet/network = get_local_network()
	if(!network)
		return
	if(istype(device, /obj/machinery/computer/exonet))
		var/obj/machinery/computer/exonet/exonet_machine = device
		if(exonet_machine.net_tag)
			return exonet_machine.net_tag
	var/index = network.network_devices.Find(device)
	return replacetext("[device.name].[index]", " ", "_")

/datum/extension/exonet_device/proc/get_device_by_tag(var/net_tag)
	if(!net_tag)
		return
	var/datum/exonet/network = get_local_network()
	if(!network)
		return
	for(var/obj/machinery/computer/exonet/exonet_machine in network.network_devices)
		if(!exonet_machine.net_tag)
			continue
		if(exonet_machine.net_tag == net_tag)
			return exonet_machine
	var/list/tokens = splittext(net_tag, ".")
	var/index = text2num(tokens[length(tokens)])
	return network.network_devices[index]

/datum/extension/exonet_device/Destroy()
	disconnect_network()
	..()