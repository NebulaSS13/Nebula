// Generic interface for selecting/saving files with programs. The file manager program does not use this.
/datum/computer_file/program	
	var/datum/nano_module/program/file_browser/browser_module

/datum/computer_file/program/on_shutdown(forced)
	QDEL_NULL(browser_module)
	. = ..()

/datum/computer_file/program/proc/view_file_browser(mob/user, selecting_key, selecting_filetype, req_perm, browser_desc, datum/computer_file/saving_file)
	if(!browser_module)
		browser_module = new (src, new /datum/topic_manager/program(src), src)
	browser_module.using_access = computer.get_access()

	browser_module.reset_browser(selecting_key, selecting_filetype, req_perm, browser_desc, saving_file)
	browser_module.ui_interact(user)
	return TRUE

/datum/computer_file/program/proc/on_file_select(datum/file_storage/disk, datum/computer_file/directory/dir, datum/computer_file/selected, selecting_key)
	browser_module.reset_browser()
	SSnano.close_uis(browser_module)
	SSnano.update_uis(src)

/datum/nano_module/program/file_browser
	var/disk_name = "local"
	var/weakref/dir_ref
	var/browser_error

	var/selecting_key // String identifying the action being performed, passed to proc/on_file_select on the program itself.
	var/selecting_filetype // /datum/computer_file subtype being selected/created.

	var/weakref/selected_file // Reference to the file being selected.

	var/datum/computer_file/saving_file // The file, if any, that's being saved. For the sake of GC, this should be a completely new file
										// not stored on any drive, and a reference to it should not be kept until after the browser finishes.

	var/req_perm
	var/browser_desc		// String describing the action being performed.

/datum/nano_module/program/file_browser/Destroy()
	QDEL_NULL(saving_file)
	selected_file = null
	dir_ref = null
	. = ..()

/datum/nano_module/program/file_browser/Topic(href, href_list)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	var/list/accesses = get_access(user)
	var/datum/extension/interactive/os/computer = program.computer
	
	if(href_list["BRS_back"])
		if(browser_error)
			browser_error = null
			return TOPIC_REFRESH
		SSnano.close_uis(src)
		reset_browser()
		return TOPIC_REFRESH

	if(href_list["BRS_select_disk"])
		var/selected_disk = href_list["BRS_select_disk"]
		if(selected_disk in computer.mounted_storage)
			disk_name = selected_disk
			return TOPIC_REFRESH
		return TOPIC_HANDLED
	
	if(!disk_name)
		return TOPIC_REFRESH
	
	var/datum/file_storage/current_disk = computer.mounted_storage[disk_name]
	if(!current_disk)
		disk_name = null
		return TOPIC_REFRESH

	var/errors = current_disk.check_errors()
	if(errors)
		browser_error = errors
		return TOPIC_REFRESH

	var/datum/computer_file/directory/current_directory = dir_ref?.resolve()
	if(current_directory && !(current_directory in current_disk.get_all_files()))
		dir_ref = null
		return TOPIC_REFRESH

	if(href_list["BRS_up_directory"])
		if(!current_directory)
			disk_name = null
		var/datum/computer_file/directory/parent_dir = current_directory?.get_directory()
		dir_ref = weakref(parent_dir)
		return TOPIC_REFRESH
	
	if(href_list["BRS_change_directory"])
		var/datum/computer_file/directory/dir = current_disk.get_file(href_list["BRS_change_directory"], current_directory)
		if(!istype(dir))
			return TOPIC_HANDLED
		if(!(dir.get_file_perms(accesses, user) & OS_READ_ACCESS))
			to_chat(user, SPAN_WARNING("You do not have permission to open this directory."))
			return TOPIC_HANDLED
		
		dir_ref = weakref(dir)
		return TOPIC_REFRESH

	if(href_list["BRS_select_file"])
		var/datum/computer_file/F = current_disk.get_file(href_list["BRS_select_file"], current_directory)
		if(!F)
			return TOPIC_HANDLED

		if(saving_file)
			saving_file.filename = F.filename
			return TOPIC_REFRESH

		if(!istype(F, selecting_filetype))
			to_chat(user, SPAN_WARNING("This file is not the proper type."))
			return TOPIC_HANDLED
		
		if(!(F.get_file_perms(accesses, user) & req_perm))
			to_chat(user, SPAN_WARNING("You do not have permission to open this file."))
			return TOPIC_HANDLED
		
		selected_file = weakref(F)
		return TOPIC_REFRESH
	
	if(href_list["BRS_rename_file"])
		if(!saving_file)
			return TOPIC_HANDLED
		var/newname = sanitize_for_file(input(usr, "Enter file name:", "Save file", saving_file.filename))
		if(!length(newname))
			to_chat(user, SPAN_WARNING("Invalid file name!"))
			return TOPIC_HANDLED

		saving_file.filename = newname
		return TOPIC_REFRESH

	if(href_list["BRS_save_file"])
		if(!saving_file)
			return TOPIC_HANDLED

		var/success = current_disk.store_file(saving_file, current_directory, accesses = accesses, user = user)
		if(success != OS_FILE_SUCCESS)
			if(success == OS_FILE_NO_WRITE)
				to_chat(user, SPAN_WARNING("You do not have permission to write/overwrite the file in this directory."))
				return TOPIC_HANDLED
			if(success == OS_HARDDRIVE_SPACE)
				to_chat(user, SPAN_WARNING("Insufficient harddrive space."))
			
			// Since we know the directory exists, any other error indicates something is wrong with the drive or network.
			to_chat(user, SPAN_WARNING("I/O ERROR: Drive is non-functional or could not be accessed on the network."))
			return TOPIC_REFRESH
		
		var/datum/computer_file/saved_file = saving_file
		saving_file = null // We null this out so it doesn't get QDEL when the nanomodule is reset, but any other action that resets the browser does.
		to_chat(user, SPAN_NOTICE("Created file [saved_file.filename].[saved_file.filetype]."))
		program.on_file_select(current_disk, current_directory, saved_file, selecting_key)
		return TOPIC_HANDLED
	
	if(href_list["BRS_finalize_select"])
		if(saving_file || !selected_file)
			return TOPIC_HANDLED
		
		var/datum/computer_file/F = selected_file.resolve()
		if(!istype(F))
			selected_file = null
			return TOPIC_REFRESH
		
		if(!istype(F, selecting_filetype))
			to_chat(user, SPAN_WARNING("This file is not the proper type."))
			selected_file = null
			return TOPIC_HANDLED
		
		if(!(F.get_file_perms(accesses, user) & req_perm))
			to_chat(user, SPAN_WARNING("You do not have permission to open this file."))
			selected_file = null
			return TOPIC_HANDLED
		
		program.on_file_select(current_disk, current_directory, F, selecting_key)
		SSnano.close_uis(src)
		reset_browser()
		return TOPIC_REFRESH

	if(href_list["BRS_create_dir"])
		if(!saving_file)
			return TOPIC_HANDLED
		var/dirname = sanitize_for_file(input(usr, "Enter directory name or leave blank to cancel:", "Directory creation"))
		if(!length(dirname))
			return TOPIC_HANDLED

		var/datum/computer_file/directory/created_dir = current_disk.create_directory(dirname, current_directory, accesses, user)
		if(!istype(created_dir))
			if(created_dir == OS_HARDDRIVE_ERROR || created_dir == OS_NETWORK_ERROR)
				to_chat(user, SPAN_WARNING("I/O ERROR: Drive is non-functional or could not be accessed on the network."))
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("You lack permission to create a directory in this location."))
				return TOPIC_HANDLED
		
		to_chat(user, SPAN_NOTICE("Created directory [created_dir.filename]"))
		return TOPIC_HANDLED

