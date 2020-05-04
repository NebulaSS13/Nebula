/datum/computer_network/proc/get_latest_clone_backup(var/mind_id, var/delete_after = FALSE)
	if(!mind_id)
		return
	var/datum/computer_file/data/cloning/latest_file
	var/datum/extension/network_device/mainframe/mainframe
	for(var/datum/extension/network_device/mainframe/M in mainframes_by_role[MF_ROLE_CLONING])
		for(var/datum/computer_file/data/cloning/cloneFile in M.get_all_files())
			if(cloneFile.mind_id == mind_id)
				if(!latest_file || latest_file.backup_date > cloneFile.backup_date)
					if(latest_file)
						M.delete_file(latest_file.filename)
						qdel(latest_file) // Older files can be deleted.
					latest_file = cloneFile
					mainframe = M
	if(delete_after && latest_file)
		mainframe.delete_file(latest_file.filename)
	return latest_file

/obj/machinery/computer/modular/preset/cloning
	default_software = list(
		/datum/computer_file/program/cloning
	)
