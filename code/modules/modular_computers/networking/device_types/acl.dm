/datum/extension/network_device/acl
	connection_type = NETWORK_CONNECTION_WIRED
	var/list/administrators = list()	// A list of numerical user IDs of users that are administrators on a network.

	var/program_control = FALSE			// Whether the ACL controls program access or not.
	var/list/program_access = list()	// List of lists containing perimitted accesses for programs.

/datum/extension/network_device/acl/New()
	. = ..()
	for(var/prog_type in subtypesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = prog_type
		if(!initial(prog.available_on_network))
			continue
		program_access[initial(prog.filename)] = list()

/datum/extension/network_device/acl/proc/add_admin(var/user_id)
	administrators |= user_id

/datum/extension/network_device/acl/proc/rem_admin(var/user_id)
	administrators -= user_id

/datum/extension/network_device/acl/proc/get_grant(var/grant_data)
	var/datum/computer_network/network = get_network()
	if(!network)
		return
	return network.find_file_by_name(grant_data, MF_ROLE_CREW_RECORDS)

/datum/extension/network_device/acl/proc/get_all_grants()
	var/list/grants = list()
	var/datum/computer_network/network = get_network()
	if(!network)
		return grants
	var/list/grant_files = network.get_all_files_of_type(/datum/computer_file/data/grant_record, MF_ROLE_CREW_RECORDS, TRUE)
	for(var/datum/computer_file/data/grant_record/GR in grant_files)
		grants |= GR
	return grants

/datum/extension/network_device/acl/proc/get_program_access(var/program_name)
	if(!length(program_access[program_name]))
		return list()
	. = list()
	for(var/access in program_access[program_name])
		. += uppertext("[network_id].[access]")
	
	return list(.)