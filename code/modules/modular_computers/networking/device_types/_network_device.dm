/datum/extension/network_device
	base_type = /datum/extension/network_device
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/network_id		// ID of computer network it's (supposedly) connected to
	var/key				// passkey for the network
	var/address			// unique network address, cannot be set by user
	var/network_tag		// human-readable network address, can be set by user. Networks enforce uniqueness, will change it if there's clash.
	var/connection_type = NETWORK_CONNECTION_STRONG_WIRELESS  // affects signal strength

/datum/extension/network_device/New(datum/holder, n_id, n_key, c_type, autojoin = TRUE)
	..()
	network_id = n_id
	key = n_key
	if(c_type)
		connection_type = c_type
	address = uppertext(NETWORK_MAC)
	var/obj/O = holder
	network_tag = "[uppertext(replacetext(O.name, " ", "_"))]-[sequential_id(type)]"
	if(autojoin)
		SSnetworking.queue_connection(src)
	
/datum/extension/network_device/Destroy()
	disconnect()
	. = ..()

/datum/extension/network_device/proc/connect()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		return FALSE
	return net.add_device(src)

/datum/extension/network_device/proc/disconnect()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		return FALSE
	return net.remove_device(src)

/datum/extension/network_device/proc/check_connection(specific_action)
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		return FALSE
	if(!net.check_connection(src, specific_action) || !net.add_device(src))
		return FALSE
	return net.get_signal_strength(src)
	
/datum/extension/network_device/proc/get_signal_wordlevel()
	var/datum/computer_network/network = get_network()
	if(!network)
		return "Not Connected"
	var/signal_strength = network.get_signal_strength(src)
	if(signal_strength <= 0)
		return "Not Connected"
	if(signal_strength < (NETWORK_BASE_BROADCAST_STRENGTH * 0.5))
		return "Low Signal"
	else
		return "High Signal"

/datum/extension/network_device/proc/get_nearby_networks()
	var/list/networks = list()
	for(var/id in SSnetworking.networks)
		var/datum/computer_network/net = SSnetworking.networks[id]
		if(net.check_connection(src))
			networks |= id
	return networks

/datum/extension/network_device/proc/is_banned()
	var/datum/computer_network/net = get_network()
	if(!net)
		return FALSE
	return (address in net.banned_nids)

/datum/extension/network_device/proc/get_network()
	if(check_connection())
		return SSnetworking.networks[network_id]

/datum/extension/network_device/proc/add_log(text)
	var/datum/computer_network/net = get_network()
	if(!net)
		return FALSE
	return net.add_log(text, network_tag)

/datum/extension/network_device/proc/connect_to_any()
	var/list/nets = get_nearby_networks()
	for(var/net in nets)
		network_id = net
		if(connect())
			return TRUE

/datum/extension/network_device/proc/can_interact(user)
	return holder.CanUseTopic(user) == STATUS_INTERACTIVE

/datum/extension/network_device/proc/do_change_id(var/mob/user)
	var/new_id = sanitize(input(user, "Enter network ID:", "Network ID", network_id) as text|null)
	if(!new_id || !can_interact(user))
		return
	set_new_id(new_id, user)

/datum/extension/network_device/proc/set_new_id(new_id, user)
	var/list/networks = get_nearby_networks()
	if(new_id in networks)
		disconnect()
		network_id = new_id
		to_chat(user, SPAN_NOTICE("Network ID changed to '[network_id]'."))
		if(connect())
			to_chat(user, SPAN_NOTICE("Connected to the network '[network_id]'."))
		else
			to_chat(user, SPAN_WARNING("Unable to connect to the network '[network_id]'. Check your passkey and try again."))
	else
		to_chat(user, SPAN_WARNING("Unable to find network with ID '[new_id]'. Available networks: [english_list(networks)]."))

/datum/extension/network_device/proc/do_change_key(var/mob/user)
	var/new_key = sanitize(input(user, "Enter network keypass:", "Network Key"))
	if(!can_interact(user))
		return
	set_new_key(new_key, user)

/datum/extension/network_device/proc/set_new_key(new_key, user)
	disconnect()
	key = new_key
	to_chat(user, SPAN_NOTICE("Network key changed to '[key]'."))
	if(connect())
		to_chat(user, SPAN_NOTICE("Connected to the network '[network_id]'."))
	else
		to_chat(user, SPAN_WARNING("Unable to connect to the network '[network_id]' with the key '[key]'"))

/datum/extension/network_device/proc/do_change_net_tag(var/mob/user)
	var/new_tag = sanitize(input(user, "Enter exonet network tag or leave blank to cancel:", "Change Network Tag", network_tag) as text|null)
	if(!new_tag)
		return
	new_tag = uppertext(replacetext(new_tag, " ", "_"))
	var/datum/computer_network/net = get_network()
	if(!net)
		to_chat(user, SPAN_WARNING("Cannot change network tag while disconnected from network."))
		return
	if(net.get_device_by_tag(new_tag))
		to_chat(user, SPAN_WARNING("Network tags must be unique."))
		return
	set_network_tag(new_tag)
	to_chat(user, SPAN_NOTICE("Net tag changed to '[network_tag]'."))

/datum/extension/network_device/proc/set_network_tag(new_tag)
	var/datum/computer_network/network = get_network()
	if(network)
		new_tag = network.get_unique_tag(new_tag)
		network.update_device_tag(src, network_tag, new_tag)
	network_tag = new_tag

/datum/extension/network_device/nano_host()
	return holder.nano_host()

/datum/extension/network_device/ui_data(mob/user, ui_key)
	var/list/data[0]
	data["network_id"] = network_id
	data["network_key"] = network_id ? "******" : "NOT SET"
	data["network_tag"] = network_tag
	data["status"] = get_signal_wordlevel()
	return data

/datum/extension/network_device/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		var/atom/A = holder
		ui = new(user, src, ui_key, "network_machine_settings.tmpl", capitalize(A.name), 380, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/extension/network_device/Topic(href, href_list)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!can_interact(user))
		return
	if(href_list["change_id"])
		do_change_id(user)
		return TOPIC_REFRESH
	else if(href_list["change_key"])
		do_change_key(user)
		return TOPIC_REFRESH
	else if(href_list["change_net_tag"])
		do_change_net_tag(user)
		return TOPIC_REFRESH

/datum/extension/network_device/proc/has_access(mob/user)
	var/datum/computer_network/network = get_network()
	if(!network)
		return TRUE // If not on network, always TRUE for access, as there isn't anything to access.
	if(!user)
		return FALSE
	var/obj/item/card/id/network/id = user.GetIdCard()
	if(id && istype(id, /obj/item/card/id/network) && network.access_controller && (id.user_id in network.access_controller.administrators))
		return TRUE
	var/obj/M = holder
	return M.allowed(user)

//Subtype for passive devices, doesn't init until asked for
/datum/extension/network_device/lazy
	base_type = /datum/extension/network_device
	flags = EXTENSION_FLAG_NONE