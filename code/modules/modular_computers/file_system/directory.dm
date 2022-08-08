/datum/computer_file/directory
	filetype = "DIR"
	size = 0

	var/list/held_files = list() // Weakrefs of files held by this directory.
	var/inherit_perms = TRUE

	var/list/temp_file_refs = list() // List used to temporarily hold references to stored files post cloning, so they
									 // don't get GC'd. Cleared on storing or deleting the file.

/datum/computer_file/directory/Destroy()
	for(var/weakref/file_ref in held_files)
		var/datum/computer_file/held_file = file_ref.resolve()
		if(held_file)
			holder.remove_file(held_file, forced = TRUE)
	
	QDEL_NULL(temp_file_refs)
	. = ..()

/datum/computer_file/directory/proc/get_held_files()
	. = list()
	for(var/weakref/file_ref in held_files)
		var/datum/computer_file/held_file = file_ref.resolve()
		if(!held_file)
			held_files -= file_ref
			continue
		. += held_file

// Returns the total file size of held files. We don't override the actual size of the directory so we don't double count file size for capacity.
/datum/computer_file/directory/proc/get_held_size(list/counted_dirs = list())
	. = 0
	counted_dirs |= src // Keep track of files which have been counted in case there's a directory loop.
	for(var/weakref/file_ref in held_files)
		var/datum/computer_file/held_file = file_ref.resolve()
		if(!held_file)
			held_files -= file_ref
			continue
		if(istype(held_file, /datum/computer_file/directory))
			var/datum/computer_file/directory/dir = held_file
			if(dir in counted_dirs)
				continue
			. += dir.get_held_size(counted_dirs)
		else
			. += held_file.size

// Get the permissions for mass file actions, generally:
// * OS_READ_ACCESS on all contained files is required for cloning directories.
// * OS_WRITE_ACCESS on all contained files is required for transferring/deleting directories.
/datum/computer_file/directory/proc/get_held_perms(list/accesses, mob/user, list/counted_dirs = list())
	. = get_file_perms(accesses, user)
	
	if(!accesses || (isghost(user) && check_rights(R_ADMIN, 0, user))) // As with normal file perms, either internal use or admin-ghost usage.
		return

	counted_dirs |= src // As above.
	for(var/weakref/file_ref in held_files)
		var/datum/computer_file/held_file = file_ref.resolve()
		if(!held_file)
			held_files -= file_ref
		
		if(istype(held_file, /datum/computer_file/directory))
			var/datum/computer_file/directory/dir = held_file
			if(dir in counted_dirs)
				continue
			. += dir.get_held_perms(accesses, user, counted_dirs)
		else
			. &= held_file.get_file_perms(accesses, user)
		
		if(. == 0) // We've already lost all permissions, don't bother checking anything else.
			return

/datum/computer_file/directory/get_file_path()
	var/parent_paths = ..()
	if(parent_paths)
		return parent_paths + "/" + filename 
	return filename

/datum/computer_file/directory/clone(var/rename = 0)
	var/datum/computer_file/directory/temp = ..()
	temp.inherit_perms = inherit_perms
	// Add copies of all of our stored files
	for(var/datum/computer_file/stored in get_held_files())
		// Do not rename cloned files.
		var/datum/computer_file/stored_clone = stored.clone(FALSE)
		if(stored_clone)
			temp.held_files += weakref(stored_clone)
			temp.temp_file_refs += stored_clone

	return temp