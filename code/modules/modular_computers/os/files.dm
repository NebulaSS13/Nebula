/datum/extension/interactive/os
	var/list/mounted_storage = list() // Dictionary of root name -> /datum/file_storage
	var/programs_dir // For easy reference. Use only with OS filesystem procs.

/datum/extension/interactive/os/system_boot()
	. = ..()
	var/obj/item/stock_parts/computer/hard_drive = get_component(PART_HDD)
	if(hard_drive)
		mounted_storage["local"] = new /datum/file_storage/disk(src, "local")
		programs_dir = "local" + "/" + OS_PROGRAMS_DIR
	var/obj/item/stock_parts/computer/drive_slot/drive_slot = get_component(PART_D_SLOT)
	if(drive_slot)
		mounted_storage["media"] = new /datum/file_storage/disk/removable(src, "media")

	// Auto-run: must happen after storage mount above
	var/datum/computer_file/data/autorun = get_file("autorun", "local")
	if(istype(autorun))
		run_program(autorun.stored_data)

	// Auto-mounted mainframes.
	var/datum/computer_file/data/automount_file = get_file("automount", "local")
	if(istype(automount_file))
		var/list/automounts = splittext(automount_file.stored_data, ";")
		for(var/automount in automounts)
			var/list/automount_split = splittext(automount, "|")
			if(length(automount_split) != 2)
				continue
			var/root_name = automount_split[1]
			var/mainframe_tag = automount_split[2]

			mount_mainframe(root_name, mainframe_tag)

/datum/extension/interactive/os/system_shutdown()
	QDEL_LIST_ASSOC_VAL(mounted_storage)
	. = ..()

// Mounts a new file storage by a given root_name.
/datum/extension/interactive/os/proc/mount_storage(storage_type, root_name, hidden)
	if(!ispath(storage_type, /datum/file_storage) || !length(root_name))
		return

	var/mount_name = root_name
	var/i = 0
	while(mounted_storage[mount_name])
		i++
		mount_name = root_name + "_[i]"

	var/datum/file_storage/new_storage = new storage_type(src, mount_name, hidden)
	mounted_storage[mount_name] = new_storage
	return new_storage

/datum/extension/interactive/os/proc/unmount_storage(root_name)
	var/datum/file_storage/removed = mounted_storage[root_name]
	if(!removed)
		return FALSE

	// Tell programs to clean up any lingering references.
	for(var/datum/computer_file/program/P in running_programs)
		P.on_file_storage_removal(removed)

	mounted_storage[root_name] = null
	mounted_storage -= root_name

	qdel(removed)
	return TRUE

/datum/extension/interactive/os/proc/mount_mainframe(root_name, mainframe_tag)
	var/sanitized_root_name = sanitize_for_file(root_name)
	if(!length(sanitized_root_name))
		return "I/O ERROR: Unable to mount mainframe as file system with root directory '[root_name]'."
	var/datum/computer_network/network = get_network()
	if(!network)
		return "NETWORK ERROR: Cannot connect to network."
	var/datum/extension/network_device/mainframe/mainframe = network.get_device_by_tag(mainframe_tag)
	if(!istype(mainframe))
		return "NETWORK ERROR: No mainframe with network tag '[mainframe_tag]' found."

	var/datum/file_storage/network/created_storage = mount_storage(/datum/file_storage/network, sanitized_root_name, FALSE)
	if(!created_storage)
		return "I/O ERROR: Unable to mount mainframe as file system with root directory '[sanitized_root_name]'."
	created_storage.server = mainframe_tag
	return "Successfully mounted mainframe with network tag '[mainframe_tag]' as file system with root directory '[sanitized_root_name]'."

// Rundown of the filesystem hierarchy:
// The OS creates instances of /datum/file_storage as local or network disks, referenced in its mounted_storage list.
// mounted_storage is keyed by the name of the root directory of the disk.
// Filesystem procs on the OS extension itself expects directory paths with root directories e.g. /local/programs or /network/logs
// Filesystem procs on the file_storage datums and harddrives do not, eg. /programs or /logs

