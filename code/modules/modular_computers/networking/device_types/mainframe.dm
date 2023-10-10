var/global/list/all_mainframe_roles = list(
	MF_ROLE_SOFTWARE,
	MF_ROLE_FILESERVER,
	MF_ROLE_LOG_SERVER,
	MF_ROLE_CREW_RECORDS,
	MF_ROLE_ACCOUNT_SERVER
)

/datum/extension/network_device/mainframe
	expected_type = /obj/machinery
	var/max_log_count = 100
	var/list/roles = list()

/datum/extension/network_device/mainframe/proc/toggle_role(role)
	if(role in roles)
		roles -= role
	else
		roles += role
	update_roles()

/datum/extension/network_device/mainframe/proc/update_roles()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net)
		return FALSE
	if(!check_connection())
		return FALSE
	net.update_mainframe_roles(src)

/datum/extension/network_device/mainframe/proc/get_storage()
	var/obj/machinery/M = holder
	if(istype(M))
		return M.get_component_of_type(/obj/item/stock_parts/computer/hard_drive)

// File storage procs
/datum/extension/network_device/mainframe/proc/get_all_files()
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(HDD)
		return HDD.stored_files

/datum/extension/network_device/mainframe/proc/get_file(filename, directory)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(HDD)
		return HDD.find_file_by_name(filename, directory)

/datum/extension/network_device/mainframe/proc/delete_file(datum/computer_file/F, list/accesses, mob/user)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(HDD)
		return HDD.remove_file(F, accesses, user)

/datum/extension/network_device/mainframe/proc/store_file(datum/computer_file/file, directory, create_directories, list/accesses, mob/user, overwrite = TRUE)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return OS_HARDDRIVE_ERROR

	return HDD.store_file(file, directory, create_directories, accesses, user, overwrite)

/datum/extension/network_device/mainframe/proc/try_store_file(datum/computer_file/file, directory, list/accesses, mob/user)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return OS_HARDDRIVE_ERROR

	return HDD.try_store_file(file, directory, accesses, user)

/datum/extension/network_device/mainframe/proc/save_file(newname, directory, new_data, list/metadata, list/accesses, mob/user)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return OS_HARDDRIVE_ERROR
	return HDD.save_file(newname, directory, new_data, metadata, accesses, user)

/datum/extension/network_device/mainframe/proc/parse_directory(directory_path, create_directories)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return OS_HARDDRIVE_ERROR

	return HDD.parse_directory(directory_path, create_directories)

/datum/extension/network_device/mainframe/proc/append_to_file(filename, directory, data)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return OS_HARDDRIVE_ERROR
	var/datum/computer_file/data/logfile/F = get_file(filename, directory)
	if(istype(F))
		var/list/logs = splittext(F.stored_data, "\[br\]")
		logs.Add(data)
		if(length(logs) > max_log_count)
			logs.Cut(1, 1 + length(logs) - max_log_count)
		F.stored_data = jointext(logs, "\[br\]")
		F.calculate_size()
	else
		F = new()
		F.filename = filename
		F.stored_data = data
	return store_file(F, directory)

/datum/extension/network_device/mainframe/proc/get_capacity()
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return 0
	return HDD.max_capacity

/datum/extension/network_device/mainframe/proc/get_used()
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return 0
	return HDD.used_capacity

// Disk that spawns with everything old system had
/obj/item/stock_parts/computer/hard_drive/cluster/fullhouse/Initialize()
	. = ..()

	for(var/F in subtypesof(/datum/computer_file/report))
		var/datum/computer_file/report/type = F
		if(TYPE_IS_ABSTRACT(type))
			continue
		if(initial(type.available_on_network))
			store_file(new type, "reports", TRUE)

	for(var/F in subtypesof(/datum/computer_file/program))
		var/datum/computer_file/program/type = F
		if(TYPE_IS_ABSTRACT(type))
			continue
		if(initial(type.available_on_network))
			store_file(new type, OS_PROGRAMS_DIR, TRUE)