/datum/extension/interactive/ntos/proc/get_all_files(var/obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	. = list()
	if(disk)
		return disk.stored_files

/datum/extension/interactive/ntos/proc/get_file(filename, var/obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(disk)
		return disk.find_file_by_name(filename)

/datum/extension/interactive/ntos/proc/create_file(var/newname, var/data, var/file_type = /datum/computer_file/data, var/list/metadata, var/obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!newname)
		return
	if(!disk)
		return
	if(get_file(newname))
		return

	var/datum/computer_file/data/F = new file_type(md = metadata)
	F.filename = newname
	F.stored_data = data
	F.calculate_size()
	if(disk.store_file(F))
		return F

/datum/extension/interactive/ntos/proc/store_file(var/datum/computer_file/file, var/obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE
	var/datum/computer_file/data/old_version = disk.find_file_by_name(file.filename)
	if(old_version)
		disk.remove_file(old_version)
	if(!disk.store_file(file))
		disk.store_file(old_version)
		return FALSE
	else
		return TRUE

/datum/extension/interactive/ntos/proc/try_store_file(var/datum/computer_file/file, var/obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE
	return disk.try_store_file(file)

/datum/extension/interactive/ntos/proc/save_file(var/newname, var/data, var/file_type = /datum/computer_file/data, var/list/metadata, var/obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE
	var/datum/computer_file/data/F = disk.find_file_by_name(newname)
	if(!F) //try to make one if it doesn't exist
		return !!create_file(newname, data, file_type, metadata, disk)

	//Try to save file, possibly won't fit size-wise
	var/datum/computer_file/data/backup = F.clone()
	disk.remove_file(F)
	F.stored_data = data
	F.metadata = metadata && metadata.Copy()
	F.calculate_size()
	if(!disk.store_file(F))
		disk.store_file(backup)
		return FALSE
	return TRUE

/datum/extension/interactive/ntos/proc/delete_file(var/filename, var/obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE

	var/datum/computer_file/F = disk.find_file_by_name(filename)
	if(!F || F.undeletable)
		return FALSE

	return disk.remove_file(F)

/datum/extension/interactive/ntos/proc/clone_file(var/filename, var/obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE

	var/datum/computer_file/F = disk.find_file_by_name(filename)
	if(!F)
		return FALSE

	var/datum/computer_file/C = F.clone(1)

	return disk.store_file(C)

/datum/extension/interactive/ntos/proc/copy_between_disks(var/filename, var/obj/item/stock_parts/computer/hard_drive/disk_from, var/obj/item/stock_parts/computer/hard_drive/disk_to)
	if(!istype(disk_from) || !istype(disk_to))
		return FALSE

	var/datum/computer_file/F = disk_from.find_file_by_name(filename)
	if(!istype(F))
		return FALSE
	var/datum/computer_file/C = F.clone(0)
	return disk_to.store_file(C)

// Generic file storage interface
/datum/file_storage
	var/name = "Generic File Interface"
	var/datum/extension/interactive/ntos/os

/datum/file_storage/New(ntos)
	os = ntos

/datum/file_storage/Destroy(force)
	os = null
	. = ..()

/datum/file_storage/proc/check_errors()
	if(!istype(os))
		return "No NTOS compatible device found."

/datum/file_storage/proc/get_transfer_speed()
	return 1

/datum/file_storage/proc/get_all_files()

/datum/file_storage/proc/get_file(filename)

/datum/file_storage/proc/store_file(datum/computer_file/F)

/datum/file_storage/proc/save_file(filename, new_data)

/datum/file_storage/proc/delete_file(filename)

/datum/file_storage/proc/create_file(newname, var/file_type = /datum/computer_file/data/text)
	if(check_errors())
		return FALSE
	var/datum/computer_file/F = new file_type
	F.filename = newname
	var/datum/computer_file/data/FD = F
	if(istype(F, /datum/computer_file/data))
		FD.calculate_size()
	return store_file(F)

/datum/file_storage/proc/clone_file(filename)
	if(check_errors())
		return FALSE
	var/datum/computer_file/F = get_file(filename)
	if(F)
		store_file(F.clone(1))

// Storing stuff on a server in computer network
/datum/file_storage/network
	name = "Remote File Server"
	var/server = "NONE"	//network tag of the file server

/datum/file_storage/network/check_errors()
	. = ..()
	if(.)
		return
	var/datum/computer_network/network = os.get_network()
	if(!network)
		return "NETWORK ERROR: No connectivity to the network"
	if(!network.get_device_by_tag(server))
		return "NETWORK ERROR: No connectivity to the file server '[server]'"
	var/datum/extension/network_device/mainframe/M = network.get_device_by_tag(server)
	if(!istype(M))
		return "NETWORK ERROR: Invalid server '[server]', no file sharing capabilities detected"

/datum/file_storage/network/proc/get_mainframe()
	if(check_errors())
		return FALSE
	var/datum/computer_network/network = os.get_network()
	return network.get_device_by_tag(server)

/datum/file_storage/network/get_all_files()
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	return M && M.get_all_files()

/datum/file_storage/network/get_file(filename)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	return M && M.get_file(filename)

/datum/file_storage/network/store_file(datum/computer_file/F)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	return M && M.store_file(F)

/datum/file_storage/network/delete_file(filename)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	return M && M.delete_file(filename)

/datum/file_storage/network/save_file(filename, new_data)
	var/datum/extension/network_device/mainframe/M = get_mainframe()
	return M && M.save_file(filename, new_data)

/datum/file_storage/network/get_transfer_speed()
	if(check_errors())
		return 0
	return os.get_network_speed()

/*
 * Special subclass for network machines specifically.
 *
 */
/datum/file_storage/network/machine
	var/obj/localhost

/datum/file_storage/network/machine/New(ntos, machine)
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
	name = "Local Storage"
	var/disk_type = PART_HDD

/datum/file_storage/disk/removable
	name = "Disk Drive"
	disk_type = PART_DRIVE

/datum/file_storage/disk/check_errors()
	. = ..()
	if(.)
		return
	var/obj/item/stock_parts/computer/hard_drive/HDD = os.get_component(disk_type)
	if(!HDD)
		return "HARDWARE ERROR: No compatible device found"
	if(!HDD.check_functionality())
		return "NETWORK ERROR: [HDD] is non-operational"

/datum/file_storage/disk/get_all_files()
	if(check_errors())
		return FALSE
	return os.get_all_files(os.get_component(disk_type))

/datum/file_storage/disk/get_file(filename)
	if(check_errors())
		return FALSE
	return os.get_file(filename, os.get_component(disk_type))

/datum/file_storage/disk/store_file(datum/computer_file/F)
	if(check_errors())
		return FALSE
	return os.store_file(F, os.get_component(disk_type))

/datum/file_storage/disk/save_file(filename, new_data)
	if(check_errors())
		return FALSE
	return os.save_file(filename, new_data, os.get_component(disk_type))

/datum/file_storage/disk/delete_file(filename)
	if(check_errors())
		return FALSE
	return os.delete_file(filename, os.get_component(disk_type))

/datum/file_storage/network/get_transfer_speed()
	if(check_errors())
		return 0
	return NETWORK_SPEED_DISK

// Datum tracking progress between of file transfer between two file streams
/datum/file_transfer
	var/datum/file_storage/copying_from
	var/datum/file_storage/copying_to
	var/datum/computer_file/copying
	var/left_to_copy

/datum/file_transfer/New(datum/file_storage/source, datum/file_storage/destination, datum/computer_file/file)
	copying_from = source
	copying_to = destination
	copying = file
	left_to_copy = file.size

/datum/file_transfer/Destroy()
	copying_from = null
	copying_to = null
	copying = null
	. = ..()

/datum/file_transfer/proc/check_self()
	if(QDELETED(copying_from) || QDELETED(copying_from) || QDELETED(copying))
		qdel(src)
		return FALSE
	return TRUE

//Returns FALSE if something went wrong, TRUE if progress was made and or we are done
/datum/file_transfer/proc/update_progress()
	. = check_self()
	if(!.)
		return
	left_to_copy = max(0, left_to_copy - get_transfer_speed())
	if(!left_to_copy)
		return copying_to.store_file(copying)

/datum/file_transfer/proc/get_transfer_speed()
	if(!check_self())
		return 0
	return min(copying_from.get_transfer_speed(), copying_to.get_transfer_speed())

/datum/file_transfer/proc/get_eta()
	if(!check_self() || !get_transfer_speed())
		return INFINITY
	return round(left_to_copy / get_transfer_speed())

/datum/file_transfer/proc/get_ui_data()
	if(!check_self())
		return
	var/list/data = list()
	data["transfer_from"] = copying_from.name
	data["transfer_to"] = copying_to.name
	data["transfer_file"] = copying.filename
	data["transfer_progress"] = copying.size - left_to_copy
	data["transfer_total"] = copying.size
	return data