// Returns list(/datum/file_storage, /datum/computer_file/directory) on success, error code on failure. Only supports absolute paths.
// This should not be done every tick for UIs etc. Cache a reference to the directory/file and only re-parse the directory when necessary.
/datum/extension/interactive/os/proc/parse_directory(directory_path, create_directories = FALSE)
	var/list/directories = splittext(directory_path, "/")

	// Cut out any extraneous spaces which may have came from splitting the path
	if(!length(directories[1]))
		directories.Cut(1, 2)
	if(!length(directories[directories.len]))
		directories.Cut(directories.len)

	var/datum/file_storage/storage = mounted_storage[directories[1]]
	if(!storage)
		return OS_DIR_NOT_FOUND
	if(length(directories) == 1) // Root directory of the storage
		return list(storage, null)
	var/datum/computer_file/directory/dir = storage.parse_directory(jointext(directories, "/", 2), create_directories)
	if(!istype(dir)) // Error!
		return dir
	return list(storage, dir)

// Returns list(/datum/file_storage, /datum/computer_file/directory, /datum/computer_file) from the passed path. Only supports absolute paths.
/datum/extension/interactive/os/proc/parse_file(file_path)
	var/list/paths = splittext(file_path, "/")
	if(!length(paths))
		return OS_DIR_NOT_FOUND
	if(!length(paths[1]))
		paths.Cut(1, 2)

	var/list/file_loc = parse_directory(jointext(paths, "/", paths.len))
	if(!islist(file_loc))
		return file_loc
	var/datum/file_storage/storage = file_loc[1]
	var/datum/computer_file/F = storage.get_file(paths[paths.len], file_loc[2])
	if(!istype(F))
		return F
	return list(storage, file_loc[2], F)

