/datum/computer_file/program/exonet_monitor
	filename = "exonet_monitor"
	filedesc = "EXONET Diagnostics and Monitoring"
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "wrench"
	extended_desc = "This program monitors the local EXONET network, provides access to logging systems, and allows for configuration changes"
	size = 12
	requires_exonet = 1
	nanomodule_path = /datum/nano_module/program/computer_exonetmonitor/
	category = PROG_ADMIN

/datum/nano_module/program/computer_exonetmonitor
	name = "EXONET Diagnostics and Monitoring"
	available_to_ai = TRUE

/datum/nano_module/program/computer_exonetmonitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data += "skill_fail"
	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		var/datum/extension/fake_data/fake_data = get_or_create_extension(src, /datum/extension/fake_data, 20)
		data["skill_fail"] = fake_data.update_and_return_data()
	data["terminal"] = !!program

	var/datum/exonet/network = get_network()
	data["exonet_status"] = !!network
	if(network)
		data["exonet_broadcasters"] = network.broadcasters

		data["config_softwaredownload"] = network.router.allow_file_download
		data["config_peertopeer"] = network.router.allow_peer_to_peer
		data["config_communication"] = network.router.allow_communication
		data["config_systemcontrol"] = network.router.allow_remote_control

		data["logging_server"] = network.log_server
		data["email_server"] = network.email_server
		data["report_server"] = network.report_server

		if(network.log_server)
			var/datum/computer_file/data/logfile/log = network.log_server.get_log_file()
			data["exonet_logs"] = log
			data["exonet_maxlogs"] = network.log_server.setting_max_log_count
		data["banned_nids"] = list(network.banned_nids)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "exonet_monitor.tmpl", "EXONET Diagnostics and Monitoring Tool", 575, 700, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/computer_exonetmonitor/Topic(href, href_list, state)
	var/mob/user = usr

	. = TOPIC_HANDLED
	if(..())
		return TOPIC_HANDLED

	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		return TOPIC_HANDLED

	var/datum/exonet/network = get_network()
	if(program.error)
		return TOPIC_HANDLED
	// if(href_list["toggleWireless"])
	// 	if(!ntnet_global)
	// 		return 1

	// 	// NTNet is disabled. Enabling can be done without user prompt
	// 	if(ntnet_global.setting_disabled)
	// 		ntnet_global.setting_disabled = 0
	// 		return 1

	// 	// NTNet is enabled and user is about to shut it down. Let's ask them if they really want to do it, as wirelessly connected computers won't connect without NTNet being enabled (which may prevent people from turning it back on)
	// 	if(!user)
	// 		return 1
	// 	var/response = alert(user, "Really disable NTNet wireless? If your computer is connected wirelessly you won't be able to turn it back on! This will affect all connected wireless devices.", "NTNet shutdown", "Yes", "No")
	// 	if(response == "Yes")
	// 		ntnet_global.setting_disabled = 1
	// 	return 1
	if(href_list["purgelogs"])
		network.log_server.delete_file_by_name("network_log")
	if(href_list["updatemaxlogs"])
		var/logcount = text2num(input(user,"Enter amount of logs to keep in memory ([MIN_NETWORK_LOGS]-[MAX_NETWORK_LOGS]):"))
		network.log_server.setting_max_log_count = logcount
	if(href_list["toggle_function"])
		switch(href_list["toggle_function"])
			if(NETWORK_SOFTWAREDOWNLOAD)
				network.router.allow_file_download = !network.router.allow_file_download
			if(NETWORK_PEERTOPEER)
				network.router.allow_peer_to_peer = !network.router.allow_peer_to_peer
			if(NETWORK_COMMUNICATION)
				network.router.allow_communication = !network.router.allow_communication
			if(NETWORK_SYSTEMCONTROL)
				network.router.allow_remote_control = !network.router.allow_remote_control
	if(href_list["ban_nid"])
		var/nid = input(user,"Enter NID of device which you want to block from the network:", "Enter NID") as null|num
		if(nid && CanUseTopic(user, state))
			network.banned_nids |= nid
	if(href_list["unban_nid"])
		var/nid = input(user,"Enter NID of device which you want to unblock from the network:", "Enter NID") as null|num
		if(nid && CanUseTopic(user, state))
			network.banned_nids -= nid