#define FM_NONE 0
#define FM_READ 1
#define FM_PERM 2

#define MAX_FILE_PATTERNS 5

/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "OS File Manager"
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
	var/file_mode = FM_NONE
	var/error // Generic error, wiped on any action

	var/file_error // File error, closes open_file once cleared
	var/disk_error // Disk error, removes current disk once cleared

	var/list/disks = list() // List of list(/datum/file_storage, weakref(directory file)).
	var/current_index

	var/datum/file_transfer/current_transfer	//ongoing file transfer between file_storage datums

	// Variables for modifying file perms
	var/list/f_read_access = list()
	var/list/f_write_access = list()
	var/list/f_mod_access = list()

	var/current_perm = OS_READ_ACCESS

	var/selected_pattern // Index of the current pattern being accessed.
	var/selected_parent_group

/datum/computer_file/program/filemanager/on_shutdown()
	disks.Cut()
	ui_header = null
	current_index = null
	if(current_transfer)
		qdel(current_transfer)

	error = null
	file_error = null
	disk_error = null
	open_file = null
	file_mode = FM_NONE
	reset_perm_mod()

	return ..()

/datum/computer_file/program/filemanager/Topic(href, href_list, state)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	var/list/accesses = computer.get_access(user)

	error = null
	if(file_error)
		file_error = null
		open_file = null
		file_mode = FM_NONE

	if(disk_error)
		disk_error = null
		disks -= list(disks[current_index])
		current_index = null

	if(href_list["PRG_clear_error"])
		return TOPIC_REFRESH

	if(href_list["PRG_select_disk"])
		var/disk_name = href_list["PRG_select_disk"]
		var/datum/file_storage/selected_disk = computer.mounted_storage[disk_name]
		if(selected_disk)
			disks += list(list(selected_disk, null))
			current_index = disks.len
		return TOPIC_REFRESH

	if(href_list["PRG_mount_network"])
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			to_chat(user, SPAN_WARNING("NETWORK ERROR: No connectivity to the network."))
			return TOPIC_HANDLED
		if(!computer.get_network_status(NET_FEATURE_FILESYSTEM))
			to_chat(user, SPAN_WARNING("NETWORK ERROR: The network denied filesystem access."))
			return TOPIC_HANDLED
		var/list/available_mainframes = network.get_file_server_tags(MF_ROLE_FILESERVER, accesses)
		if(!length(available_mainframes))
			to_chat(user, SPAN_WARNING("NETWORK ERROR: No available mainframes on the network."))
		var/fileserver_tag = input(user, "Choose a mainframe you would like to mount as a disk:", "Mainframe Mount") as null|anything in available_mainframes
		if(!fileserver_tag)
			return TOPIC_HANDLED
		var/root_name = sanitize_for_file(input(user, "Enter the name of the root directory for the newly mounted disk.", "Root directory") as null|text)
		if(!root_name)
			return TOPIC_HANDLED
		var/feedback = computer.mount_mainframe(root_name, fileserver_tag)
		to_chat(user, SPAN_NOTICE(feedback))
		return TOPIC_REFRESH

	if(href_list["PRG_mount_settings"])
		var/root_name = href_list["PRG_mount_settings"]
		var/datum/file_storage/network/avail_disk = computer.mounted_storage[root_name]
		if(!istype(avail_disk))
			return TOPIC_REFRESH
		if(avail_disk.hidden || !avail_disk.check_access(accesses))
			to_chat(user, SPAN_WARNING("You don't have permission to modify this network drive!"))
			return TOPIC_HANDLED

		var/datum/computer_file/data/automount_file = get_file("automount", "local")
		var/automount_str = "[root_name]|[avail_disk.server];"

		var/automounted = istype(automount_file) ? findtext(automount_file.stored_data, automount_str) : FALSE

		var/prompt = alert(user, "What would you like to do?", "Mount settings", "Cancel", "Unmount", automounted ? "Disable auto mount" : "Enable auto mount")

		if(!CanInteract(user, state))
			return TOPIC_HANDLED

		switch(prompt)
			if("Unmount")
				computer.unmount_storage(root_name)
				to_chat(user, SPAN_NOTICE("Unmounted the network drive [root_name]."))
				return TOPIC_REFRESH
			if("Disable auto mount")
				if(!automounted || !istype(automount_file))
					return TOPIC_REFRESH

				// Remove the auto mount string
				automount_file.stored_data = replacetextEx(automount_file.stored_data, automount_str, "")
				to_chat(user, SPAN_NOTICE("The network drive [root_name] will no longer auto mount on startup."))
				return TOPIC_REFRESH

			if("Enable auto mount")
				if(automounted)
					return TOPIC_REFRESH

				if(!istype(automount_file))
					// Create the automount file.
					automount_file = create_file("automount", "local", file_type = /datum/computer_file/data)
					if(!istype(automount_file))
						return TOPIC_REFRESH

				automount_file.stored_data += automount_str
				to_chat(user, SPAN_NOTICE("The network drive [root_name] will now auto mount on startup."))
				return TOPIC_REFRESH

	if(href_list["PRG_change_disk"])
		var/disk_index = text2num(href_list["PRG_change_disk"])
		if(disk_index == 0 || disk_index > disks.len)
			current_index = null
			return TOPIC_REFRESH
		current_index = disk_index
		return TOPIC_REFRESH

	if(!current_index || current_index > disks.len)
		current_index = null
		return TOPIC_REFRESH

	var/datum/file_storage/current_disk = disks[current_index]?[1]
	if(!current_disk)
		return TOPIC_HANDLED

	if(href_list["PRG_exit_disk"])
		if(!current_index)
			return TOPIC_HANDLED
		disks -= list(disks[current_index]) // We have to enclose the list in another list to get it to actually remove it from disks.
		current_index--
		return TOPIC_REFRESH

	var/disk_errors = current_disk.check_errors()
	if(disk_errors)
		return TOPIC_REFRESH // ui_interact refreshs the disk errors anyway.

	var/weakref/dir_ref = disks[current_index][2]
	var/datum/computer_file/directory/current_directory
	if(istype(dir_ref))
		current_directory = dir_ref.resolve()
		if(!current_directory || !(current_directory in current_disk.get_all_files()))
			disks[current_index][2] = null
			current_directory = null
	else
		disks[current_index][2] = null

	if(href_list["PRG_up_directory"])
		var/datum/computer_file/directory/parent_dir = current_directory?.get_directory()
		if(parent_dir)
			disks[current_index][2] = weakref(parent_dir)
		else
			disks[current_index][2] = null
		return TOPIC_REFRESH

	if(href_list["PRG_openfile"])
		. = TOPIC_HANDLED
		var/datum/computer_file/F = current_disk.get_file(href_list["PRG_openfile"], current_directory)
		if(!F)
			return TOPIC_HANDLED
		if(istype(F, /datum/computer_file/directory))
			if(F.get_file_perms(accesses, user) & OS_READ_ACCESS)
				disks[current_index][2] = weakref(F)
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("You do not have permission to open this directory."))
				return TOPIC_HANDLED

		if(istype(F, /datum/computer_file/data))
			if(F.get_file_perms(accesses, user) & OS_READ_ACCESS)
				open_file = href_list["PRG_openfile"]
				file_mode = FM_READ
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("You do not have permission to open this file."))
				return TOPIC_HANDLED

		to_chat(user, SPAN_WARNING("This file is not in a readable format."))
		return TOPIC_HANDLED

	if(href_list["PRG_modifyperms"])
		var/datum/computer_file/mod_file = current_disk.get_file(href_list["PRG_modifyperms"], current_directory, accesses, user)
		if(!(mod_file?.get_file_perms(accesses, user) & OS_MOD_ACCESS))
			to_chat(user, SPAN_WARNING("You lack access to modify the permissions of '[mod_file.filename].[mod_file.filetype]'."))
			return TOPIC_HANDLED

		open_file = href_list["PRG_modifyperms"]
		file_mode = FM_PERM

		f_read_access = LAZYLEN(mod_file.read_access) ? mod_file.read_access.Copy() : list()
		f_write_access = LAZYLEN(mod_file.write_access) ? mod_file.write_access.Copy() : list()
		f_mod_access = LAZYLEN(mod_file.mod_access) ? mod_file.mod_access.Copy() : list()

		return TOPIC_REFRESH

	if(href_list["PRG_newtextfile"])
		. = TOPIC_REFRESH
		var/newname = sanitize_for_file(input(usr, "Enter file name or leave blank to cancel:", "New file"))
		if(!length(newname))
			return TOPIC_HANDLED

		var/created_file = current_disk.create_file(newname, current_directory, file_type = /datum/computer_file/data/text, accesses = accesses, user = user)
		if(created_file != OS_FILE_SUCCESS)
			switch(created_file)
				if(OS_FILE_NO_WRITE)
					to_chat(user, SPAN_WARNING("You lack permission to create a file in this directory."))
					return TOPIC_HANDLED
				if(OS_NETWORK_ERROR)
					to_chat(user, SPAN_WARNING("Unable to access directory on the network."))
					return TOPIC_REFRESH
				if(OS_HARDDRIVE_SPACE)
					to_chat(user, SPAN_WARNING("Unable to create new file. The hard drive is full."))
					return TOPIC_HANDLED
				else
					to_chat(user, SPAN_WARNING("Unable to create new file. The hard drive may be non-functional."))
					return TOPIC_REFRESH

	if(href_list["PRG_newdir"])
		. = TOPIC_REFRESH
		var/newname = sanitize_for_file(input(usr, "Enter directory name or leave blank to cancel:", "New directory"))
		if(!length(newname))
			return TOPIC_HANDLED
		var/created_dir = current_disk.create_directory(newname, current_directory, accesses, user)
		if(created_dir != OS_FILE_SUCCESS)
			switch(created_dir)
				if(OS_FILE_NO_WRITE)
					to_chat(user, SPAN_WARNING("You lack permission to create a directory in this directory."))
					return TOPIC_HANDLED
				if(OS_NETWORK_ERROR)
					to_chat(user, SPAN_WARNING("Unable to access directory on the network."))
					return TOPIC_REFRESH
				else
					to_chat(user, SPAN_WARNING("Unable to create new directory. The hard drive may be non-functional."))
					return TOPIC_REFRESH

	if(href_list["PRG_deletefile"])
		var/datum/computer_file/del_file = current_disk.get_file(href_list["PRG_deletefile"], current_directory, accesses, user)
		var/deleted = current_disk.delete_file(del_file, accesses, user)
		if(deleted != OS_FILE_SUCCESS)
			switch(deleted)
				if(OS_FILE_NO_WRITE)
					to_chat(user, SPAN_WARNING("You lack permission to delete '[href_list["PRG_deletefile"]]'."))
					return TOPIC_HANDLED
				if(OS_NETWORK_ERROR)
					to_chat(user, SPAN_WARNING("Unable to access '[href_list["PRG_deletefile"]]' on the network."))
					return TOPIC_REFRESH
				else
					to_chat(user, SPAN_WARNING("Failed to delete '[href_list["PRG_deletefile"]]'. The hard drive may be non-functional."))
					return TOPIC_REFRESH
		return TOPIC_REFRESH

	if(href_list["PRG_closefile"])
		. = TOPIC_REFRESH
		open_file = null
		if(file_mode == FM_PERM)
			reset_perm_mod()
		file_mode = FM_NONE
		file_error = null

	if(href_list["PRG_clone"])
		var/cloned = current_disk.clone_file(href_list["PRG_clone"], current_directory, accesses, user)
		if(cloned != OS_FILE_SUCCESS)
			switch(cloned)
				if(OS_FILE_NO_READ)
					to_chat(user, SPAN_WARNING("You lack permission to read the file '[href_list["PRG_clone"]]'."))
					return TOPIC_HANDLED
				if(OS_FILE_NO_WRITE)
					// Cheap hack to get the filename after cloning.
					var/datum/computer_file/source_file = get_file(href_list["PRG_clone"], current_disk.get_dir_path(current_directory, TRUE))
					to_chat(user, SPAN_WARNING("You lack permission to create the file '[href_list["PRG_clone"] + source_file.copy_string]'."))
					return TOPIC_HANDLED
				if(OS_NETWORK_ERROR)
					to_chat(user, SPAN_WARNING("Unable to access file '[href_list["PRG_clone"]]' on the network."))
					return TOPIC_REFRESH
				else
					to_chat(user, SPAN_WARNING("Unable to clone file '[href_list["PRG_clone"]]'. The hard drive may be non-functional."))
					return TOPIC_REFRESH
		return TOPIC_REFRESH

	if(href_list["PRG_rename"])
		var/datum/computer_file/F = current_disk.get_file(href_list["PRG_rename"], current_directory)
		if(!F || !istype(F))
			return TOPIC_REFRESH
		if(F.unrenamable)
			to_chat(user, SPAN_WARNING("You do not have permission to rename that file."))
			return TOPIC_HANDLED
		if(F.get_file_perms(accesses, user) & OS_WRITE_ACCESS)
			var/newname = sanitize_for_file(input(user, "Enter new file name:", "File rename", F.filename))
			if(F && length(newname))
				F.filename = newname
			return TOPIC_REFRESH
		else
			to_chat(user, SPAN_WARNING("You do not have permission to rename that file."))
			return TOPIC_HANDLED

	if(href_list["PRG_edit"])
		. = TOPIC_HANDLED
		if(!open_file || file_mode != FM_READ)
			return
		var/datum/computer_file/data/F = current_disk.get_file(open_file, current_directory)
		if(!F || !istype(F))
			return
		if(F.do_not_edit && (alert("WARNING: This file is not compatible with editor. Editing it may result in permanently corrupted formatting or damaged data consistency. Edit anyway?", "Incompatible File", "No", "Yes") == "No"))
			return
		if(F.read_only)
			file_error = "This file is read only. You cannot edit it."
			return
		if(!(F.get_file_perms(accesses, user) & OS_WRITE_ACCESS))
			file_error = "You do not have write access to this file."
			return
		var/oldtext = html_decode(F.stored_data)
		oldtext = replacetext(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext(input(user, "Editing file [open_file]. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
		if(!newtext || !CanInteract(user, state))
			return

		if(F)
			current_disk.save_file(F.filename, current_directory, newtext, null, accesses, user)
			return TOPIC_REFRESH

	if(href_list["PRG_printfile"])
		. = 1
		if(!open_file || file_mode != FM_READ)
			return
		var/datum/computer_file/data/F = current_disk.get_file(open_file, current_directory)
		if(!F || !istype(F))
			return
		if(!(F.get_file_perms(accesses, user) & OS_READ_ACCESS))
			file_error = "You do not have read access to this file."
			return
		if(!computer.print_paper(digitalPencode2html(F.stored_data), F.filename))
			file_error = "Hardware error: Unable to print the file."
			return TOPIC_REFRESH

	if(href_list["PRG_stoptransfer"])
		QDEL_NULL(current_transfer)
		ui_header = null
		return TOPIC_REFRESH

	if(href_list["PRG_transferto"])
		. = TOPIC_REFRESH
		var/datum/computer_file/F = current_disk.get_file(href_list["PRG_transferto"], current_directory)
		if(!F || !istype(F) || F.unsendable)
			to_chat(user, SPAN_WARNING("I/O ERROR: Unable to transfer file."))
			return

		var/copying = alert(usr, "Would you like to copy the file or transfer it? Transfering files requires write access.", "Copying file", "Copy", "Transfer")
		var/list/choices = list()
		var/list/curr_fs_list = disks[current_index]
		for(var/list/fs_list in disks)
			// Skip over the disk if its referencing the same directory.
			if(curr_fs_list[1] == fs_list[1] && curr_fs_list[2] == fs_list[2])
				continue

			var/datum/file_storage/FS = fs_list[1]
			var/weakref/FS_dir_ref = fs_list[2]

			var/datum/computer_file/directory/FS_dir = FS_dir_ref?.resolve()
			choices[FS.get_dir_path(FS_dir, TRUE)] = fs_list

		if(!length(choices))
			to_chat(usr, SPAN_WARNING("You must open another disk to transfer files."))
			return TOPIC_HANDLED

		var/storage = input(usr, "Choose a destination storage medium:", "Transfer To Another Medium") as null|anything in choices
		if(storage)
			var/list/chosen_list = choices[storage]
			var/datum/file_storage/dst = chosen_list[1]
			var/nope = dst.check_errors()
			if(nope)
				to_chat(user, SPAN_WARNING("Cannot transfer file to [dst] for following reason: [nope]"))
				return

			var/weakref/dst_dir_ref = chosen_list[2]
			var/datum/computer_file/directory/dst_dir = dst_dir_ref?.resolve()

			var/error = check_file_transfer(dst_dir, F, copying == "Copy", accesses, user)
			if(error)
				to_chat(user, SPAN_WARNING("Cannot transfer file: [error]."))
				return TOPIC_HANDLED
			current_transfer = new(current_disk, dst, dst_dir, F, copying == "Copy" ? TRUE : FALSE)
			ui_header = "downloader_running.gif"

	if(href_list["PRG_runfile"])
		. = TOPIC_HANDLED
		if(!open_file)
			return
		var/datum/computer_file/program/P = current_disk.get_file(open_file, current_directory)
		if(istype(P))
			computer.run_program(P.filename)
			return TOPIC_HANDLED
		var/datum/computer_file/data/F = current_disk.get_file(open_file, current_directory)
		if(!F || !istype(F))
			return
		computer.run_script(usr, F)
		return TOPIC_HANDLED

	// Permission modifying.
	if(file_mode == FM_PERM)
		if(!open_file)
			file_mode = FM_NONE
			return TOPIC_REFRESH

		var/datum/computer_network/network = computer.get_network()
		var/datum/extension/network_device/acl/access_controller = network?.access_controller
		if(!access_controller)
			file_error = "No access controller was found on the network."
			return TOPIC_REFRESH

		var/datum/computer_file/F = current_disk.get_file(open_file, current_directory)
		if(!F || !istype(F))
			file_error = "Unable to open file"
			return TOPIC_REFRESH
		if(!(F.get_file_perms(accesses, user) & OS_MOD_ACCESS))
			file_error = "You do not have access to modify this file's permissions."
			return TOPIC_REFRESH

		if(href_list["PRG_change_perm"])
			switch(href_list["PRG_change_perm"])
				if("read")
					current_perm = OS_READ_ACCESS
				if("write")
					current_perm = OS_WRITE_ACCESS
				if("mod")
					current_perm = OS_MOD_ACCESS

			selected_pattern = null
			return TOPIC_REFRESH

		var/list/current_perm_list
		switch(current_perm)
			if(OS_READ_ACCESS)
				current_perm_list = f_read_access
			if(OS_WRITE_ACCESS)
				current_perm_list = f_write_access
			if(OS_MOD_ACCESS)
				current_perm_list = f_mod_access

		if(href_list["PRG_add_pattern"])
			if(length(current_perm_list) >= MAX_FILE_PATTERNS)
				to_chat(usr, SPAN_WARNING("You cannot add more than [MAX_FILE_PATTERNS] patterns to a file's permissions."))
				return TOPIC_HANDLED
			current_perm_list += list(list()) // Add a plank pattern to the access list.
			return TOPIC_REFRESH

		if(href_list["PRG_remove_pattern"])
			var/pattern_index = text2num(href_list["PRG_remove_pattern"])
			if(pattern_index == 0 || pattern_index > length(current_perm_list))
				return TOPIC_HANDLED
			current_perm_list -= list(current_perm_list[pattern_index]) // We have to encapsulate the pattern in another list to actually delete it.
			if(selected_pattern == pattern_index)
				selected_pattern = null
			else if(selected_pattern > pattern_index)
				selected_pattern--
			return TOPIC_REFRESH

		if(href_list["PRG_select_pattern"])
			var/pattern_index = text2num(href_list["PRG_select_pattern"])
			if(pattern_index > length(current_perm_list))
				return TOPIC_HANDLED
			selected_pattern = pattern_index
			return TOPIC_REFRESH

		if(href_list["PRG_select_parent_group"])
			// The parent group actually existing is verified in ui_interact()
			selected_parent_group = href_list["PRG_select_parent_group"]
			return TOPIC_REFRESH

		if(selected_pattern > length(current_perm_list))
			selected_pattern = null
			return TOPIC_REFRESH

		var/list/pattern_list = current_perm_list[selected_pattern]

		if(href_list["PRG_assign_group"])
			var/group = href_list["PRG_assign_group"]
			if(!(group in access_controller.all_groups))
				return TOPIC_REFRESH
			if(!pattern_list)
				to_chat(user, SPAN_WARNING("Select a pattern first!"))
				return TOPIC_HANDLED
			pattern_list |= href_list["PRG_assign_group"] + ".[network.network_id]"
			return TOPIC_REFRESH

		if(href_list["PRG_remove_group"])
			if(!pattern_list)
				to_chat(user, SPAN_WARNING("Select a pattern first!"))
				return TOPIC_HANDLED
			pattern_list -= href_list["PRG_remove_group"] + ".[network.network_id]"
			return TOPIC_REFRESH

		if(href_list["PRG_apply_perms"])
			if(!has_access(f_mod_access, accesses))
				var/confirm = alert(user, "You will no longer be able to modify the permissions of this file. Are you sure?", "Permission Modification", "No", "Yes")
				if(!CanInteract(user, state) || confirm != "Yes")
					return TOPIC_HANDLED

			F.read_access = f_read_access.Copy()
			F.write_access = f_write_access.Copy()
			F.mod_access = f_mod_access.Copy()

			UNSETEMPTY(F.read_access)
			UNSETEMPTY(F.write_access)
			UNSETEMPTY(F.mod_access)

			to_chat(user, SPAN_NOTICE("Successfully changed permissions for '[F.filename].[F.filetype]'."))
			open_file = null
			file_mode = FM_NONE

			reset_perm_mod()
			return TOPIC_REFRESH

/datum/computer_file/program/filemanager/proc/reset_perm_mod()
	f_read_access.Cut()
	f_write_access.Cut()
	f_mod_access.Cut()
	current_perm = OS_READ_ACCESS

	selected_pattern = null
	selected_parent_group = null

/datum/computer_file/program/filemanager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	. = ..()
	if(!.)
		return
	var/list/data = computer.initial_data()
	var/list/accesses = computer.get_access(user)

	if(current_index > disks.len) // Safety check.
		current_index = null

	var/datum/file_storage/current_disk
	var/datum/computer_file/directory/current_directory

	if(current_index)
		var/list/current_disk_list = disks[current_index]
		current_disk = current_disk_list[1]

		var/weakref/dir_ref = current_disk_list[2]
		if(istype(dir_ref))
			current_directory = dir_ref.resolve()
		else
			current_disk_list[2] = null

	// Disk errors can occur without user error, so check them when the UI refreshes.
	if(current_disk)
		disk_error = current_disk.check_errors()
		data["disk_error"] = disk_error

	if(!disk_error)
		var/list/ui_disks[0]
		var/disk_index = 1
		for(var/list/ui_disk_list in disks)
			var/datum/file_storage/ui_disk = ui_disk_list[1]

			var/weakref/ui_dir_ref = ui_disk_list[2]
			var/datum/computer_file/directory/ui_directory
			if(istype(ui_dir_ref))
				ui_directory = ui_dir_ref.resolve()
			else
				ui_disk_list[2] = null

			ui_disks.Add(list(list(
				"name" = ui_disk.get_dir_path(ui_directory),
				"index" = disk_index,
				"selected" = disk_index == current_index
			)))
			disk_index++
		data["disks"] = ui_disks
		data["file_mode"] = file_mode
		if(current_disk)
			data["up_directory"] = !!current_directory
			data["current_disk"] = current_disk.get_dir_path(current_directory, TRUE)

			if(open_file)
				var/datum/computer_file/F
				F = current_disk.get_file(open_file, current_directory)
				if(!istype(F))
					file_error = "I/O ERROR: Unable to open file."
				else
					data["filename"] = "[F.filename].[F.filetype]"
					if(file_mode == FM_READ)
						var/datum/computer_file/data/data_file = F
						if(!istype(data_file))
							file_error = "I/O ERROR: Unable to open file."
						else
							data["filedata"] = data_file.generate_file_data(user)
					if(file_mode == FM_PERM)
						data |= permmod_data()
			else
				var/list/files[0]
				for(var/datum/computer_file/F in current_disk.get_dir_files(current_directory))
					files.Add(list(list(
						"name" = F.filename,
						"type" = F.filetype,
						"dir" = istype(F, /datum/computer_file/directory),
						"size" = F.size,
						"undeletable" = F.undeletable,
						"unrenamable" = F.unrenamable,
						"unsendable" = F.unsendable
					)))
				data["files"] = files
		else // No disk selected, option to create a new one.
			var/list/avail_disks[0]

			for(var/root_name in computer.mounted_storage)
				var/datum/file_storage/avail_disk = computer.mounted_storage[root_name]

				if(!avail_disk.hidden && avail_disk.check_access(accesses))
					avail_disks.Add(list(list(
						"name" = root_name,
						"desc" = avail_disk.desc,
						"is_network" = istype(avail_disk, /datum/file_storage/network)
					)))

			data["avail_disks"] = avail_disks
		// Don't show transfers that will be over in a tick, screw flickering
		if(current_transfer && current_transfer.get_eta() > 2)
			data |= current_transfer.get_ui_data()

	if(file_error)
		data["file_error"] = file_error

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "file_manager.tmpl", "OS File Manager", 900, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()

/datum/computer_file/program/filemanager/proc/permmod_data()
	var/data = list()

	var/list/current_perm_list // Whatever permissions list we're currently modifying

	var/datum/computer_network/network = computer.get_network()
	var/datum/extension/network_device/acl/access_controller = network?.access_controller
	if(!access_controller)
		file_error = "No access controller was found on the network."
		return data

	switch(current_perm)
		if(OS_READ_ACCESS)
			current_perm_list = f_read_access
			data["current_perm"] = "read"
		if(OS_WRITE_ACCESS)
			current_perm_list = f_write_access
			data["current_perm"] = "write"
		if(OS_MOD_ACCESS)
			current_perm_list = f_mod_access
			data["current_perm"] = "mod"

	var/list/patterns = list()
	var/pattern_index = 0
	for(var/list/pattern in current_perm_list)
		pattern_index++
		patterns.Add(list(list(
			"index" = "[pattern_index]",
			"perm_list" = english_list(pattern, "No groups assigned!", and_text = " or ")
			)))

	data["patterns"] = patterns

	var/list/group_dictionary = access_controller.get_group_dict()
	var/list/parent_groups_data
	var/list/child_groups_data

	var/list/pattern = LAZYACCESS(current_perm_list, selected_pattern)

	if(selected_parent_group)
		if(!(selected_parent_group in group_dictionary))
			selected_parent_group = null
		else
			var/list/child_groups = group_dictionary[selected_parent_group]
			if(child_groups)
				child_groups_data = list()
				for(var/child_group in child_groups)
					child_groups_data.Add(list(list(
						"child_group" = child_group,
						"assigned" = (LAZYISIN(pattern, "[child_group].[network.network_id]"))
					)))
	if(!selected_parent_group) // Check again in case we ended up with a non-existent selected parent group instead of breaking the UI.
		parent_groups_data = list()
		for(var/parent_group in group_dictionary)
			parent_groups_data.Add(list(list(
				"parent_group" = parent_group,
				"assigned" = (LAZYISIN(pattern,"[parent_group].[network.network_id]"))
			)))
	data["parent_groups"] = parent_groups_data
	data["child_groups"] = child_groups_data
	data["selected_parent_group"] = selected_parent_group
	data["selected_pattern"] = "[selected_pattern]"

	return data

/datum/computer_file/program/filemanager/process_tick()
	if(!current_transfer)
		return
	var/result = current_transfer.update_progress()
	if(result != OS_FILE_SUCCESS) //something went wrong
		if(QDELETED(current_transfer)) //either completely
			error = "I/O ERROR: Unknown error during the file transfer."
		else  //or during the saving at the destination
			error = "I/O ERROR: Unable to store '[current_transfer.transferring.filename]' at '[current_transfer.transfer_to.get_dir_path(current_transfer.directory_to, TRUE)]'"
			qdel(current_transfer)
		current_transfer = null
		ui_header = null
		return
	else if(!current_transfer.left_to_transfer)  //done
		QDEL_NULL(current_transfer)
		ui_header = null

/datum/computer_file/program/filemanager/on_file_storage_removal(datum/file_storage/removed)
	var/list/current_disk_list = current_index != null ? disks[current_index] : null
	for(var/list/disk_list in disks)
		var/datum/file_storage/disk = disk_list[1]
		if(disk == removed)
			if(current_disk_list == disk_list)
				current_index = null

			disks -= list(disk_list)

#undef MAX_FILE_PATTERNS
#undef FM_NONE
#undef FM_READ
#undef FM_PERM
