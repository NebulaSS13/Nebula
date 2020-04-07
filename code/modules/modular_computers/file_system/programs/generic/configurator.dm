// This is special hardware configuration program.
// It is to be used only with modular computers.
// It allows you to toggle components of your device.

/datum/computer_file/program/computerconfig
	filename = "compconfig"
	filedesc = "Computer Configuration Tool"
	extended_desc = "This program allows configuration of computer's hardware"
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "gear"
	unsendable = 1
	undeletable = 1
	size = 4
	requires_exonet = 0
	nanomodule_path = /datum/nano_module/program/computer_configurator/
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

/datum/computer_file/program/computerconfig/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["PRG_back"])
		error = null
	if(href_list["PRG_newennid"])
		. = TOPIC_HANDLED
		var/new_ennid = sanitize(input(usr, "Enter exonet ennid or leave blank to cancel:", "Change ENNID"))
		if(!new_ennid)
			return TOPIC_HANDLED
		var/new_key = sanitize(input(usr, "Enter exonet keypass or leave blank if none:", "Change Key"))

		var/obj/item/stock_parts/computer/network_card/network_card = computer.get_component(PART_NETWORK)
		var/datum/extension/exonet_device/exonet = get_extension(network_card, /datum/extension/exonet_device)
		var/found = FALSE
		for(var/datum/exonet/network in exonet.get_nearby_networks(network_card.get_netspeed()))
			if(network.ennid == new_ennid)
				// We found our network.
				error = network_card.set_ennid(new_ennid, new_key)
				found = TRUE
		if(!found)
			var/network_list = list()
			for(var/datum/exonet/network in exonet.get_nearby_networks(network_card.get_netspeed()))
				network_list |= network.ennid
			if(!length(network_list))
				network_list |= "None"
			error = "Unable to find network with ennid '[new_ennid]'. Available networks: [jointext(network_list, ", ")]."
	else if(href_list["PRG_newkey"])
		. = TOPIC_HANDLED
		var/new_key = sanitize(input(usr, "Enter exonet keypass or leave blank to cancel:", "Change key"))
		if(!new_key)
			return TOPIC_HANDLED
		var/obj/item/stock_parts/computer/network_card/network_card = computer.get_component(PART_NETWORK)
		error = network_card.set_keydata(new_key)
		return TOPIC_HANDLED
	if(.)
		SSnano.update_uis(NM)

/datum/nano_module/program/computer_configurator
	name = "NTOS Computer Configuration Tool"

/datum/nano_module/program/computer_configurator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()

	data = program.get_header_data()

	data["error"] = program.error
	data["disk_size"] = program.computer.max_disk_capacity()
	data["disk_used"] = program.computer.used_disk_capacity()
	data["power_usage"] = program.computer.get_power_usage()
	var/obj/item/stock_parts/computer/battery_module/battery_module = program.computer.get_component(PART_BATTERY)
	data["battery_exists"] = !!battery_module
	if(battery_module)
		data["battery_rating"] = battery_module.battery.maxcharge
		data["battery_percent"] = round(battery_module.battery.percent())

	var/obj/item/stock_parts/computer/network_card/network_card = program.computer.get_component(PART_NETWORK)
	data["nic_exists"] = !!network_card
	if(network_card)
		var/datum/extension/exonet_device/exonet = get_extension(network_card, /datum/extension/exonet_device)
		var/datum/exonet/network = exonet.get_local_network()
		if(!network)
			data["signal_strength"] = "Not Connected"
		else
			var/signal_strength = network.get_signal_strength(network_card, network_card.get_netspeed())
			if(signal_strength <= 0)
				data["signal_strength"] = "Not Connected"
			else if(signal_strength <= 6)
				data["signal_strength"] = "Low Signal"
			else
				data["signal_strength"] = "High Signal"
		if(network_card.ennid)
			data["ennid"] = network_card.ennid
		else
			data["ennid"] = "Not Set"
		if(network_card.keydata)
			data["key"] = network_card.keydata
		else
			data["key"] = "Not Set"

	var/list/all_entries[0]
	var/list/hardware = program.computer.get_all_components()
	for(var/obj/item/stock_parts/computer/H in hardware)
		all_entries.Add(list(list(
		"name" = H.name,
		"desc" = H.desc,
		"enabled" = H.enabled,
		"critical" = H.critical,
		"powerusage" = H.power_usage,
		"ref" = "\ref[H]"
		)))

	data["hardware"] = all_entries

	data["receives_updates"] = program.computer.receives_updates

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "laptop_configuration.tmpl", "NTOS Configuration Utility", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()