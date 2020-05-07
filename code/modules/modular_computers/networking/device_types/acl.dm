/datum/extension/network_device/acl
	connection_type = NETWORK_CONNECTION_WIRED
	var/list/administrators = list()	// A list of numerical user IDs of users that are administrators on a network.

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