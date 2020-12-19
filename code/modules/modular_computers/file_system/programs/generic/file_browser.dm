/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "NTOS File Manager"
	extended_desc = "This program allows management of files."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 8
	available_on_network = 0
	undeletable = 1
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL
	var/open_file
	var/error
	var/list/file_sources = list(
		/datum/file_storage/disk,
		/datum/file_storage/disk/removable,
		/datum/file_storage/network
	)
	var/datum/file_storage/current_filesource = /datum/file_storage/disk
	var/datum/file_transfer/current_transfer	//ongoing file transfer between filesources

/datum/computer_file/program/filemanager/on_startup(var/mob/living/user, var/datum/extension/interactive/ntos/new_host)
	..()
	for(var/T in file_sources)
		file_sources[T] = new T(new_host)
	current_filesource = file_sources[initial(current_filesource)]

/datum/computer_file/program/filemanager/on_shutdown()
	for(var/T in file_sources)
		var/datum/file_storage/FS = file_sources[T]
		qdel(FS)
		file_sources[T] = null
	current_filesource = initial(current_filesource)
	ui_header = null
	if(current_transfer)
		qdel(current_transfer)
	return ..()

/datum/computer_file/program/filemanager/Topic(href, href_list, state)
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
				var/list/file_servers = network.get_file_server_tags(MF_ROLE_FILESERVER, user)
				var/datum/file_storage/network/N = current_filesource
				if(!file_servers.len)
					N.server = null // Don't allow players to see files on mainframes they cannot access.
					return TOPIC_REFRESH
				N.server = file_servers[1]
			return TOPIC_REFRESH

	if(href_list["PRG_changefileserver"])
		. = TOPIC_HANDLED
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		var/list/file_servers = network.get_file_server_tags(MF_ROLE_FILESERVER, user)
		var/file_server = input(usr, "Choose a fileserver to view files on:", "Select File Server") as null|anything in file_servers
		if(file_server)
			var/datum/file_storage/network/N = file_sources[/datum/file_storage/network]
			N.server = file_server
			return TOPIC_REFRESH

	var/errors = current_filesource.check_errors()
	if(errors)
		error = errors
		return TOPIC_HANDLED

	if(href_list["PRG_openfile"])
		. = TOPIC_HANDLED
		open_file = href_list["PRG_openfile"]

	if(href_list["PRG_newtextfile"])
		. = TOPIC_HANDLED
		var/newname = sanitize(input(usr, "Enter file name or leave blank to cancel:", "File rename"))
		if(!newname)
			return TOPIC_HANDLED

		if(current_filesource.create_file(newname))
			return TOPIC_REFRESH
	
	if(href_list["PRG_deletefile"])
		. = TOPIC_REFRESH
		current_filesource.delete_file(href_list["PRG_deletefile"])

	if(href_list["PRG_usbdeletefile"])
		. = TOPIC_REFRESH
		current_filesource.delete_file(href_list["PRG_usbdeletefile"])

	if(href_list["PRG_closefile"])
		. = TOPIC_REFRESH
		open_file = null
		error = null

	if(href_list["PRG_clone"])
		. = TOPIC_REFRESH
		current_filesource.clone_file(href_list["PRG_clone"])

	if(href_list["PRG_rename"])
		. = TOPIC_REFRESH
		var/datum/computer_file/F = current_filesource.get_file(href_list["PRG_rename"])
		if(!F || !istype(F))
			return
		var/newname = sanitize(input(usr, "Enter new file name:", "File rename", F.filename))
		if(F && newname)
			F.filename = newname

	if(href_list["PRG_edit"])
		. = TOPIC_HANDLED
		if(!open_file)
			return
		var/datum/computer_file/data/F = current_filesource.get_file(open_file)
		if(!F || !istype(F))
			return
		if(F.do_not_edit && (alert("WARNING: This file is not compatible with editor. Editing it may result in permanently corrupted formatting or damaged data consistency. Edit anyway?", "Incompatible File", "No", "Yes") == "No"))
			return
		if(F.read_only)
			error = "This file is read only. You cannot edit it."
			return

		var/oldtext = html_decode(F.stored_data)
		oldtext = replacetext(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Editing file [open_file]. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
		if(!newtext || !CanInteract(user, state))
			return

		if(F)
			current_filesource.save_file(F.filename, newtext)
			return TOPIC_REFRESH

	if(href_list["PRG_printfile"])
		. = 1
		if(!open_file)
			return
		var/datum/computer_file/data/F = current_filesource.get_file(open_file)
		if(!F || !istype(F))
			return
		if(!computer.print_paper(digitalPencode2html(F.stored_data),F.filename,F.papertype, F.metadata))
			error = "Hardware error: Unable to print the file."
			return TOPIC_REFRESH

	if(href_list["PRG_stoptransfer"])
		QDEL_NULL(current_transfer)
		ui_header = null
		return TOPIC_REFRESH

	if(href_list["PRG_transferto"])
		. = TOPIC_REFRESH
		var/datum/computer_file/F = current_filesource.get_file(href_list["PRG_transferto"])
		if(!F || !istype(F) || F.unsendable)
			error = "I/O ERROR: Unable to transfer file."
			return
		var/list/choices = list()
		for(var/T in file_sources)
			var/datum/file_storage/FS = file_sources[T]
			if(FS == current_filesource)
				continue
			choices[FS.name] = FS
		var/file_source = input(usr, "Choose a destination storage medium:", "Transfer To Another Medium") as null|anything in choices
		if(file_source)
			var/datum/file_storage/dst = choices[file_source]
			var/nope = dst.check_errors()
			if(nope)
				to_chat(user, SPAN_WARNING("Cannot transfer file to [dst] for following reason: [nope]"))
				return
			current_transfer = new(current_filesource, dst, F, FALSE)
			ui_header = "downloader_running.gif"

/datum/computer_file/program/filemanager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
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
	if(open_file)
		var/datum/computer_file/data/F
		F = current_filesource.get_file(open_file)
		if(!istype(F))
			data["error"] = "I/O ERROR: Unable to open file."
		else
			data["filedata"] = F.generate_file_data(user)
			data["filename"] = "[F.filename].[F.filetype]"
	else
		var/list/files[0]
		for(var/datum/computer_file/F in current_filesource.get_all_files())
			files.Add(list(list(
				"name" = F.filename,
				"type" = F.filetype,
				"size" = F.size,
				"undeletable" = F.undeletable,
				"unsendable" = F.unsendable
			)))
		data["files"] = files

	// Don't show transfers that will be over in a tick, screw flickering
	if(current_transfer && current_transfer.get_eta() > 2)
		data |= current_transfer.get_ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "file_manager.tmpl", "NTOS File Manager", 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()

/datum/computer_file/program/filemanager/process_tick()
	if(!current_transfer)
		return
	var/result = current_transfer.update_progress()
	if(!result) //something went wrong
		if(QDELETED(current_transfer)) //either completely
			error = "I/O ERROR: Unknown error during the file transfer."
		else  //or during the saving at the destination
			error = "I/O ERROR: Unable to store '[current_transfer.transferring.filename]' at [current_transfer.transfer_to]"
			qdel(current_transfer)
		current_transfer = null
		ui_header = null
		return
	else if(!current_transfer.left_to_transfer)  //done
		QDEL_NULL(current_transfer)
		ui_header = null

