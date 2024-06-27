/datum/computer_file/program/appdownloader
	filename = "ntndownloader"
	filedesc = "Software Download Tool"
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "arrowthickstop-1-s"
	extended_desc = "This program allows downloads of software from the local software repositories"
	unsendable = 1
	undeletable = 1
	size = 4
	requires_network_feature = NET_FEATURE_SOFTWAREDOWNLOAD
	available_on_network = 0
	nanomodule_path = /datum/nano_module/program/computer_appdownloader/
	ui_header = "downloader_finished.gif"
	var/downloaderror
	var/list/downloads_queue[0]
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

	var/datum/file_transfer/current_transfer

/datum/computer_file/program/appdownloader/on_startup(mob/living/user, datum/extension/interactive/os/new_host)
	. = ..()
	// Initialize the internal "appdownload" disk if necessary.
	var/datum/file_storage/network/app_download = new_host.mounted_storage["appdownload"]
	if(!istype(app_download)) // If you had another network disk named appdownload it will be appropriated.
		qdel(app_download)
		new_host.mounted_storage["appdownload"] = new /datum/file_storage/network(new_host, "appdownload", TRUE)

/datum/computer_file/program/appdownloader/on_shutdown()
	..()
	QDEL_NULL(current_transfer)
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/appdownloader/proc/begin_file_download(var/filename)
	if(current_transfer)
		return 0

	var/datum/computer_network/net = computer.get_network()
	if(!net)
		return 0

	if(!check_file_download(filename))
		return 0
	var/datum/computer_file/program/PRG = net.find_file_by_name(filename, OS_PROGRAMS_DIR, MF_ROLE_SOFTWARE)
	if(!istype(PRG))
		return 0
	var/datum/file_storage/disk/destination = computer.mounted_storage["local"]
	if(!destination)
		return 0
	var/datum/file_storage/network/source = computer.mounted_storage["appdownload"]
	if(!source)
		return 0
	var/datum/computer_file/directory/programs_directory = destination.parse_directory(OS_PROGRAMS_DIR, TRUE)
	if(!programs_directory)
		return 0
	source.set_server(net.find_file_location(PRG, mainframe_role = MF_ROLE_SOFTWARE))
	if(source.check_errors() || destination.check_errors())
		return 0
	current_transfer = new(source, destination, programs_directory, PRG, TRUE)

	ui_header = "downloader_running.gif"
	generate_network_log("Downloading file [filename] from [source.server].")

/datum/computer_file/program/appdownloader/proc/check_file_download(var/filename)
	//returns 1 if file can be downloaded, returns 0 if download prohibited
	var/datum/computer_network/net = computer.get_network()
	if(!net)
		return 0
	var/datum/computer_file/program/PRG = net.find_file_by_name(filename, OS_PROGRAMS_DIR, MF_ROLE_SOFTWARE)

	if(!istype(PRG))
		return 0

	if(!computer || (computer.try_store_file(PRG, computer.programs_dir) != OS_FILE_SUCCESS))
		return 0

	return 1

/datum/computer_file/program/appdownloader/proc/abort_file_download()
	if(!current_transfer)
		return
	QDEL_NULL(current_transfer)
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/appdownloader/process_tick()
	if(!current_transfer)
		return

	var/result = current_transfer.update_progress()
	if(result != OS_FILE_SUCCESS) //something went wrong
		if(QDELETED(current_transfer)) //either completely
			downloaderror = "I/O ERROR: Unknown error during the file transfer."
		else  //or during the saving at the destination
			downloaderror = "I/O ERROR: Unable to store '[current_transfer.transferring.filename]' at [current_transfer.transfer_to]"
			qdel(current_transfer)
		current_transfer = null
		ui_header = "downloader_finished.gif"
	else if(!current_transfer.left_to_transfer)  //done
		QDEL_NULL(current_transfer)
		ui_header = "downloader_finished.gif"
	if(!current_transfer && downloads_queue.len > 0)
		var/next = popleft(downloads_queue)
		begin_file_download(next)

/datum/computer_file/program/appdownloader/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["PRG_downloadfile"])
		if(!current_transfer)
			begin_file_download(href_list["PRG_downloadfile"])
		else if(check_file_download(href_list["PRG_downloadfile"]) && !downloads_queue.Find(href_list["PRG_downloadfile"]) && current_transfer.transferring.filename != href_list["PRG_downloadfile"])
			downloads_queue |= href_list["PRG_downloadfile"]
		return 1
	if(href_list["PRG_removequeued"])
		downloads_queue.Remove(href_list["PRG_removequeued"])
		return 1
	if(href_list["PRG_reseterror"])
		downloaderror = null
		return 1
	return 0

/datum/nano_module/program/computer_appdownloader
	name = "Software Downloader"

/datum/nano_module/program/computer_appdownloader/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = list()
	var/datum/computer_file/program/appdownloader/prog = program
	// For now limited to execution by the downloader program
	if(!prog || !istype(prog))
		return
	if(program)
		data = program.get_header_data()

	// This IF cuts on data transferred to client, so i guess it's worth it.
	if(prog.downloaderror) // Download errored. Wait until user resets the program.
		data["error"] = prog.downloaderror
	if(prog.current_transfer) // Download running. Wait please...
		data |= prog.current_transfer.get_ui_data()
		data["downloadspeed"] = prog.current_transfer.get_transfer_speed()
		var/datum/computer_file/program/P = prog.current_transfer.transferring
		if(istype(P))
			data["transfer_desc"] = P.extended_desc

	data["disk_size"] = program.computer.max_disk_capacity()
	data["disk_used"] = program.computer.used_disk_capacity()
	var/list/all_entries[0]
	var/datum/computer_network/net = program.computer.get_network()
	if(net)
		for(var/category in net.get_all_software_categories())
			var/list/category_list[0]
			for(var/datum/computer_file/program/P in net.get_software_list(category))
				// Only those programs our user can run will show in the list
				if(!P.can_run(get_access(user), user, FALSE) && P.requires_access_to_download)
					continue
				if(!P.is_supported_by_hardware(program.computer.get_hardware_flag(), user, FALSE))
					continue
				category_list.Add(list(list(
				"filename" = P.filename,
				"filedesc" = P.filedesc,
				"fileinfo" = P.extended_desc,
				"size" = P.size,
				"icon" = P.program_menu_icon
				)))
			if(category_list.len)
				all_entries.Add(list(list("category"=category, "programs"=category_list)))

	data["downloadable_programs"] = all_entries

	if(prog.downloads_queue.len > 0)
		var/list/queue = list() // Nanoui can't iterate through assotiative lists, so we have to do this
		for(var/item in prog.downloads_queue)
			queue += item
		data["downloads_queue"] = queue

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "software_downloader.tmpl", name, 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
