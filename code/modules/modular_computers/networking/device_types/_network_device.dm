/datum/extension/network_device
	base_type = /datum/extension/network_device
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/network_id		// ID of computer network it's (supposedly) connected to
	var/key				// passkey for the network
	var/address			// unique network address, cannot be set by user
	var/network_tag		// human-readable network address, can be set by user. Networks enforce uniqueness, will change it if there's clash.
	var/receiver_type = RECEIVER_STRONG_WIRELESS  // affects signal strength
	var/connection_attempts = 0
	var/internet_allowed = FALSE // Whether or not these devices can be connected over PLEXUS.

	var/long_range = FALSE // Whether or not this device can connect to broadcasters across z-chunks.

	var/has_commands = FALSE  // Whether or not this device can be configured to receive commands to modify and call public variables and methods.
	var/list/command_and_call // alias -> public method to be called.
	var/list/command_and_write // alias -> public variable to be written to or read from.

	var/last_rand_time 		   // Last time a random method was called.

	// These variables are for the *device's* public variables and methods, if they exist.
	var/list/device_variables
	var/list/device_methods

	/// Tracking var for autojoin, to resolve an ordering issue in device creation/connection.
	VAR_PRIVATE/_autojoin

/datum/extension/network_device/New(datum/holder, n_id, n_key, r_type, autojoin = TRUE)
	..()
	network_id = n_id
	key = n_key
	if(r_type)
		receiver_type = r_type
	address = uppertext(NETWORK_MAC)
	var/obj/O = holder
	network_tag = "[uppertext(replacetext(O.name, " ", "_"))]-[sequential_id(type)]"
	_autojoin = autojoin

	if(length(device_variables))
		for(var/path in device_variables)
			device_variables[path] = GET_DECL(path)
	if(length(device_methods))
		for(var/path in device_methods)
			device_methods[path] = GET_DECL(path)

	if(has_commands)
		reload_commands()

// Must be done here so that our holder's get_extension calls work.
/datum/extension/network_device/post_construction()
	. = ..()
	if(_autojoin)
		SSnetworking.try_connect(src)

/datum/extension/network_device/Destroy()
	disconnect()
	. = ..()

/datum/extension/network_device/proc/connect()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		return FALSE
	return net.add_device(src)

/datum/extension/network_device/proc/disconnect(net_down)
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if (net_down)
		SSnetworking.queue_reconnect(src, network_id)
	if(!net)
		return FALSE
	return net.remove_device(src)

// Returns list(signal type, signal strength) on success, null on failure.
/datum/extension/network_device/proc/check_connection(specific_action)
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		// We should already be queued for reconnect if it went down, so do nothing.
		return FALSE
	if(net.devices_by_tag[network_tag] != src)
		// The connection has failed but the network is still up, so we try to reconnect.
		if(!connect())
			return FALSE
	return net.check_connection(src, specific_action)

/datum/extension/network_device/proc/get_signal_wordlevel()
	var/list/signal_data = check_connection()
	if(!islist(signal_data))
		return "Not connected"
	if(signal_data[1] == INTERNET_CONNECTION)
		return "Connected over PLEXUS"
	var/signal_strength = signal_data[2]
	if(signal_strength <= 0)
		return "Not Connected"
	if(signal_strength < (NETWORK_BASE_BROADCAST_STRENGTH * 0.5))
		return "Low Signal"
	else
		return "High Signal"

// Returns list(network_id -> connection type, ...)
/datum/extension/network_device/proc/get_nearby_networks()
	var/list/wired_networks = list()
	var/list/wireless_networks = list()
	var/list/internet_networks = list()
	for(var/id in SSnetworking.networks)
		var/datum/computer_network/net = SSnetworking.networks[id]
		var/list/signal_data = net.check_connection(src)
		if(!islist(signal_data))
			continue
		switch(signal_data[1])
			if(WIRED_CONNECTION)
				wired_networks[id] = WIRED_CONNECTION
			if(WIRELESS_CONNECTION)
				wireless_networks[id] = WIRELESS_CONNECTION
			if(INTERNET_CONNECTION)
				internet_networks[id] = INTERNET_CONNECTION

	// We return it like this so that wired networks have their connections prioritized over wireless and internet connections.
	return wired_networks + wireless_networks + internet_networks

/datum/extension/network_device/proc/is_banned()
	var/datum/computer_network/net = get_network()
	if(!net)
		return FALSE
	return (address in net.banned_nids)

/datum/extension/network_device/proc/get_network(specific_action)
	if(check_connection(specific_action))
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
		if(!SSnetworking.networks[network_id]) // old network is down, so we should unqueue from its reconnect list
			SSnetworking.unqueue_reconnect(src, network_id)
		var/connection_type = networks[new_id]
		disconnect()
		network_id = new_id
		to_chat(user, SPAN_NOTICE("Network ID changed to '[network_id]'."))
		if(connect())
			if(connection_type == INTERNET_CONNECTION)
				to_chat(user, SPAN_NOTICE("Connected to the network '[network_id]' via PLEXUS connection. Certain actions on the network may be restricted."))
			else
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

