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
	for(var/datum/extension/network_device/mainframe/MF in network.mainframes_by_role[MF_ROLE_CREW_RECORDS])
		var/obj/item/stock_parts/computer/hard_drive/HDD = MF.get_storage()
		if(!HDD)
			continue
		var/file = HDD.find_file_by_name(grant_data)
		if(file)
			return file

/datum/extension/network_device/acl/proc/get_all_grants()
	var/list/grants = list()
	var/datum/computer_network/network = get_network()
	if(!network)
		return grants
	for(var/datum/extension/network_device/mainframe/MF in network.mainframes_by_role[MF_ROLE_CREW_RECORDS])
		for(var/datum/computer_file/data/grant_record/GR in MF.get_all_files())
			grants |= GR
	return grants