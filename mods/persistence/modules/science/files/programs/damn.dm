/datum/computer_file/program/damn
	filename = "damn"
	filedesc = "Destructrive Analyzer Management Nexus"
	extended_desc = "This program allows management of destructive analyzers."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 12
	available_on_network = 1
	undeletable = 0
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

	var/datum/computer_file/data/blueprint/open_file
	var/error
	var/list/file_sources = list(
		/datum/file_storage/disk,
		/datum/file_storage/disk/removable,
		/datum/file_storage/network
	)
	var/datum/file_storage/current_filesource = /datum/file_storage/disk

/datum/computer_file/program/damn/on_startup(var/mob/living/user, var/datum/extension/interactive/ntos/new_host)
	..()
	for(var/T in file_sources)
		file_sources[T] = new T(new_host)
	current_filesource = file_sources[initial(current_filesource)]

/datum/computer_file/program/damn/on_shutdown()
	for(var/T in file_sources)
		var/datum/file_storage/FS = file_sources[T]
		qdel(FS)
		file_sources[T] = null
	current_filesource = initial(current_filesource)
	ui_header = null
	return ..()

/datum/computer_file/program/damn/Topic(href, href_list, state)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	if(href_list["PRG_change_filesource"])
		. = TOPIC_HANDLED
		var/list/choices = list()
		for(var/T in file_sources)
			var/datum/file_storage/FS = file_sources[T]
			if(FS == current_filesource)
				continue
			choices[FS.name] = FS
		var/file_source = input(usr, "Choose a storage medium to use:", "Select Storage Medium") as null|anything in choices
		if(file_source)
			current_filesource = choices[file_source]
			if(istype(current_filesource, /datum/file_storage/network))
				var/datum/computer_network/network = computer.get_network()
				if(!network)
					return TOPIC_REFRESH
				// Helper for some user-friendliness. Try to select the first available mainframe.
				var/list/file_servers = network.get_file_server_tags()
				if(!file_servers.len)
					return TOPIC_REFRESH
				var/datum/file_storage/network/N = current_filesource
				N.server = file_servers[1]
			return TOPIC_REFRESH

	if(href_list["PRG_changefileserver"])
		. = TOPIC_HANDLED
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		var/list/file_servers = network.get_file_server_tags(user)
		var/file_server = input(usr, "Choose a fileserver to view files on:", "Select File Server") as null|anything in file_servers
		if(file_server)
			var/datum/file_storage/network/N = file_sources[/datum/file_storage/network]
			N.server = file_server
			return TOPIC_REFRESH

	var/errors = current_filesource.check_errors()
	if(errors)
		error = errors
		return TOPIC_HANDLED

	if(href_list["PRG_analyze"])
		. = TOPIC_REFRESH
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		var/datum/extension/network_device/D = network.get_device_by_tag(href_list["PRG_analyze"])
		var/obj/machinery/destructive_analyzer/DA = D.holder
		if(DA.loaded_item)
			DA.process_loaded(user, current_filesource)

	if(href_list["PRG_eject"])
		. = TOPIC_REFRESH
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		var/datum/extension/network_device/D = network.get_device_by_tag(href_list["PRG_eject"])
		var/obj/machinery/destructive_analyzer/DA = D.holder
		if(DA.loaded_item)
			DA.loaded_item.dropInto(DA.loc)
			DA.loaded_item = null
			DA.update_icon()

/datum/computer_file/program/damn/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	. = ..()
	if(!.)
		return
	var/list/data = computer.initial_data()

	if(error)
		data["error"] = error
	else if(current_filesource)
		data["error"] = current_filesource.check_errors()

	data["current_source"] = current_filesource.name
	if(istype(current_filesource, /datum/file_storage/network))
		var/datum/file_storage/network/N = current_filesource
		data["fileserver"] = N.server

	var/datum/computer_network/network = computer.get_network()
	if(istype(network))
		data["analyzers"] = list()
		for(var/obj/machinery/destructive_analyzer/DA in network.get_devices_by_type(/obj/machinery/destructive_analyzer, user))
			var/datum/extension/network_device/device = get_extension(DA, /datum/extension/network_device)
			var/analyzer = list(
				"network_tag" = device.network_tag,
				"loaded_with" = istype(DA.loaded_item) ? DA.loaded_item.name : FALSE
			)
			if(istype(DA.loaded_item))
				var/list/techlvls
				if(istype(DA.loaded_item, /obj/item/experiment))
					var/obj/item/experiment/experiment = DA.loaded_item
					analyzer["experiment"] = experiment.experiment_id ? "experiment [experiment.experiment_id]" : "invention"
					techlvls = experiment.get_tech_levels()
				else
					analyzer["experiment"] = "None"
					techlvls = json_decode(DA.loaded_item.origin_tech)
				var/list/results = list()
				for(var/techlvl in techlvls)
					results += "[techlvl] [techlvls[techlvl]]"
				analyzer["tech_levels"] = english_list(results)

			data["analyzers"] += list(analyzer)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "damn.tmpl", "Destruct. Analyzer Mgmt. Nexus", 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()