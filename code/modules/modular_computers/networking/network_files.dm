/datum/computer_network/proc/find_file_by_name(filename, mainframe_role = MF_ROLE_FILESERVER, mob/user)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, user))
		var/datum/computer_file/F = M.get_file(filename)
		if(F)
			return F

/datum/computer_network/proc/get_all_files_of_type(file_type, mainframe_role = MF_ROLE_FILESERVER, uniques_only = FALSE, mob/user)
	. = list()
	var/list/found_filenames = list()
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, user))
		for(var/datum/computer_file/F in M.get_all_files())
			if(istype(F, file_type))
				if(uniques_only && (F.filename in found_filenames))
					continue
				. |= F
				found_filenames |= F.filename

/datum/computer_network/proc/store_file(datum/computer_file/F, mainframe_role = MF_ROLE_FILESERVER, mob/user)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, user))
		if(M.store_file(F))
			return TRUE

/datum/computer_network/proc/remove_file(datum/computer_file/F, mainframe_role = MF_ROLE_FILESERVER, mob/user)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, user))
		if(M.delete_file(F))
			return TRUE

/datum/computer_network/proc/find_file_location(filename, mainframe_role = MF_ROLE_FILESERVER, mob/user)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(mainframe_role, user))
		var/datum/computer_file/F = M.get_file(filename)
		if(F)
			return M.network_tag

// Reports
/datum/computer_network/proc/fetch_reports(access)
	. = get_all_files_of_type(/datum/computer_file/report)
	if(access)
		for(var/datum/computer_file/report/report in .)
			if(!report.verify_access_edit(access))
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
		if(M.append_to_file("network_log", entry))
			return TRUE

/datum/computer_network/proc/get_log_files()
	. = list()
	for(var/datum/extension/network_device/mainframe/M in mainframes_by_role[MF_ROLE_LOG_SERVER])
		var/logfile = M.get_file("network_log")
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
/datum/computer_network/proc/get_file_server_tags(var/mob/user)
	. = list()
	var/list/mainframes = get_mainframes_by_role(MF_ROLE_FILESERVER) // Do not add permissions check here.
	for(var/datum/extension/network_device/mainframe/M in mainframes)
		if(user && !M.has_access(user))
			continue // We only check if user is provided. If no user is provided, it's assumed to be an admin check.
		. |= M.network_tag

/datum/computer_network/proc/get_file_server_by_role(var/role, var/user)
	if(length(get_mainframes_by_role(role, user)) > 0)
		return get_mainframes_by_role(role, user)[1]
