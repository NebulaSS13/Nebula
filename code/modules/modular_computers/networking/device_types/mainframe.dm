GLOBAL_LIST_INIT(all_mainframe_roles, list(MF_ROLE_SOFTWARE, MF_ROLE_FILESERVER, MF_ROLE_EMAIL_SERVER, MF_ROLE_LOG_SERVER, MF_ROLE_CREW_RECORDS, MF_ROLE_CLONING, MF_ROLE_DESIGN))

/datum/extension/network_device/mainframe
	connection_type = NETWORK_CONNECTION_WIRED
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

/datum/extension/network_device/mainframe/proc/get_all_files()
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(HDD)
		return HDD.stored_files

/datum/extension/network_device/mainframe/proc/get_file(filename)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(HDD)
		return HDD.find_file_by_name(filename)

/datum/extension/network_device/mainframe/proc/delete_file(filename)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(HDD)
		var/datum/computer_file/data/F = HDD.find_file_by_name(filename)
		if(!F || F.undeletable)
			return FALSE
		return HDD.remove_file(F)

/datum/extension/network_device/mainframe/proc/store_file(datum/computer_file/file)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return FALSE
	var/datum/computer_file/data/old_version = HDD.find_file_by_name(file.filename)
	if(old_version)
		HDD.remove_file(old_version)
	if(!HDD.store_file(file))
		HDD.store_file(old_version)
		return FALSE
	else
		return TRUE

/datum/extension/network_device/mainframe/proc/save_file(newname, new_data)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return FALSE

	var/datum/computer_file/data/F = HDD.find_file_by_name(newname)
	//Try to save file, possibly won't fit size-wise
	var/datum/computer_file/data/backup
	if(F)
		backup = F.clone()
		HDD.remove_file(F)
	else
		F = new()
	F.stored_data = new_data
	F.calculate_size()
	if(!HDD.store_file(F))
		if(backup)
			HDD.store_file(backup)
		return FALSE
	return TRUE

/datum/extension/network_device/mainframe/proc/append_to_file(filename, data)
	var/obj/item/stock_parts/computer/hard_drive/HDD = get_storage()
	if(!HDD)
		return FALSE
	var/datum/computer_file/data/logfile/F = get_file(filename)
	if(F)
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
	store_file(F)
	return TRUE

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
		if(initial(type.available_on_network))
			store_file(new type)

	for(var/F in subtypesof(/datum/computer_file/program))
		var/datum/computer_file/program/type = F
		if(initial(type.available_on_network))
			store_file(new type)