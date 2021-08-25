#define WIRELESS_CONNECTION 1
#define WIRED_CONNECTION    2

/datum/computer_network
	var/network_id
	var/network_key

	var/list/devices = list()
	var/list/devices_by_tag = list()

	var/list/mainframes = list()
	var/list/mainframes_by_role = list()

	var/list/relays = list()

	var/datum/extension/network_device/broadcaster/router/router
	var/datum/extension/network_device/acl/access_controller

	var/network_features_enabled = NETWORK_ALL_FEATURES
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
		D.disconnect()
	QDEL_NULL_LIST(chat_channels)
	devices = null
	mainframes = null
	SSnetworking.networks -= network_id
	. = ..()

/datum/computer_network/proc/add_device(datum/extension/network_device/D)
	if(D.network_id != network_id)
		return FALSE
	if(D.key != network_key)
		return FALSE
	if(D in devices)
		return TRUE
	D.network_tag = get_unique_tag(D.network_tag)
	devices |= D
	devices_by_tag[D.network_tag] = D
	if(istype(D, /datum/extension/network_device/mainframe))
		var/datum/extension/network_device/mainframe/M = D
		mainframes |= M
		for(var/role in M.roles)
			LAZYDISTINCTADD(mainframes_by_role[role], M)
		add_log("Mainframe ONLINE with roles: [english_list(M.roles)]", D.network_tag)
	else if(istype(D, /datum/extension/network_device/broadcaster/relay))
		relays |= D
		add_log("Relay ONLINE", D.network_tag)
	else if(istype(D, /datum/extension/network_device/acl) && !access_controller)
		set_access_controller(D)
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
	devices |= D
	add_log("New main router set.", router.network_tag)

/datum/computer_network/proc/set_access_controller(datum/extension/network_device/D)
	access_controller = D
	devices |= D
	add_log("New main access controller set.", D.network_tag)

/datum/computer_network/proc/check_connection(datum/extension/network_device/D, specific_action)
	if(!router)
		return FALSE
	var/obj/machinery/M = router.holder
	if(istype(M) && !M.operable())
		return FALSE
	if(specific_action && !(network_features_enabled & specific_action))
		return FALSE
	var/list/broadcasters = relays + router
	for(var/datum/extension/network_device/broadcaster/R in broadcasters)
		var/wired_connection = R.get_wired_connection()
		if(!isnull(wired_connection) && wired_connection == D.get_wired_connection())
			return WIRED_CONNECTION
		else if(R.allow_wifi && (R.long_range || (get_z(R.holder) == get_z(D.holder))))
			. = WIRELESS_CONNECTION

/datum/computer_network/proc/get_signal_strength(datum/extension/network_device/D)
	var/connection_status = check_connection(D)
	if(!connection_status)
		return 0
	// There is a direct wired connection between a broadcaster on the network and the device.
	if(connection_status == WIRED_CONNECTION)
		return NETWORK_WIRED_CONNECTION_STRENGTH
	var/receiver_strength = D.connection_type
	var/list/broadcasters = relays + router
	var/best_signal = 0
	for(var/datum/extension/network_device/broadcaster/B in broadcasters)
		if(!B.allow_wifi || get_z(B.holder) != get_z(D.holder))	// Devices must be in the same z-level as the broadcaster to work.
			continue
		var/broadcast_strength = B.get_broadcast_strength()
		if(!ARE_Z_CONNECTED(get_z(router.holder), get_z(B.holder)))  // If the relay/secondary router is not in the same z-chunk as the main router, then the signal strength is halved.
			broadcast_strength = round(broadcast_strength/2)
		var/distance = get_dist(get_turf(B.holder), get_turf(D.holder))
		best_signal = max(best_signal, (broadcast_strength * receiver_strength) - distance)
	return best_signal

/datum/computer_network/proc/get_device_by_tag(nettag)
	return devices_by_tag[nettag]

/datum/computer_network/proc/change_id(new_id)
	if(new_id == network_id)
		return
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
			var/datum/extension/interactive/ntos/os = get_extension(D.holder, /datum/extension/interactive/ntos)
			if(!os)
				var/atom/A = D.holder
				os = get_extension(A.loc, /datum/extension/interactive/ntos)
			return os

/datum/computer_network/proc/get_router_z()
	if(router)
		return get_z(router.holder)

// TODO: Some way to set what network it should be, based on map vars or overmap vars
/proc/get_local_network_at(turf/T)
	for(var/id in SSnetworking.networks)
		var/datum/computer_network/net = SSnetworking.networks[id]
		if(net.router && ARE_Z_CONNECTED(get_z(net.router.holder), get_z(T)))
			return net

/datum/computer_network/proc/get_mainframes_by_role(mainframe_role = MF_ROLE_FILESERVER, mob/user)
	// if administrator, give full access.
	if(!user)
		return mainframes_by_role[mainframe_role]
	var/obj/item/card/id/network/id = user.GetIdCard()
	if(id && istype(id, /obj/item/card/id/network) && access_controller && (id.user_id in access_controller.administrators))
		return mainframes_by_role[mainframe_role]
	var/list/allowed_mainframes = list()
	for(var/datum/extension/network_device/D in mainframes_by_role[mainframe_role])
		if(D.has_access(user))
			allowed_mainframes |= D
	return allowed_mainframes

/datum/computer_network/proc/get_devices_by_type(var/type, var/mob/user)
	var/bypass_auth = !user
	if(!bypass_auth)
		// Check for admin.
		var/obj/item/card/id/network/id = user.GetIdCard()
		if(id && istype(id, /obj/item/card/id/network) && access_controller && (id.user_id in access_controller.administrators))
			bypass_auth = TRUE

	var/list/results = list()
	for(var/datum/extension/network_device/device in devices)
		if(istype(device.holder, type))
			if(bypass_auth || device.has_access(user))
				results += device.holder
	return results

/datum/computer_network/proc/get_tags_by_type(var/type)
	var/list/results = list()
	for(var/tag in devices_by_tag)
		var/datum/extension/network_device/device = devices_by_tag[tag]
		if(istype(device.holder, type))
			results |= tag
	return results