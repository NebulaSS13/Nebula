#define INTERNET_CONNECTION 1
#define WIRELESS_CONNECTION 2
#define WIRED_CONNECTION    3

/datum/computer_network
	var/network_id
	var/network_key

	var/list/devices = list()
	var/list/devices_by_tag = list()

	var/list/mainframes = list()
	var/list/mainframes_by_role = list()

	// Telecomms device caches
	var/list/connected_radios
	var/list/connected_hubs

	var/list/relays = list()

	var/list/cameras_by_channel = list()

	var/datum/extension/network_device/broadcaster/router/router
	var/datum/extension/network_device/modem/modem
	var/datum/extension/network_device/acl/access_controller

	var/network_features_enabled = NET_ALL_FEATURES
	var/intrusion_detection_enabled
	var/intrusion_detection_alarm
	var/list/banned_nids = list()
	var/static/list/all_software_categories
	var/list/chat_channels = list()

/datum/computer_network/New(var/new_id)
	if(!new_id)
		new_id = "network[random_id(type, 100,999)]"
	network_id = new_id
	SSnetworking.networks[network_id] = src

/datum/computer_network/Destroy()
	for(var/datum/extension/network_device/D in devices)
		D.disconnect(TRUE)
	QDEL_NULL_LIST(chat_channels)
	connected_radios = null
	connected_hubs = null
	devices = null
	mainframes = null
	SSnetworking.networks -= network_id
	. = ..()

/datum/computer_network/proc/add_device(datum/extension/network_device/D)
	if(QDELETED(D))
		return FALSE
	if(D.network_id != network_id)
		return FALSE
	if(D.key != network_key)
		return FALSE
	if(D in devices)
		return TRUE

	if(!check_connection(D))
		return FALSE

	var/newtag = get_unique_tag(D.network_tag)

	if(istype(D, /datum/extension/network_device/mainframe))
		var/datum/extension/network_device/mainframe/M = D
		mainframes |= M
		for(var/role in M.roles)
			LAZYDISTINCTADD(mainframes_by_role[role], M)
		add_log("Mainframe ONLINE with roles: [english_list(M.roles)]", newtag)
	else if(istype(D, /datum/extension/network_device/broadcaster/relay))
		relays |= D
		add_log("Relay ONLINE", newtag)
	else if(istype(D, /datum/extension/network_device/acl))
		if(access_controller)
			return FALSE
		access_controller = D
		add_log("New main access controller set", newtag)
	else if(istype(D, /datum/extension/network_device/modem))
		if(modem)
			return FALSE
		modem = D
		add_log("New modem connecting to PLEXUS set", newtag)
	else if(istype(D, /datum/extension/network_device/camera))
		var/datum/extension/network_device/camera/C = D
		add_camera_to_channels(C, C.channels)

	D.network_tag = newtag
	devices |= D
	devices_by_tag[D.network_tag] = D
	return TRUE

/datum/computer_network/proc/remove_device(datum/extension/network_device/D)
	devices -= D
	devices_by_tag -= D.network_tag
	if(D in mainframes)
		var/datum/extension/network_device/mainframe/M = D
		mainframes -= M
		for(var/role in mainframes_by_role)
			LAZYREMOVE(mainframes_by_role[role], M)
		add_log("Mainframe OFFLINE with roles: [english_list(M.roles)]", M.network_tag)
	else if(D in relays)
		relays -= D
		add_log("Relay OFFLINE", D.network_tag)
	else if(istype(D, /datum/extension/network_device/camera))
		var/datum/extension/network_device/camera/C = D
		remove_camera_from_channels(C, C.channels)

	if(D == router)
		router = null
		for(var/datum/extension/network_device/broadcaster/router/R in devices)
			router = R
			add_log("Router offline, falling back to router '[R.network_tag]'", R.network_tag)
			break
		if(!router)
			add_log("Router offline, network shutting down", D.network_tag)
			qdel(src)
	if(D == access_controller)
		access_controller = null
		add_log("Access controller offline. Network security offline.", D.network_tag)
	return TRUE