/datum/extension/interactive/os/proc/get_all_files(obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	. = list()
	if(disk)
		return disk.stored_files

// Returns the file with the given name in the given directory path. Returns error code on failure.
/datum/extension/interactive/os/proc/get_file(filename, dir_path, list/accesses, mob/user)
	var/list/file_loc = parse_directory(dir_path)
	if(!islist(file_loc))
		return file_loc
	var/datum/file_storage/storage = file_loc[1]
	return storage.get_file(filename, file_loc[2])

// Stores the passed file in the given directory path. Returns OS_FILE_SUCCESS on success, error code on failure.
/datum/extension/interactive/os/proc/store_file(datum/computer_file/file, dir_path, create_directories = FALSE, list/accesses, mob/user, overwrite = TRUE)
	var/list/file_loc = parse_directory(dir_path, create_directories)
	if(!islist(file_loc))
		return file_loc

	var/datum/file_storage/storage = file_loc[1]
	return storage.store_file(file, file_loc[2], create_directories, accesses, user, overwrite)

// Checks if the passed file can be stored in the given directory path without actually storing it. Returns OS_FILE_SUCCESS on success, error code on failure.
/datum/extension/interactive/os/proc/try_store_file(datum/computer_file/file, dir_path, list/accesses, mob/user)
	var/list/file_loc = parse_directory(dir_path)
	if(!islist(file_loc))
		return file_loc

	var/datum/file_storage/storage = file_loc[1]
	return storage.try_store_file(file, file_loc[2], accesses, user)

// Helper for creating a file. Returns file on success, error code on failure.
/datum/extension/interactive/os/proc/create_file(filename, dir_path, data, file_type = /datum/computer_file/data/text, list/metadata, list/accesses, mob/user)
	filename = sanitize_for_file(filename)
	if(!length(filename))
		return OS_BAD_NAME

	var/list/file_loc = parse_directory(dir_path)
	if(!islist(file_loc))
		return file_loc

	var/datum/file_storage/storage = file_loc[1]

	return storage.create_file(filename, file_loc[2], data, file_type, metadata, accesses, user)

// Saves or creates the file with the given name in the passed directory. Returns file on success, error code on failure.
/datum/extension/interactive/os/proc/save_file(filename, dir_path, new_data, file_type = /datum/computer_file/data/text, list/metadata, list/accesses, mob/user)
	filename = sanitize_for_file(filename)
	if(!length(filename))
		return OS_BAD_NAME

	var/list/file_loc = parse_directory(dir_path)
	if(!islist(file_loc))
		return file_loc

	var/datum/file_storage/storage = file_loc[1]
	return storage.save_file(filename, file_loc[2], new_data, metadata, accesses, user, file_type)

// Deletes the file with the given filepath. Returns OS_FILE_SUCCESS on success, error code on failure.
/datum/extension/interactive/os/proc/delete_file(filepath, list/accesses, mob/user)
	var/list/file_loc = parse_file(filepath)
	if(!islist(file_loc))
		return file_loc

	var/datum/file_storage/storage = file_loc[1]
	return storage.delete_file(file_loc[3], file_loc[2], accesses, user)

/datum/extension/interactive/os/proc/clone_file(filename, dir_path, list/accesses, mob/user)
	var/list/file_loc = parse_directory(dir_path)
	if(!islist(file_loc))
		return file_loc

	var/datum/file_storage/storage = file_loc[1]
	return storage.clone_file(filename, file_loc[2], accesses, user)

// Generic file storage interface
/datum/file_storage
	var/desc = "Generic File Interface"
	var/root_name // Display name of the root directory which doesn't exist as an actual directory file.
	var/datum/extension/interactive/os/os
	var/hidden = FALSE // Whether this file storage interface is for internal use.

/datum/file_storage/New(ntos, name, is_hidden)
	os = ntos
	root_name = name
	hidden = is_hidden

/datum/file_storage/Destroy(force)
	os = null
	. = ..()

// Additional check for access on top of file system permissions.
/datum/file_storage/proc/check_access(list/accesses)
	return TRUE

/datum/file_storage/proc/check_errors()
	if(!istype(os))
		return "No compatible device found."

/datum/file_storage/proc/get_transfer_speed()
	return 1

/datum/file_storage/proc/get_all_files()

/datum/file_storage/proc/get_dir_files(datum/computer_file/directory/dir)
	. = list()
	var/list/all_files = get_all_files()
	if(dir && (dir in all_files))
		. = dir.get_held_files()
	else
		// No current directory, get all files which are not held by a directory
		if(!all_files)
			return
		for(var/file in all_files)
			if(!all_files[file]) // No directory associated with the file.
				. += file

	return sortTim(., /proc/cmp_files_sort)

// The following procs should return OS_FILE_SUCCESS on success (or the target file), or error codes on failure.
/datum/file_storage/proc/get_file(filename, directory)

/datum/file_storage/proc/store_file(datum/computer_file/F, directory, create_directories, list/accesses, mob/user, overwrite = TRUE)

/datum/file_storage/proc/try_store_file(datum/computer_file/F, directory, list/accesses, mob/user)

/datum/file_storage/proc/save_file(filename, directory, new_data, list/metadata, list/accesses, mob/user, file_type = /datum/computer_file/data)

/datum/file_storage/proc/delete_file(datum/computer_file/F, list/accesses, mob/user)

/datum/file_storage/proc/create_file(filename, directory, data, file_type = /datum/computer_file/data, list/metadata, list/accesses, mob/user)
	if(check_errors())
		return OS_HARDDRIVE_ERROR

	filename = sanitize_for_file(filename)
	if(!length(filename))
		return OS_BAD_NAME
	var/datum/computer_file/F = new file_type(md = metadata)
	F.filename = filename
	if(istype(F, /datum/computer_file/data))
		var/datum/computer_file/data/FD = F
		FD.calculate_size()
	var/success = store_file(F, directory, FALSE, accesses, user)
	if(success == OS_FILE_SUCCESS)
		return F
	qdel(F)
	return success

/datum/file_storage/proc/create_directory(filename, directory, list/accesses, mob/user)
	return create_file(filename, directory, null, /datum/computer_file/directory, null, accesses, user)

/datum/file_storage/proc/clone_file(filename, directory, list/accesses, mob/user)
	if(check_errors())
		return OS_HARDDRIVE_ERROR
	var/datum/computer_file/F = get_file(filename, directory)
	if(!istype(F))
		return F
	if(!(F.get_file_perms(accesses, user) & OS_READ_ACCESS))
		return OS_FILE_NO_READ

	var/datum/computer_file/cloned_file = F.Clone(TRUE)
	if(!istype(cloned_file))
		return OS_FILE_NO_READ

	var/success = store_file(cloned_file, directory, TRUE, accesses, user)
	if(success != OS_FILE_SUCCESS)
		qdel(cloned_file) // Clean up after ourselves
	return success

/datum/file_storage/proc/get_dir_path(datum/computer_file/directory/current_directory, full)
	if(current_directory)
		if(full)
			return "[root_name]/" + current_directory.get_file_path()
		return current_directory.filename
	return root_name

/datum/file_storage/proc/parse_directory(directory_path, create_directories = FALSE)

// Storing stuff on a server in computer network
/datum/file_storage/network
	desc = "Remote File Server"
	var/server = "NONE"	//network tag of the file server

/datum/file_storage/network/New(ntos, name, hidden, server_tag)
	. = ..()
	if(server_tag)
		server = server_tag

/datum/file_storage/network/check_access(list/accesses)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	if(!M)
		return
	return M.has_access(accesses)

/datum/file_storage/network/check_errors()
	. = ..()
	if(.)
		return
	var/datum/computer_network/network = os.get_network()
	if(!network)
		return "NETWORK ERROR: No connectivity to the network"
	if(!os.get_network_status(NET_FEATURE_FILESYSTEM))
		return "NETWORK ERROR: Network denied filesystem access"
	if(!network.get_device_by_tag(server))
		return "NETWORK ERROR: No connectivity to the file server '[server]'"
	var/datum/extension/network_device/mainframe/M = network.get_device_by_tag(server)
	if(!istype(M))
		return "NETWORK ERROR: Invalid server '[server]', no file sharing capabilities detected"

/datum/file_storage/network/proc/set_server(new_server)
	server = new_server

/datum/file_storage/network/proc/get_mainframe()
	if(check_errors())
		return FALSE
	var/datum/computer_network/network = os.get_network()
	return network.get_device_by_tag(server)

/datum/file_storage/network/get_all_files()
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	return M && M.get_all_files()

/datum/file_storage/network/get_file(filename, directory)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	if(!M)
		return OS_NETWORK_ERROR
	return M.get_file(filename, directory)

/datum/file_storage/network/store_file(datum/computer_file/F, directory, create_directories, list/accesses, mob/user, overwrite = TRUE)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	if(!M)
		return OS_NETWORK_ERROR
	return M.store_file(F, directory, create_directories, accesses, user, overwrite)

/datum/file_storage/network/try_store_file(datum/computer_file/F, directory, list/accesses, mob/user)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	if(!M)
		return OS_NETWORK_ERROR
	return M.try_store_file(F, directory, accesses, user)

/datum/file_storage/network/delete_file(datum/computer_file/F, list/accesses, mob/user)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	if(!M)
		return OS_NETWORK_ERROR
	return M.delete_file(F, accesses, user)

/datum/file_storage/network/save_file(filename, directory, new_data, list/metadata, list/accesses, mob/user, file_type = /datum/computer_file/data)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	if(!M)
		return OS_NETWORK_ERROR
	return M.save_file(filename, directory, new_data, metadata, accesses, user, file_type)

/datum/file_storage/network/parse_directory(directory_path, create_directories)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	if(!M)
		return OS_NETWORK_ERROR
	return M.parse_directory(directory_path, create_directories)

/datum/file_storage/network/get_transfer_speed()
	if(check_errors())
		return 0
	return os.get_network_status(NET_FEATURE_FILESYSTEM)

/*
 * Special subclass for network machines specifically.
 *
 */
/datum/file_storage/network/machine
	var/obj/localhost

/datum/file_storage/network/machine/New(os, machine)
	localhost = machine

/datum/file_storage/network/machine/check_errors()
	// Do not call predecessors. This is a straight up override.
	var/datum/extension/network_device/computer = get_extension(localhost, /datum/extension/network_device)
	var/datum/computer_network/network = computer.get_network()
	if(!network)
		return "NETWORK ERROR: No connectivity to the network"
	if(!network.get_device_by_tag(server))
		return "NETWORK ERROR: No connectivity to the file server '[server]'"
	var/datum/extension/network_device/mainframe/M = network.get_device_by_tag(server)
	if(!istype(M))
		return "NETWORK ERROR: Invalid server '[server]', no file sharing capabilities detected"

/datum/file_storage/network/machine/get_mainframe()
	if(check_errors())
		return FALSE
	var/datum/extension/network_device/computer = get_extension(localhost, /datum/extension/network_device)
	var/datum/computer_network/network = computer.get_network()
	return network.get_device_by_tag(server)

/datum/file_storage/network/machine/get_transfer_speed()
	if(check_errors())
		return 0
	return 1

// Storing stuff locally on some kinda disk
/datum/file_storage/disk
	desc = "Local Storage"
	var/disk_type = PART_HDD

/datum/file_storage/disk/proc/get_disk()
	return os.get_component(disk_type)

/datum/file_storage/disk/check_errors()
	. = ..()
	if(.)
		return
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_disk()
	if(!istype(HDD))
		return "HARDWARE ERROR: No compatible device found"
	if(!HDD.check_functionality())
		return "NETWORK ERROR: [HDD] is non-operational"

/datum/file_storage/disk/get_all_files()
	if(check_errors())
		return FALSE
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_disk()
	return HDD.stored_files

/datum/file_storage/disk/get_file(filename, directory)
	if(check_errors())
		return OS_HARDDRIVE_ERROR
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_disk()
	if(!HDD)
		return OS_HARDDRIVE_ERROR
	return HDD.find_file_by_name(filename, directory)

/datum/file_storage/disk/store_file(datum/computer_file/F, directory, create_directories, list/accesses, mob/user, overwrite = TRUE)
	if(check_errors())
		return OS_HARDDRIVE_ERROR
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_disk()
	if(!HDD)
		return OS_HARDDRIVE_ERROR
	return HDD.store_file(F, directory, create_directories, accesses, user, overwrite)

/datum/file_storage/disk/try_store_file(datum/computer_file/F, directory, list/accesses, mob/user)
	if(check_errors())
		return OS_HARDDRIVE_ERROR
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_disk()
	if(!HDD)
		return OS_HARDDRIVE_ERROR
	return HDD.try_store_file(F, directory, accesses, user)

/datum/file_storage/disk/save_file(filename, directory, new_data, metadata, accesses, user, file_type = /datum/computer_file/data)
	if(check_errors())
		return OS_HARDDRIVE_ERROR
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_disk()
	if(!HDD)
		return OS_HARDDRIVE_ERROR
	return HDD.save_file(filename, directory, new_data, metadata, accesses, user, file_type)

/datum/file_storage/disk/delete_file(datum/computer_file/F, list/accesses, mob/user)
	if(check_errors())
		return OS_HARDDRIVE_ERROR
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_disk()
	if(!HDD)
		return OS_HARDDRIVE_ERROR
	return HDD.remove_file(F, accesses, user)

/datum/file_storage/disk/get_transfer_speed()
	if(check_errors())
		return 0
	return NETWORK_SPEED_DISK

/datum/file_storage/disk/parse_directory(directory_path, create_directories)
	if(check_errors())
		return OS_HARDDRIVE_ERROR
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_disk()
	if(!HDD)
		return OS_HARDDRIVE_ERROR
	return HDD.parse_directory(directory_path, create_directories)

// Storing files on a removable disk.
/datum/file_storage/disk/removable
	desc = "Disk Drive"
	root_name = "media"

/datum/file_storage/disk/removable/get_disk()
	var/obj/item/stock_parts/computer/drive_slot/drive_slot = os.get_component(PART_D_SLOT)
	return drive_slot?.stored_drive

/datum/file_storage/disk/removable/check_errors()
	var/obj/item/stock_parts/computer/drive_slot/drive_slot = os.get_component(PART_D_SLOT)
	if(!istype(drive_slot))
		return "HARDWARE ERROR: No drive slot was found."
	if(!drive_slot.check_functionality())
		return "HARDWARE ERROR: [drive_slot] is non-operational."
	if(!istype(drive_slot.stored_drive))
		return "HARDWARE ERROR: No portable drive inserted."
	. = ..()
	if(.)
		return

// Datum tracking progress between of file transfer between two file streams
/datum/file_transfer
	var/datum/file_storage/transfer_from
	var/datum/file_storage/transfer_to

	var/datum/computer_file/directory/directory_to
	var/datum/computer_file/directory/directory_from

	var/datum/computer_file/transferring
	var/left_to_transfer
	var/copying = FALSE // Whether or not this file transfer is copying, rather than transferring.

/datum/file_transfer/New(datum/file_storage/source, datum/file_storage/destination, datum/computer_file/directory/dest_directory, datum/computer_file/file, copy)
	transfer_from = source
	transfer_to = destination
	transferring = file

	directory_to = dest_directory
	directory_from = file.get_directory()

	if(istype(file, /datum/computer_file/directory))
		var/datum/computer_file/directory/dir = file
		left_to_transfer = dir.get_held_size()
	else
		left_to_transfer = file.size
	copying = copy

/datum/file_transfer/Destroy()
	transfer_from = null
	transfer_to = null

	directory_to = null
	transferring = null
	. = ..()

/datum/file_transfer/proc/check_self()
	if(QDELETED(transfer_from) || QDELETED(transfer_from) || QDELETED(transferring))
		qdel(src)
		return OS_FILE_NOT_FOUND
	return OS_FILE_SUCCESS

//Returns OS_FILE_SUCESS if progress was made and or we are done. Returns error code otherwise.
/datum/file_transfer/proc/update_progress()
	. = check_self()
	if(. != OS_FILE_SUCCESS)
		return
	left_to_transfer = max(0, left_to_transfer - get_transfer_speed())
	if(!left_to_transfer)
		if(copying)
			return transfer_to.store_file(transferring.Clone(), directory_to, TRUE)
		else
			. = transfer_from.delete_file(transferring) // Check if we can delete the file.
			if(. == OS_FILE_SUCCESS)
				. = transfer_to.store_file(transferring, directory_to, FALSE)
				// If we failed to store the file, restore it to its former location.
				if(. != OS_FILE_SUCCESS)
					transfer_from.store_file(transferring, directory_from, FALSE)

/datum/file_transfer/proc/get_transfer_speed()
	if(!check_self())
		return 0
	return min(transfer_from.get_transfer_speed(), transfer_to.get_transfer_speed())

/datum/file_transfer/proc/get_eta()
	if(!check_self() || !get_transfer_speed())
		return INFINITY
	return round(left_to_transfer / get_transfer_speed())

/datum/file_transfer/proc/get_ui_data()
	if(!check_self())
		return
	var/list/data = list()

	data["transfer_from"] = transfer_from.get_dir_path(directory_from, TRUE)
	data["transfer_to"] = transfer_to.get_dir_path(directory_to, TRUE)
	data["transfer_file"] = transferring.filename
	data["transfer_progress"] = transferring.size - left_to_transfer
	data["transfer_total"] = transferring.size
	return data

// Checks permissions for transferring files. Returns error string on failure, null on success.
/proc/check_file_transfer(datum/computer_file/directory/destination, datum/computer_file/file, copy, list/accesses, mob/user)
	if(!file)
		return "Could not locate file"

	if(destination)
		if(!(destination.get_file_perms(accesses, user) & OS_WRITE_ACCESS))
			return "You lack access to the directory [destination.filename]"

	if(file)
		var/req_access = copy ? OS_READ_ACCESS : OS_WRITE_ACCESS
		var/move_string = copy ? "copy" : "transfer"

		if(istype(file, /datum/computer_file/directory))
			var/datum/computer_file/directory/dir = file
			if(!copy)
				if(dir.undeletable)
					return "You lack permission to [move_string] the directory [dir.filename]"
				for(var/datum/computer_file/child in dir.get_held_files())
					if(child.undeletable)
						return "You lack permission to [move_string] the directory [dir.filename]"

			if(!(dir.get_held_perms(accesses, user) & req_access))
				return "You lack permission to [move_string] the directory [dir.filename]"
		else
			if((!copy && file.undeletable) || !(file.get_file_perms(accesses, user) & req_access))
				return "You lack permission to [move_string] the file [file.filename]"