/datum/nano_module/program/file_browser/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = program.get_header_data(TRUE)

	var/datum/extension/interactive/os/computer = program.computer

	var/datum/file_storage/current_disk = disk_name ? computer.mounted_storage[disk_name] : null
	var/datum/computer_file/current_directory = dir_ref?.resolve()	
	
	var/list/accesses = get_access(user)
	if(browser_error)
		data["error"] = browser_error
	else
		data["filetypes"] = get_readable_filetypes()
		if(saving_file)
			data["saving_file"] = TRUE
			data["curr_file_name"] = saving_file.filename
			data["curr_file_type"] = saving_file.filetype
		else
			data["saving_file"] = FALSE
			var/datum/computer_file/selected = selected_file?.resolve()
			if(istype(selected))
				data["curr_file_name"] = selected.filename
				data["curr_file_type"] = selected.filetype
		if(current_disk)
			// Safety check.
			if(current_directory && !(current_directory in current_disk.get_all_files()))
				dir_ref = null

			data["current_disk"] = current_disk.get_dir_path(current_directory, TRUE)

			var/list/files[0]
			for(var/datum/computer_file/F in current_disk.get_dir_files(current_directory))
				files.Add(list(list(
					"name" = F.filename,
					"type" = F.filetype,
					"dir" = istype(F, /datum/computer_file/directory), 
					"size" = F.size,
					"selectable" = istype(F, selecting_filetype)
				)))
			data["files"] = files
		else // No disk selected.
			dir_ref = null
			disk_name = null
			var/list/avail_disks[0]
			
			for(var/root_name in computer.mounted_storage)
				var/datum/file_storage/avail_disk = computer.mounted_storage[root_name]
				if(!avail_disk.hidden && avail_disk.check_access(accesses))
					avail_disks.Add(list(list(
						"name" = root_name,
						"desc" = avail_disk.desc
					)))

			data["avail_disks"] = avail_disks

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "file_browser.tmpl", browser_desc, 500, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()
	
	return 1

/datum/nano_module/program/file_browser/proc/reset_browser(new_key, new_filetype, new_req_perm, new_desc, datum/computer_file/new_saving_file)
	disk_name = "local"
	dir_ref = null
	browser_error = null
	selected_file = null

	selecting_key = new_key
	selecting_filetype = new_filetype
	req_perm = new_req_perm
	browser_desc = new_desc

	if(saving_file)
		QDEL_NULL(saving_file)
	saving_file = new_saving_file

/datum/nano_module/program/file_browser/proc/get_readable_filetypes()
	var/list/filetype_strings = list()
	for(var/T in typesof(selecting_filetype))
		var/datum/computer_file/option = T
		filetype_strings += ".[initial(option.filetype)]"
	return english_list(filetype_strings)