/datum/computer_network/proc/get_unique_tag(nettag)
	while(get_device_by_tag(nettag))
		nettag += "-[sequential_id(nettag)]"
	return nettag

/datum/computer_network/proc/update_device_tag(datum/extension/network_device/D, old_tag, new_tag)
	devices_by_tag -= old_tag
	devices_by_tag[new_tag] = D

/datum/computer_network/proc/set_router(datum/extension/network_device/D)
	router = D
	network_key = router.key
	change_id(router.network_id)
	add_device(D)
	add_log("New main router set.", router.network_tag)

// Returns list(signal type, signal strength) on success, null on failure.
/datum/computer_network/proc/check_connection(datum/extension/network_device/D, specific_action)
	if(!router)
		return
	var/obj/machinery/M = router.holder
	if(istype(M) && !M.operable())
		return
	if(specific_action && !(network_features_enabled & specific_action))
		return
	var/list/broadcasters = relays + router
	var/datum/graph/device_graph = D.get_wired_connection()
	var/receiver_strength = D.receiver_type

	var/best_signal = 0
	var/functional_broadcaster = FALSE
	for(var/datum/extension/network_device/broadcaster/B in broadcasters)
		if(device_graph)
			var/wired_connection = B.get_wired_connection()
			if(!isnull(wired_connection) && wired_connection == device_graph)
				return list(WIRED_CONNECTION, NETWORK_WIRED_CONNECTION_STRENGTH)

		if(!B.allow_wifi)
			continue
		var/broadcast_strength = B.get_broadcast_strength()
		if(!broadcast_strength)
			continue

		// For long ranged devices, checking to make sure there's at least a functional broadcaster somewhere.
		functional_broadcaster = TRUE

		var/d_z = get_z(D.holder)
		var/b_z = get_z(B.holder)

		if(!LEVELS_ARE_Z_CONNECTED(d_z, b_z))
			continue

		if(d_z != b_z)  // If the broadcaster is not in the same z-level as the device, the broadcast strength is halved.
			broadcast_strength = round(broadcast_strength/2)
		var/distance = get_dist(get_turf(B.holder), get_turf(D.holder))
		best_signal = max(best_signal, (broadcast_strength * receiver_strength) - distance)

	if(best_signal)
		return list(WIRELESS_CONNECTION, best_signal)

	// Long ranged devices can connect across z-chunk boundaries. If they're not in the same z-chunk as a broadcaster,
	// they simply use internet speed.
	if(D.long_range && functional_broadcaster)
		return list(WIRELESS_CONNECTION, NETWORK_INTERNET_CONNECTION_STRENGTH)

	if(!modem || !D.internet_allowed)
		return
	if(specific_action && !(modem.allowed_features & specific_action))
		return
	// If the overmap is disabled, a modem alone allows global PLEXUS connection.
	if(modem.has_internet_connection(network_id) && D.has_internet_connection(network_id))
		return list(INTERNET_CONNECTION, NETWORK_INTERNET_CONNECTION_STRENGTH)

/datum/computer_network/proc/get_device_by_tag(nettag)
	return devices_by_tag[nettag]

/datum/computer_network/proc/change_id(new_id)
	if(new_id == network_id)
		return
	// Move our old reconnect queue to the new id.
	if(LAZYLEN(SSnetworking.reconnect_queues[network_id]))
		SSnetworking.reconnect_queues[new_id] = SSnetworking.reconnect_queues[network_id]
		SSnetworking.reconnect_queues[network_id] = null
	// Update connected devices.
	for(var/datum/extension/network_device/D in devices)
		if(D.network_id != new_id)
			D.network_id = new_id
	SSnetworking.networks -= network_id
	add_log("Network ID was changed from '[network_id]' to '[new_id]'")
	network_id = new_id
	SSnetworking.networks[network_id] = src

