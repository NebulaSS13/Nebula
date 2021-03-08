/datum/extension/network_device
	base_type = /datum/extension/network_device
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/network_id		// ID of computer network it's (supposedly) connected to
	var/key				// passkey for the network
	var/address			// unique network address, cannot be set by user
	var/network_tag		// human-readable network address, can be set by user. Networks enforce uniqueness, will change it if there's clash.
	var/connection_type = NETWORK_CONNECTION_STRONG_WIRELESS  // affects signal strength

	var/has_commands = FALSE  // Whether or not this device can be configured to receive commands to modify and call public variables and methods. 
	var/list/command_and_call // alias -> public method to be called.
	var/list/command_and_write // alias -> public variable to be written to or read from.

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
	
	if(has_commands)
		LAZYINITLIST(command_and_call)
		LAZYINITLIST(command_and_write)
	
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
	else if(href_list["change_methods"])
		command_list_topic(command_and_call, get_public_methods(), user, href_list)
		return TOPIC_REFRESH
	else if(href_list["change_variables"])
		command_list_topic(command_and_write, get_public_variables(), user, href_list)
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

/datum/extension/network_device/proc/command_list_topic(list/selected_commands, list/valid_commands, mob/user, href_list)
	if(href_list["remove_command"])
		var/thing = href_list["remove_command"]
		LAZYREMOVE(selected_commands, thing)
		return TOPIC_REFRESH

	if(href_list["change_command_alias"])
		var/thing = href_list["change_command_alias"]
		if(selected_commands && selected_commands[thing])
			var/new_key = input(user, "Select a new alias for this command:", "Alias Select", thing) as null|text
			if(!new_key || !can_interact(user))
				return TOPIC_REFRESH
			if(!selected_commands || !selected_commands[thing])
				return TOPIC_REFRESH
			selected_commands[new_key] = selected_commands[thing]
			selected_commands -= thing
		return TOPIC_REFRESH

	if(href_list["change_reference"])
		var/thing = href_list["change_reference"]
		var/decl/public_access/variable = selected_commands && selected_commands[thing]
		if(!variable || !LAZYLEN(valid_commands))
			return TOPIC_REFRESH
		var/list/valid_variables = list()
		for(var/path in valid_commands)
			valid_variables |= valid_commands[path]
		var/new_var = input(user, "Select a new reference for this alias:", "Reference Select", thing) as null|anything in valid_variables
		if(!new_var || !can_interact(user))
			return TOPIC_REFRESH
		if(!(selected_commands && selected_commands[thing] == variable))
			return TOPIC_REFRESH
		set_command_reference(selected_commands, thing, new_var)
		return TOPIC_REFRESH
	
	if(href_list["add_command"])
		if(!LAZYLEN(valid_commands))
			return TOPIC_REFRESH
		add_command(selected_commands, null, valid_commands)
		return TOPIC_REFRESH

	if(href_list["command_desc"])
		var/decl/public_access/variable = locate(href_list["command_desc"])
		if(istype(variable))
			to_chat(user, variable.desc)
		return TOPIC_NOACTION

// Return the target of any commands passed to this device.
/datum/extension/network_device/proc/get_command_target()
	if(istype(holder, /obj/machinery))
		return holder

// Return the public methods and variables available for commands.
/datum/extension/network_device/proc/get_public_methods()
	var/obj/machinery/M = get_command_target()
	if(istype(M))
		return M.public_methods

/datum/extension/network_device/proc/get_public_variables()
	var/obj/machinery/M = get_command_target()
	if(istype(M))
		return M.public_variables

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
/datum/extension/network_device/proc/on_command(command, command_args, mob/user)
	var/datum/command_target = get_command_target()
	if(!has_commands)
		return "Device cannot receive commands."
	if(!command_target)
		return "No valid target found for command '[command]'"
	if(!has_access(user))
		return "Access denied."
	if(command_and_call[command])
		var/decl/public_access/public_method/method = command_and_call[command]
		method.perform(command_target, command_args)
		return "Successfully called method '[command]' on [network_tag]."
	if(command_and_write[command])
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
		if(IC_FORMAT_NUMBER)
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

/datum/extension/network_device/proc/sanitize_commands()
	var/obj/machinery/M = get_command_target()
	if(!has_commands || !istype(M))
		LAZYCLEARLIST(command_and_call)
		LAZYCLEARLIST(command_and_write)
		return
	for(var/thing in command_and_call)
		var/decl/public_access/pub = command_and_call[thing]
		if(!istype(pub) || !(pub.type in M.public_methods))
			command_and_call -= thing
	for(var/thing in command_and_write)
		var/decl/public_access/pub = command_and_write[thing]
		if(!istype(pub) || !(pub.type in M.public_variables))
			command_and_write -= thing

//Subtype for passive devices, doesn't init until asked for
/datum/extension/network_device/lazy
	base_type = /datum/extension/network_device
	flags = EXTENSION_FLAG_NONE