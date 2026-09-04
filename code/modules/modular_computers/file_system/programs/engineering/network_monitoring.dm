/datum/computer_file/program/network_monitor
	filename = "network_monitor"
	filedesc = "Network Diagnostics and Monitoring"
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "wrench"
	read_access = list(access_network)
	extended_desc = "This program monitors the local computer network, provides access to logging systems, and allows for configuration changes"
	size = 12
	nanomodule_path = /datum/nano_module/program/network_monitor/
	category = PROG_ADMIN

/datum/nano_module/program/network_monitor
	name = "Network Diagnostics and Monitoring"
	var/static/list/all_network_features = list(
		"Software Download" = NET_FEATURE_SOFTWAREDOWNLOAD,
		"Communication Systems" = NET_FEATURE_COMMUNICATION,
		"Remote System Control" = NET_FEATURE_SYSTEMCONTROL,
		"Access systems" = NET_FEATURE_ACCESS,
		"Personnel Administration" = NET_FEATURE_RECORDS,
		"Security systems" = NET_FEATURE_SECURITY,
		"Filesystem access" = NET_FEATURE_FILESYSTEM,
		"Deck control" = NET_FEATURE_DECK
		)

/datum/nano_module/program/network_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()

	data += "skill_fail"
	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		var/datum/extension/fake_data/fake_data = get_or_create_extension(src, /datum/extension/fake_data, 20)
		data["skill_fail"] = fake_data.update_and_return_data()
	data["terminal"] = !!program

	var/datum/computer_network/network = program?.computer?.get_network()
	data["status"] = !!network
	if(network)
		data["network"] = network.network_id
		data["devices"] = length(network.devices)
		data["router"] = network.router.network_tag

		var/list/features[0]
		for(var/feature in all_network_features)
			var/list/rdata[0]
			rdata["name"] = feature
			rdata["status"] = network.network_features_enabled & all_network_features[feature]
			rdata["flag"] = all_network_features[feature]
			features.Add(list(rdata))
		data["features"] = features

		var/list/mainframes[0]
		for(var/datum/extension/network_device/mainframe/M in network.mainframes)
			var/list/rdata[0]
			rdata["name"] = M.network_tag
			rdata["roles"] = length(M.roles) ? jointext(M.roles, "; ") : "NONE"
			rdata["ref"] = "\ref[M]"
			mainframes.Add(list(rdata))
		data["mainframes"] = mainframes

		var/list/eligible_log_servers = network.get_mainframes_by_role(MF_ROLE_LOG_SERVER, user.GetAccess())
		if(length(eligible_log_servers))
			var/list/logs[0]
			for(var/datum/extension/network_device/mainframe/M in eligible_log_servers)
				var/list/logdata[0]
				var/datum/computer_file/data/logfile/F = M.get_file("network_log", OS_LOGS_DIR, TRUE)
				if(F)
					logdata["server"] = M.network_tag
					logdata["log"] = F.generate_file_data()
					logdata["maxlogs"] = M.max_log_count
					logdata["ref"] = "\ref[M]"
					logs.Add(list(logdata))
			data["logs"] = logs

		data["ids_status"] = network.intrusion_detection_enabled ? "ENABLED" : "DISABLED"
		data["ids_alarm"] = network.intrusion_detection_alarm
		data["banned_nids"] = jointext(network.banned_nids, "<br>")
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "network_monitor.tmpl", "Network Diagnostics and Monitoring Tool", 575, 700, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/network_monitor/Topic(href, href_list, state)
	var/mob/user = usr
	if(..())
		return TOPIC_HANDLED

	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		return TOPIC_HANDLED

	var/datum/computer_network/network = program?.computer?.get_network()

	if(href_list["purgelogs"])
		var/datum/extension/network_device/mainframe/M = locate(href_list["purgelogs"])
		if(!istype(M))
			return TOPIC_HANDLED
		var/datum/computer_file/log_file = M.get_file("network_log", OS_LOGS_DIR)
		if(!log_file)
			return TOPIC_HANDLED
		M.delete_file(log_file)
		return TOPIC_REFRESH

	if(href_list["updatemaxlogs"])
		var/datum/extension/network_device/mainframe/M = locate(href_list["updatemaxlogs"])
		if(!istype(M))
			return TOPIC_HANDLED
		var/logcount = input(user,"Enter amount of logs to keep on the disk ([MIN_NETWORK_LOGS]-[MAX_NETWORK_LOGS]):", M.max_log_count) as null|num
		if(logcount && CanUseTopic(user, state))
			logcount = clamp(logcount, MIN_NETWORK_LOGS, MAX_NETWORK_LOGS)
			M.max_log_count = logcount
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["add_role"])
		var/datum/extension/network_device/mainframe/M = locate(href_list["add_role"])
		if(!istype(M))
			return TOPIC_HANDLED
		var/new_roles = global.all_mainframe_roles - M.roles
		if(!length(new_roles))
			to_chat(user, SPAN_WARNING("This server already has all possible roles enabled."))
			return TOPIC_HANDLED
		var/role = input(user,"What role to enable on this server?") as null|anything in new_roles
		if(role && CanUseTopic(user, state))
			M.toggle_role(role)
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["remove_role"])
		var/datum/extension/network_device/mainframe/M = locate(href_list["remove_role"])
		if(!istype(M))
			return TOPIC_HANDLED
		if(!length(M.roles))
			to_chat(user, SPAN_WARNING("This server has no enabled roles to remove."))
			return TOPIC_HANDLED
		var/role = input(user,"What role to disable on this server?") as null|anything in M.roles
		if(role && CanUseTopic(user, state))
			M.toggle_role(role)
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["toggle_function"])
		var/feature = text2num(href_list["toggle_function"])
		if(network.network_features_enabled & feature)
			network.disable_network_feature(feature)
		else
			network.enable_network_feature(feature)
		return TOPIC_REFRESH

	if(href_list["ban_nid"])
		var/nid = sanitize(input(user,"Enter NID of device which you want to block from the network:", "Enter NID") as null|text)
		if(nid && CanUseTopic(user, state))
			network.banned_nids |= nid
			return TOPIC_REFRESH

	if(href_list["unban_nid"])
		var/nid = sanitize(input(user,"Enter NID of device which you want to unblock from the network:", "Enter NID") as null|text)
		if(nid && CanUseTopic(user, state))
			network.banned_nids -= nid
			return TOPIC_REFRESH

	if(href_list["get_nid"])
		var/tag = sanitize(input(user,"Enter network tag of the device for address lookup:", "NID lookup") as null|text)
		if(tag && CanUseTopic(user, state))
			var/datum/extension/network_device/D = network.get_device_by_tag(tag)
			if(!D)
				to_chat(user, SPAN_WARNING("Device '[tag]' not found in the network."))
			else
				to_chat(user, SPAN_NOTICE("Address for device '[tag]' is '[D.address]'."))
			return TOPIC_REFRESH

	if(href_list["reset_ids"])
		network.intrusion_detection_alarm = FALSE
		network.add_log("Intrusion alarm reset")
		return TOPIC_REFRESH

	if(href_list["toggle_ids"])
		network.intrusion_detection_enabled = !network.intrusion_detection_enabled
		network.add_log("Intrusion detection [network.intrusion_detection_enabled ? "enabled" : "disabled"]")
		return TOPIC_REFRESH