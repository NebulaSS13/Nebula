/datum/computer_file/program/turret_control
	filename = "sentrycntrl"
	filedesc = "Sentry Turret Control"
	extended_desc = "A program used to control sentry turrets on the network."
	size = 4
	usage_flags = PROGRAM_CONSOLE
	program_icon_state = "security"
	program_menu_icon = "locked"
	requires_network = 1
	requires_network_feature = NET_FEATURE_SECURITY
	available_on_network = 1
	nanomodule_path = /datum/nano_module/program/turret_control
	category = PROG_SEC

/datum/nano_module/program/turret_control
	name = "Sentry Turret Control"

/datum/nano_module/program/turret_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	var/list/area_turrets = list() // Dictionary of area name -> turret
	var/datum/computer_network/network = get_network()
	if(network)
		var/list/turrets = network.get_devices_by_type(/obj/machinery/turret/network, get_access(user))
		for(var/obj/machinery/turret/network/net_turret in turrets)
			var/area/A = get_area(net_turret)
			var/area_name = A.name

			var/datum/extension/network_device/turret_device = get_extension(net_turret, /datum/extension/network_device)

			if(!(area_name in area_turrets))
				area_turrets[area_name] = list()

			area_turrets[area_name] += list(list("tag" = turret_device.network_tag, "enabled" = net_turret.enabled))

	data["area_turrets"] = list()
	for(var/area_name in area_turrets)
		data["area_turrets"] += list(list("area_name" = area_name, "turrets" = area_turrets[area_name]))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_program.tmpl", name, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/computer_file/program/turret_control/Topic(href, href_list, state)
	if(..())
		return TOPIC_HANDLED

	var/mob/user = usr
	var/datum/nano_module/program/turret_control/module = NM
	var/datum/computer_network/network = module.get_network()
	if(!network)
		return TOPIC_REFRESH
	if(href_list["turret"])
		var/datum/extension/network_device/turret_device = network.get_device_by_tag(href_list["turret"])
		if(!turret_device || !turret_device.has_access(module.get_access(user)))
			return TOPIC_REFRESH
		var/obj/machinery/turret/network/net_turret = turret_device.holder
		if(href_list["settings"])
			var/datum/topic_state/remote/remote = new(module, net_turret)
			net_turret.ui_interact(user, state = remote)
			return TOPIC_REFRESH

		if(href_list["logs"])
			if(!LAZYLEN(net_turret.logs))
				to_chat(user, SPAN_WARNING("\The [net_turret] currently has no logs!"))
				return TOPIC_HANDLED

			var/choice = alert(user,"Would you like to download the turret's logs or delete them?", "Sentry Turret Logs", "Download", "Delete","Cancel")
			if(!CanInteract(user, state))
				return TOPIC_HANDLED
			if(choice == "Download")
				var/datum/computer_file/data/logfile/turret_log = net_turret.prepare_log_file()
				view_file_browser(user, "save_log", /datum/computer_file/data/logfile, OS_WRITE_ACCESS, "Save log file:", turret_log)
				return TOPIC_REFRESH
			if(choice == "Delete")
				var/confirm = alert(user, "Are you sure?", "Log deletion", "No", "Yes")
				if(confirm == "Yes" && CanInteract(user, state))
					LAZYCLEARLIST(net_turret.logs)
					return TOPIC_REFRESH

			return TOPIC_HANDLED