/datum/extension/network_device/proc/get_wired_connection()
	var/obj/machinery/M = holder
	if(!istype(M))
		return
	var/obj/item/stock_parts/computer/lan_port/port = M.get_component_of_type(/obj/item/stock_parts/computer/lan_port)
	if(!port || !port.terminal)
		return
	var/obj/structure/network_cable/terminal/term = port.terminal
	return term.get_graph()

/datum/extension/network_device/proc/has_internet_connection(connecting_network)
	// Overmap isn't used, a modem alone provides internet connection.
	if(!length(global.using_map.overmap_ids))
		return TRUE
	var/obj/effect/overmap/visitable/sector = global.overmap_sectors[num2text(get_z(holder))]
	if(!istype(sector))
		return
	return sector.has_internet_connection(connecting_network)

/datum/extension/network_device/nano_host()
	return holder.nano_host()

/datum/extension/network_device/ui_data(mob/user, ui_key)
	var/list/data[0]
	data["network_id"] = network_id
	data["network_key"] = network_id ? "******" : "NOT SET"
	data["network_tag"] = network_tag
	data["status"] = get_signal_wordlevel()

	data["commands"] = has_commands
	if(has_commands)
		// For public methods.
		var/method_list = list()
		for(var/thing in command_and_call)
			var/decl/public_access/variable = command_and_call[thing]
			method_list += list(list("alias" = thing, "reference" = "\ref[variable]", "reference_name" = "[variable.name]"))
		data["methods"] = method_list
		// For public variables.
		var/var_list = list()
		for(var/thing in command_and_write)
			var/decl/public_access/variable = command_and_write[thing]
			var_list += list(list("alias" = thing, "reference" = "\ref[variable]", "reference_name" = "[variable.name]"))
		data["variables"] = var_list

	return data

/datum/extension/network_device/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		var/atom/A = holder
		ui = new(user, src, ui_key, "network_machine_settings.tmpl", capitalize(A.name), 500, 500)
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

/datum/extension/network_device/proc/has_access(list/accesses)
	var/datum/computer_network/network = get_network()
	if(!network)
		return TRUE // If not on network, always TRUE for access, as there isn't anything to access.
	var/obj/M = get_top_holder()
	if(!accesses)
		accesses  = list()
	return M.check_access_list(accesses)

// Return the target of the command passed to this device.
/datum/extension/network_device/proc/get_command_target(command)
	var/decl/public_access/public_thing
	if(command_and_call && command_and_call[command])
		public_thing = command_and_call[command]
	else if(command_and_write && command_and_write[command])
		public_thing = command_and_write[command]
	else
		return
	if(device_variables && (public_thing.type in device_variables))
		return src
	if(device_methods && (public_thing.type in device_methods))
		return src
	if((public_thing.type in get_holder_variables()) || (public_thing.type in get_holder_methods()))
		return holder

// Return the public methods and variables available for commands.
/datum/extension/network_device/proc/get_public_methods()
	var/list/public_methods = get_holder_methods()
	if(device_methods)
		public_methods += device_methods
	return public_methods

/datum/extension/network_device/proc/get_public_variables()
	var/list/public_variables = get_holder_variables()
	if(device_variables)
		public_variables += device_variables
	return public_variables

/datum/extension/network_device/proc/get_holder_methods()
	var/obj/machinery/M = get_top_holder()
	if(istype(M))
		return M.public_methods?.Copy()

/datum/extension/network_device/proc/get_holder_variables()
	var/obj/machinery/M = get_top_holder()
	if(istype(M))
		return M.public_variables?.Copy()

/datum/extension/network_device/proc/set_command_reference(list/selected_commands, alias, reference)
	if(!alias || !reference)
		return
	LAZYSET(selected_commands, alias, reference)

/datum/extension/network_device/proc/add_command(list/selected_commands, alias, list/valid_commands)
	if(!alias)
		alias = copytext(md5(num2text(rand(0, 25))), 1, 11)
	LAZYSET(selected_commands, alias, valid_commands[pick(valid_commands)])  // Random key and command
	return alias

/datum/extension/network_device/proc/change_command_alias(old_alias, new_alias)
	new_alias = sanitize(new_alias)
	new_alias = replacetext(new_alias, " ", "") // Strip spaces from the key.

	// Check if a command with the new alias already exists
	if(LAZYACCESS(command_and_call, new_alias) || LAZYACCESS(command_and_write, new_alias))
		return FALSE

	if(LAZYACCESS(command_and_call, old_alias))
		LAZYSET(command_and_call, new_alias, LAZYACCESS(command_and_call, old_alias))
		LAZYREMOVE(command_and_call, old_alias)
		return TRUE

	if(LAZYACCESS(command_and_write, old_alias))
		LAZYSET(command_and_write, new_alias, LAZYACCESS(command_and_write, old_alias))
		LAZYREMOVE(command_and_write, old_alias)
		return TRUE

