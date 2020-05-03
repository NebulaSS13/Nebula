/datum/mind
	// This is a unique UID that will forever identify this mind.
	// No two minds are ever the same, and this ID will always identify 'this character'.
	var/unique_id
	var/age // How old the mob's mind is in years.

/datum/mind/New()
	. = ..()
	unique_id = "[sequential_id("/datum/mind")]"

/datum/mind/proc/show_valid_respawns(var/ckey)
	var/list/valid_clone_pods = list()
	for(var/datum/computer_network/network in GLOB.computer_networks)
		for(var/datum/extension/network_device/cloning_pod/CP in network.devices)
			if(CP.is_valid_respawn(unique_id))
				valid_clone_pods["Backup (DATEGOHERE) - [get_area(CP).name]"] = CP
	
	if(valid_clone_pods.len)
		var/clone_pod_tag = input(usr, "Choose a cloning pod to awaken at:", "Select Cloning Pod") as null|anything in valid_clone_pods
		if(clone_pod_tag)
			var/datum/extension/network_device/cloning_pod/CP = valid_clone_pods[clone_pod_tag]
			if(!CP.is_valid_respawn())
				to_chat(usr, SPAN_WARNING("That cloning pod has become unavailable. Please choose a new cloning pod."))
				return show_valid_respawns(ckey)
			CP.create_character(src, ckey)
			