/datum/computer_network/proc/enable_network_feature(feature)
	network_features_enabled |= feature

/datum/computer_network/proc/disable_network_feature(feature)
	network_features_enabled &= ~feature

// Returns a computer network if an internet connection with the enabled feature is available.
// If the computer network is the same, then only the local feature is checked.
/datum/computer_network/proc/get_internet_connection(target_id, feature)
	var/datum/computer_network/target_network = SSnetworking.networks[target_id]
	if(!target_network)
		return

	if(target_network == src)
		if(network_features_enabled & feature)
			return target_network
		return

	if(check_internet_feature(feature) && target_network.check_internet_feature(feature))
		return target_network

/datum/computer_network/proc/check_internet_feature(feature)
	if(!modem || !modem.has_internet_connection(network_id))
		return FALSE
	return modem.allowed_features & feature

/datum/computer_network/proc/update_mainframe_roles(datum/extension/network_device/mainframe/M)
	if(!(M in mainframes))
		return FALSE

	for(var/role in mainframes_by_role)
		LAZYREMOVE(mainframes_by_role[role], M)
	for(var/role in M.roles)
		LAZYDISTINCTADD(mainframes_by_role[role], M)

	add_log("Mainframe roles updated, now: [english_list(M.roles)]", M.network_tag)

/datum/computer_network/proc/get_os_by_nid(nid)
	for(var/datum/extension/network_device/D in devices)
		if(D.address == uppertext(nid))
			var/datum/extension/interactive/os/os = get_extension(D.holder, /datum/extension/interactive/os)
			if(!os)
				var/atom/A = D.holder
				os = get_extension(A.loc, /datum/extension/interactive/os)
			return os

/datum/computer_network/proc/get_router_z()
	if(router)
		return get_z(router.holder)

// TODO: Some way to set what network it should be, based on map vars or overmap vars
/proc/get_local_network_at(turf/T)
	for(var/id in SSnetworking.networks)
		var/datum/computer_network/net = SSnetworking.networks[id]
		if(net.router && LEVELS_ARE_Z_CONNECTED(get_z(net.router.holder), get_z(T)))
			return net

/datum/computer_network/proc/get_mainframes_by_role(mainframe_role = MF_ROLE_FILESERVER, list/accesses)
	// Don't check for access if none is passed, for internal usage.
	if(!accesses)
		return mainframes_by_role[mainframe_role]
	var/list/allowed_mainframes = list()
	for(var/datum/extension/network_device/D in mainframes_by_role[mainframe_role])
		if(D.has_access(accesses))
			allowed_mainframes |= D
	return allowed_mainframes

/datum/computer_network/proc/get_devices_by_type(type, list/accesses)
	var/list/results = list()
	var/bypass_auth = !accesses
	for(var/datum/extension/network_device/device in devices)
		if(istype(device.holder, type))
			if(bypass_auth || device.has_access(accesses))
				results += device.holder
	return results

/datum/computer_network/proc/get_tags_by_type(var/type)
	var/list/results = list()
	for(var/tag in devices_by_tag)
		var/datum/extension/network_device/device = devices_by_tag[tag]
		if(istype(device.holder, type))
			results |= tag
	return results

/datum/computer_network/proc/add_camera_to_channels(var/datum/extension/network_device/camera/added, var/list/channels)
	if(!islist(channels))
		channels = list(channels)
	for(var/channel in channels)
		if(!cameras_by_channel[channel])
			cameras_by_channel[channel] = list()
		cameras_by_channel[channel] |= added

/datum/computer_network/proc/remove_camera_from_channels(var/datum/extension/network_device/camera/removed, var/list/channels)
	if(!islist(channels))
		channels = list(channels)
	for(var/channel in channels)
		if(cameras_by_channel[channel])
			cameras_by_channel[channel] -= removed
			if(!length(cameras_by_channel[channel]))
				cameras_by_channel -= channel