/datum/extension/network_device/proc/remove_command(alias)
	if(LAZYACCESS(command_and_call, alias))
		LAZYREMOVE(command_and_call, alias)
		return TRUE
	if(LAZYACCESS(command_and_write, alias))
		LAZYREMOVE(command_and_write, alias)
		return TRUE
	return FALSE

// Any modification of public vars and calling methods from network commands. Return text feedback on success/unsuccess of command.
/datum/extension/network_device/proc/on_command(command, command_args, list/access)
	var/datum/command_target = get_command_target(command)
	if(!has_commands)
		return "Device cannot receive commands."
	if(!command_target)
		return "No valid target found for command '[command]'"
	if(!has_access(access))
		return "Access denied."
	if(LAZYACCESS(command_and_call, command))
		var/decl/public_access/public_method/method = command_and_call[command]
		var/output = method.perform(arglist(list(command_target) + command_args))
		return "Successfully called method '[command]' on [network_tag]." + "[output ? " Device reported: [output]" : null]"
	if(LAZYACCESS(command_and_write, command))
		var/decl/public_access/public_variable/variable = command_and_write[command]
		if(command_args) // Write to a var.
			command_args = sanitize_command_args(command_args, variable.var_type)
			if(isnull(command_args)) // Command could not be converted into a form appropriate for the variable.
				return "Improper argument type; correct type is [variable.var_type]"
			if(variable.write_var_protected(command_target, command_args))
				return "Successfully set variable '[command]' on [network_tag] to [command_args]."
			return "Unable to set variable '[command]' on [network_tag]."
		else			 // Read from a var.
			return "Variable '[command]' on [network_tag] has value: [variable.access_var(command_target)]"
	return "Command '[command]' not found on [network_tag]."

// Returns the variable converted into the proper form, or null if it is unable to.
/datum/extension/network_device/proc/sanitize_command_args(command_args, var_type)
	// First check if the command is a list; if it is, only accept it if the expected type is a list.
	if(islist(command_args))
		if(var_type == IC_FORMAT_LIST)
			return command_args
		else
			return null
	switch(var_type)
		if(IC_FORMAT_ANY)
			return command_args
		if(IC_FORMAT_STRING)
			return "[command_args]"
		if(IC_FORMAT_CHAR)
			if(istext(command_args) && length(command_args) == 1)
				return command_args
		if(IC_FORMAT_COLOR)
			return sanitize_hexcolor(command_args, null)
		if(IC_FORMAT_NUMBER, IC_FORMAT_INDEX)
			if(istext(command_args))
				return text2num(command_args)
			if(isnum(command_args))
				return command_args
		if(IC_FORMAT_DIR)
			if(istext(command_args))
				return text2dir(command_args)
		if(IC_FORMAT_BOOLEAN)
			if(istext(command_args))
				switch(uppertext(command_args))
					if("TRUE")
						return TRUE
					if("FALSE")
						return FALSE

// Calls a random method for skill failure etc.
/datum/extension/network_device/proc/random_method(list/access)
	if(world.time < last_rand_time + 5 SECONDS)
		return "Reinstancing command system, please try again in a few moments."
	if(access && !has_access(access))
		return "Access denied"
	var/rand_alias = SAFEPICK(command_and_call)
	var/decl/public_access/public_method/rand_method = LAZYACCESS(command_and_call, rand_alias)
	if(!istype(rand_method))
		return "No commands found."
	rand_method.perform(get_command_target())
	last_rand_time = world.time
	return "Encoding fault, incorrect command resolution likely"

// Reloads commands and automatically adds them to the proper lists.
/datum/extension/network_device/proc/reload_commands()
	LAZYCLEARLIST(command_and_call)
	LAZYCLEARLIST(command_and_write)

	var/list/pub_methods = get_public_methods()
	var/list/pub_vars = get_public_variables()

	for(var/path in pub_methods)
		var/decl/public_access/pub = pub_methods[path]
		var/alias = pub.name
		alias = replacetext(alias, " ", "_")
		LAZYSET(command_and_call, alias, pub)

	for(var/path in pub_vars)
		var/decl/public_access/pub = pub_vars[path]
		var/alias = pub.name
		alias = replacetext(alias, " ", "_")
		LAZYSET(command_and_write, alias, pub)

/**Returns the outward facing URI for this network device.*/
/datum/extension/network_device/proc/get_network_URI()
	return "[network_tag].[network_id]"

/**Returns the object that should be handling access and command checks.*/
/datum/extension/network_device/proc/get_top_holder()
	return holder

//Subtype for passive devices, doesn't init until asked for
/datum/extension/network_device/lazy
	base_type = /datum/extension/network_device
	flags = EXTENSION_FLAG_NONE