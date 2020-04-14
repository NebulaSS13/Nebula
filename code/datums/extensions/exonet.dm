/datum/extension/exonet_device
	base_type = /datum/extension/exonet_device
	flags = EXTENSION_FLAG_IMMEDIATE
	var/ennid 		= "" 	// Exonet network id. This is the name of the network we're connected to.
	var/key			= null	// Exonet netowrk keycode. This is the password to join the network.
	var/net_tag		= null	// A user-set unique name for an exonet device.
	var/nid			= null	// A unique system-generated GUID that serves as a mac-address. Cannot be changed.
	var/netspeed	= 1		// How this device has connected to the network.

/datum/extension/exonet_device/New(datum/holder, var/_netspeed)
	..()
	netspeed = _netspeed
	nid = new_guid()

// Convenience function for OnTopic usages when we need to prompt the user to change their network ennid. DRY impl.
/datum/extension/exonet_device/proc/do_change_ennid(var/mob/user)
	var/list/result = list()

	var/new_ennid = sanitize(input(user, "Enter exonet ennid:", "Change ENNID"))
	if(!new_ennid)
		result["ennid"] = null
		return result
	var/new_key = sanitize(input(user, "Enter exonet keypass:", "Change Key"))

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
		if(lowertext(get_net_tag(network_device)) == lowertext(new_tag))
			result["error"] = "Network tags must be unique."
			return result
	result["net_tag"] = new_tag
	return result

/datum/extension/exonet_device/proc/do_change_key(var/mob/user)
	var/list/result = list()
	var/new_key = sanitize(input(user, "Enter exonet keypass:", "Change Key"))
	result["key"] = new_key
	return result

/datum/extension/exonet_device/proc/connect_network(var/mob/user)
	if(ennid)
		var/datum/exonet/existing_network = get_local_network()
		if(existing_network && existing_network.ennid == ennid)
			return "\The [holder] is already part of the '[ennid]' network."

		var/disconnect_result = disconnect_network(user)
		if(disconnect_result)
			return disconnect_result // There was a problem.

	var/datum/exonet/exonet = GLOB.exonets[ennid]
	if(!exonet)
		return "Error encountered when trying to register \the [holder] to the '[ennid]' network."
	else
		if(!exonet.router)
			return "Error encountered when trying to register \the [holder] to the '[ennid]' network."
		if(exonet.lock != key)
			return "Invalid key. Unable to connect to network."
		exonet.add_device(holder, key)
	return FALSE // This is a success.

/datum/extension/exonet_device/proc/disconnect_network(var/mob/user)
	net_tag = null

	if(!ennid || !(ennid in GLOB.exonets))
		return

	var/datum/exonet/old_exonet = GLOB.exonets[ennid]
	if(old_exonet)
		old_exonet.remove_device(holder)
	return FALSE // This is a success.

/datum/extension/exonet_device/proc/broadcast_network()
	// Broadcasts an ENNID. If the network doesn't exist, it will create it.
	// If the network does exist, this will attempt to be added as a relay.
	var/datum/exonet/exonet = GLOB.exonets[ennid]
	if(!exonet)
		exonet = new(ennid)
		exonet.set_router(holder, key)
	else if(exonet.lock != key)
		return // Security fail.
	exonet.add_device(holder)
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
	if(network.get_signal_strength(holder, netspeed) > 0 && holder in network.network_devices)
		return network

/datum/extension/exonet_device/proc/get_signal_wordlevel()
	var/datum/exonet/network = GLOB.exonets[ennid]
	if(!network)
		return "Not Connected"
	var/signal_strength = network.get_signal_strength(holder, netspeed)
	if(signal_strength <= 0)
		return "Not Connected"
	else if(signal_strength <= 6)
		return "Low Signal"
	else
		return "High Signal"

/datum/extension/exonet_device/proc/get_all_networks()
	return GLOB.exonets

/datum/extension/exonet_device/proc/get_mainframes()
	var/datum/exonet/network = get_local_network()
	if(!network)
		return
	return network.mainframes

/datum/extension/exonet_device/proc/get_net_tag(var/obj/device)
	// Gets a friendly, unique name for a device on a local network.
	var/datum/extension/exonet_device/exonet = get_extension(device, /datum/extension/exonet_device)
	if(exonet.net_tag)
		return "[exonet.net_tag] (NID#[exonet.nid])"
	return "[device.name] (NID#[exonet.nid])"

/datum/extension/exonet_device/proc/get_device_by_tag(var/net_tag)
	if(!net_tag)
		return
	var/datum/exonet/network = get_local_network()
	if(!network)
		return
	for(var/datum/device in network.network_devices)
		var/datum/extension/exonet_device/exonet = get_extension(device, /datum/extension/exonet_device)
		if(exonet.get_net_tag() == net_tag)
			return device

/datum/extension/exonet_device/proc/set_ennid(var/new_ennid)
	if(ennid)
		disconnect_network()
	ennid = new_ennid

/datum/extension/exonet_device/proc/set_key(var/new_key)
	if(ennid)
		disconnect_network()
	key = new_key

/datum/extension/exonet_device/proc/set_net_tag(var/new_tag)
	net_tag = new_tag

// Gets all email accounts available on this network, and all networks with PLEXUS connections.
/datum/extension/exonet_device/proc/get_email_accounts(var/require_online = TRUE)
	var/list/email_accounts = list()
	// Generate for this network.
	var/datum/exonet/local_network = get_local_network()
	if(!local_network)
		return email_accounts
	var/is_online = local_network.is_connected_plexus()
	for(var/ennid in GLOB.exonets)
		var/datum/exonet/network = GLOB.exonets[ennid]
		if(local_network.ennid == ennid || (!require_online || (is_online && network.is_connected_plexus()))) // Online check.
			email_accounts |= network.get_email_accounts()
	return email_accounts

/datum/extension/exonet_device/proc/find_email_by_name(var/login)
	for(var/ennid in GLOB.exonets)
		var/datum/exonet/network = GLOB.exonets[ennid]
		var/email = network.find_email_by_name(login)
		if(email)
			return email

/datum/extension/exonet_device/Destroy()
	disconnect_network()
	..()