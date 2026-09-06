/datum/computer_network/proc/find_file_by_name(filename, directory, mainframe_role = MF_ROLE_FILESERVER, list/accesses)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, accesses))
		var/datum/computer_file/F = M.get_file(filename, directory)
		if(istype(F))
			return F

	return OS_FILE_NOT_FOUND

/datum/computer_network/proc/get_all_files_of_type(file_type, mainframe_role = MF_ROLE_FILESERVER, uniques_only = FALSE, list/accesses)
	. = list()
	var/list/found_filenames = list()
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, accesses))
		for(var/datum/computer_file/F in M.get_all_files())
			if(istype(F, file_type))
				if(uniques_only && (F.filename in found_filenames))
					continue
				. |= F
				found_filenames |= F.filename

/datum/computer_network/proc/store_file(datum/computer_file/file, directory, create_directories, list/accesses, mob/user, overwrite = TRUE, mainframe_role = MF_ROLE_FILESERVER)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, accesses))
		if(M.store_file(file, directory, create_directories, accesses, user, overwrite))
			return TRUE

// We don't pass the directory since this is generally used in conjunction with get_all_files_of_type
/datum/computer_network/proc/remove_file(datum/computer_file/F, list/accesses, mob/user, mainframe_role = MF_ROLE_FILESERVER)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, accesses))
		if(M.delete_file(F, accesses, user))
			return TRUE

/datum/computer_network/proc/find_file_location(datum/computer_file/F, list/accesses, mainframe_role = MF_ROLE_FILESERVER)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, accesses))
		if(F in M.get_all_files())
			return M.network_tag

// Reports
/datum/computer_network/proc/fetch_reports(access, mob/user)
	. = get_all_files_of_type(/datum/computer_file/report)
	if(access)
		for(var/datum/computer_file/report/report in .)
			if(!(report.get_file_perms(access, user) & OS_WRITE_ACCESS))
				. -= report

// Software
/datum/computer_network/proc/get_all_software_categories()
	if(all_software_categories)
		return all_software_categories
	all_software_categories = list()
	for(var/T in subtypesof(/datum/computer_file/program))
		var/datum/computer_file/program/P = T
		all_software_categories |= initial(P.category)

/datum/computer_network/proc/get_software_list(category)
	. = get_all_files_of_type(/datum/computer_file/program, MF_ROLE_SOFTWARE, TRUE)
	if(category)
		for(var/datum/computer_file/program/P in .)
			if(category != P.category)
				. -= P

// Logging
/datum/computer_network/proc/add_log(data, source)
	var/entry = "[stationtime2text()] - [source ? source : "*SYSTEM*" ] - "
	entry += data
	for(var/datum/extension/network_device/mainframe/M in mainframes_by_role[MF_ROLE_LOG_SERVER])
		if(M.append_to_file("network_log", OS_LOGS_DIR, entry))
			return TRUE

/datum/computer_network/proc/get_log_files()
	. = list()
	for(var/datum/extension/network_device/mainframe/M in mainframes_by_role[MF_ROLE_LOG_SERVER])
		var/logfile = M.get_file("network_log", OS_LOGS_DIR)
		if(logfile)
			. += logfile

// Crew records
/datum/computer_network/proc/get_crew_records()
	return get_all_files_of_type(/datum/computer_file/report/crew_record, MF_ROLE_CREW_RECORDS)

/datum/computer_network/proc/get_crew_record_by_name(var/name)
	for(var/datum/computer_file/report/crew_record/CR in get_crew_records())
		if(CR.get_name() == name)
			return CR

// Misc helpers
/datum/computer_network/proc/get_file_server_tags(role = MF_ROLE_FILESERVER, list/accesses)
	. = list()
	var/list/mainframes = get_mainframes_by_role(role)
	for(var/datum/extension/network_device/mainframe/M in mainframes)
		if(!M.has_access(accesses))
			continue // We only check if user is provided. If no user is provided, it's assumed to be an admin check.
		. |= M.network_tag

/// Returns the first (order is arbitrarily decided) fileserver with a given mainframe role.
/datum/computer_network/proc/get_file_server_by_role(role, list/accesses)
	if(length(get_mainframes_by_role(role, accesses)) > 0)
		return get_mainframes_by_role(role, accesses)[1]
