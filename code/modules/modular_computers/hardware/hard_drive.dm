/obj/item/stock_parts/computer/hard_drive
	name = "basic hard drive"
	desc = "A small power efficient solid state drive, with 128GQ of storage capacity for use in basic computers where power efficiency is desired."
	power_usage = 25					// SSD or something with low power usage
	icon_state = "hdd_normal"
	hardware_size = 1
	origin_tech = "{'programming':1,'engineering':1}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	var/max_capacity = 128
	var/used_capacity = 0
	var/list/stored_files = list()		// Dictionary of stored files on this drive, with file->weakref of directory. DO NOT MODIFY DIRECTLY!

/obj/item/stock_parts/computer/hard_drive/advanced
	name = "advanced hard drive"
	desc = "A small hybrid hard drive with 256GQ of storage capacity for use in higher grade computers where balance between power efficiency and capacity is desired."
	max_capacity = 256
	origin_tech = "{'programming':2,'engineering':2}"
	power_usage = 50 					// Hybrid, medium capacity and medium power storage
	icon_state = "hdd_advanced"
	hardware_size = 2
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/stock_parts/computer/hard_drive/super
	name = "super hard drive"
	desc = "A small hard drive with 512GQ of storage capacity for use in cluster storage solutions where capacity is more important than power efficiency."
	max_capacity = 512
	origin_tech = "{'programming':3,'engineering':3}"
	power_usage = 100					// High-capacity but uses lots of power, shortening battery life. Best used with APC link.
	icon_state = "hdd_super"
	hardware_size = 2
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/stock_parts/computer/hard_drive/cluster
	name = "cluster hard drive"
	desc = "A large storage cluster consisting of multiple hard drives for usage in high capacity storage systems. Has capacity of 2048 GQ."
	power_usage = 500
	origin_tech = "{'programming':4,'engineering':4}"
	max_capacity = 2048
	icon_state = "hdd_cluster"
	hardware_size = 3
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

// For tablets, etc. - highly power efficient.
/obj/item/stock_parts/computer/hard_drive/small
	name = "small hard drive"
	desc = "A small highly efficient solid state drive for portable devices."
	power_usage = 10
	origin_tech = "{'programming':2,'engineering':2}"
	max_capacity = 64
	icon_state = "hdd_small"
	hardware_size = 1
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/stock_parts/computer/hard_drive/micro
	name = "micro hard drive"
	desc = "A small micro hard drive for portable devices."
	power_usage = 2
	origin_tech = "{'programming':1,'engineering':1}"
	max_capacity = 32
	icon_state = "hdd_micro"
	hardware_size = 1
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/stock_parts/computer/hard_drive/diagnostics()
	. = ..()
	// 999 is a byond limit that is in place. It's unlikely someone will reach that many files anyway, since you would sooner run out of space.
	. += "NFS File Table Status: [stored_files.len]/999"
	. += "Storage capacity: [used_capacity]/[max_capacity]GQ"

/obj/item/stock_parts/computer/hard_drive/Initialize()
	. = ..()
	install_default_programs()

/obj/item/stock_parts/computer/hard_drive/Destroy()
	stored_files = null
	return ..()

// Add programs that the disk will spawn with
/obj/item/stock_parts/computer/hard_drive/proc/install_default_programs()
	var/datum/computer_file/directory/program_directory = add_directory(OS_PROGRAMS_DIR)
	program_directory.unrenamable = TRUE // Protect the program directory from renaming/deletion.
	program_directory.undeletable = TRUE
	store_file(new/datum/computer_file/program/computerconfig(src), program_directory) 		// Computer configuration utility, allows hardware control and displays more info than status bar
	store_file(new/datum/computer_file/program/appdownloader(src), program_directory) 		// Downloader Utility, allows users to download more software from loca repositories
	store_file(new/datum/computer_file/program/filemanager(src), program_directory)			// File manager, allows text editor functions and basic file manipulation.
	return program_directory

// Use this proc to add file to the drive. Returns OS_FILE_SUCCESS on success and error codes on failure. Contains necessary sanity checks.
/obj/item/stock_parts/computer/hard_drive/proc/store_file(var/datum/computer_file/F, var/directory, var/create_directories = FALSE, var/list/accesses, var/mob/user, var/overwrite = TRUE)
	var/datum/computer_file/directory/target = parse_directory(directory, create_directories)
	if(!istype(target) && directory) // The directory could not be parsed or created
		return target
	var/store_file = try_store_file(F, target, accesses, user)
	if(store_file != OS_FILE_SUCCESS)
		if(store_file == OS_FILE_EXISTS)
			if(!overwrite)
				return store_file
			// Remove the duplicate file.
			var/datum/computer_file/old = find_file_by_name(F.filename, target)
			if(!istype(old)) // Something went wrong since we already found this file earlier.
				return OS_HARDDRIVE_ERROR

			var/removed = remove_file(old, accesses, user)
			if(removed != OS_FILE_SUCCESS)
				return removed // Return the error code from removing the file.

			// If we've reached this point, we are able to store the file, since we successfully removed the old version.
			// try_store_file() is intentionally written so that existing file checks are returned only if all other checks pass.
		else
			return store_file
	if(istype(F, /datum/computer_file/directory))
		var/datum/computer_file/directory/dir = F
		for(var/datum/computer_file/child in dir.get_held_files())
			stored_files[child] = dir
			child.holder = weakref(src)

		dir.temp_file_refs.Cut() // No longer need these references to the directory's stored files.

	F.holder = weakref(src)
	if(target)
		if(target.inherit_perms) // Add the permissions of the directory to the file's.
			if(LAZYLEN(target.read_access))
				LAZYDISTINCTADD(F.read_access, target.read_access)
			if(LAZYLEN(target.write_access))
				LAZYDISTINCTADD(F.write_access, target.write_access)
			if(LAZYLEN(target.mod_access))
				LAZYDISTINCTADD(F.mod_access, target.mod_access)
		stored_files[F] = target
		target.held_files += weakref(F)
	else
		stored_files += F
	recalculate_size()
	return OS_FILE_SUCCESS

// Use this proc to remove file from the drive. Returns OS_FILE_SUCCESS on success and error codes on failure. Contains necessary sanity checks.
/obj/item/stock_parts/computer/hard_drive/proc/remove_file(var/datum/computer_file/F, list/accesses, mob/user, forced)
	if(!istype(F) || !(F in stored_files))
		return OS_FILE_NOT_FOUND

	if(!stored_files)
		return OS_HARDDRIVE_ERROR

	if(!forced)
		if(!check_functionality())
			return OS_HARDDRIVE_ERROR

		if(F.undeletable)
			return OS_FILE_NO_WRITE

		if(!(F.get_file_perms(accesses, user) & OS_WRITE_ACCESS))
			return OS_FILE_NO_WRITE

	var/list/removed_files = list(F)

	if(istype(F, /datum/computer_file/directory))
		var/datum/computer_file/directory/dir = F
		var/list/dir_files = dir.get_held_files()
		if(!forced)
			if(!(dir.get_held_perms(accesses, user) & OS_WRITE_ACCESS))
				return OS_FILE_NO_WRITE
			for(var/datum/computer_file/child in dir_files)
				if(child.undeletable)
					return OS_FILE_NO_WRITE
		removed_files |= dir_files

		// Store references to the removed files temporarily to prevent them being GC'd, in case we're
		// transferring this directory elsewhere.
		dir.temp_file_refs += dir_files

	for(var/datum/computer_file/removed in removed_files)
		var/datum/computer_file/directory/dir = stored_files[removed]

		// File is being removed without the directory, they're going their seperate ways.
		if(dir && !(dir in removed_files))
			dir.held_files -= weakref(removed)
			dir.temp_file_refs -= removed
		stored_files -= removed
		removed.holder = null
	recalculate_size()
	return OS_FILE_SUCCESS

// Saves a file, either overwriting the data of a previous file or saving a new one.
/obj/item/stock_parts/computer/hard_drive/proc/save_file(filename, directory, new_data, list/metadata, list/accesses, mob/user, file_type = /datum/computer_file/data)
	var/datum/computer_file/F = find_file_by_name(filename, directory)

	if(istype(F) && !(F.get_file_perms(accesses, user) & OS_WRITE_ACCESS))
		return OS_FILE_NO_WRITE
	//Try to save file, possibly won't fit size-wise
	var/datum/computer_file/backup
	if(istype(F))
		backup = F.Clone()
		remove_file(F)
	else
		F = new file_type()
	F.filename = filename
	if(istype(F, /datum/computer_file/data))
		var/datum/computer_file/data/D = F
		D.stored_data = new_data
		D.calculate_size()
	F.metadata = metadata && metadata.Copy()

	var/success = store_file(F, directory, FALSE, accesses, user)
	if(success != OS_FILE_SUCCESS)
		if(backup)
			store_file(backup, directory)
		return success

	if(backup)
		qdel(backup)
	return F

// Loops through all stored files and recalculates used_capacity of this drive
/obj/item/stock_parts/computer/hard_drive/proc/recalculate_size()
	var/total_size = 0
	for(var/datum/computer_file/F in stored_files)
		total_size += F.size

	used_capacity = total_size

// Checks whether file can be stored on the hard drive.
/obj/item/stock_parts/computer/hard_drive/proc/can_store_file(var/size = 1)
	// In the unlikely event someone manages to create that many files.
	// BYOND is acting weird with numbers above 999 in loops (infinite loop prevention)
	if(stored_files.len >= 999)
		return FALSE
	if(used_capacity + size > max_capacity)
		return FALSE
	else
		return TRUE

// Checks whether we can store the file. We can only store unique files, so this checks whether we wouldn't get a duplicity by adding a file.
// Storing a file in a directory requires write access to that directory.
/obj/item/stock_parts/computer/hard_drive/proc/try_store_file(var/datum/computer_file/F, var/directory, var/list/accesses, var/mob/user)
	if(!istype(F))
		return OS_FILE_NOT_FOUND

	var/file_size = F.size
	if(istype(F, /datum/computer_file/directory))
		var/datum/computer_file/directory/dir = F
		file_size += dir.get_held_size()

	if(!can_store_file(file_size))
		return OS_HARDDRIVE_SPACE
	if(!check_functionality())
		return OS_HARDDRIVE_ERROR
	if(!stored_files)
		return OS_HARDDRIVE_ERROR

	// Safety check
	F.filename = sanitize_for_file(F.filename)

	var/datum/computer_file/directory/D = parse_directory(directory)
	if(directory && !D)
		return OS_DIR_NOT_FOUND
	if(D && !(D.get_held_perms(accesses, user) & OS_WRITE_ACCESS))
		return OS_FILE_NO_WRITE

	// We intentionally check these two cases last so that if we are overwriting the file, we are sure
	// to be able to store it once we remove the old version.

	// This file is already stored. Don't store it again.
	if(F in stored_files)
		return OS_FILE_EXISTS
	// Fail on finding a file with a duplicate name.
	if(!isnum(find_file_by_name(F.filename, D, TRUE)))
		return OS_FILE_EXISTS
	return OS_FILE_SUCCESS

// Tries to find file by filename. Returns error code on failure
/obj/item/stock_parts/computer/hard_drive/proc/find_file_by_name(var/filename, var/directory, var/forced)
	if(!forced && !check_functionality())
		return OS_HARDDRIVE_ERROR

	if(!filename)
		return OS_FILE_NOT_FOUND

	if(!stored_files)
		return OS_HARDDRIVE_ERROR

	var/datum/computer_file/directory/target = parse_directory(directory)

	if(istype(target))
		var/list/held_files = target.get_held_files()
		for(var/datum/computer_file/file in held_files)
			// Filename uniqueness is enforced even if filetype is not the same, so allow
			// users to access files either by the filename alone or with the filetype.
			if(file.filename == filename || (file.filename + "." + file.filetype) == filename)
				return file
	else
		if(directory)
			return target
		// Check in files not in a directory.
		for(var/datum/computer_file/file in stored_files)
			if(stored_files[file] != null) // Ignore files in a directory.
				continue
			if(file.filename == filename || (file.filename + "." + file.filetype) == filename)
				return file
	return OS_FILE_NOT_FOUND

/obj/item/stock_parts/computer/hard_drive/proc/add_directory(var/directory, var/check_for_existing = TRUE)
	if(check_for_existing)
		var/datum/computer_file/directory/existing = parse_directory(directory)
		if(istype(existing))
			return existing

	var/list/directories = splittext(directory, "/")
	if(!length(directories))
		return OS_DIR_NOT_FOUND
	var/new_directory = sanitize_for_file(directories[directories.len])
	if(!length(new_directory))
		return OS_BAD_NAME
	directories.Cut(directories.len) // Remove the final directory.

	var/datum/computer_file/directory/new_dir = new()
	new_dir.filename = new_directory
	if(!length(directories))
		var/success = store_file(new_dir)
		if(success != OS_FILE_SUCCESS)
			return success
		return new_dir
	else // Add directories until the final one is added.
		var/datum/computer_file/directory/parent_dir = add_directory(jointext(directories, "/"))
		var/success = store_file(new_dir, parent_dir)
		if(success != OS_FILE_SUCCESS)
			return success
		return new_dir

/obj/item/stock_parts/computer/hard_drive/proc/parse_directory(var/directory, var/create_directories = FALSE)
	if(istype(directory, /datum/computer_file/directory))
		if(directory in stored_files)
			return directory
		return OS_DIR_NOT_FOUND
	if(istext(directory))
		var/list/directories = splittext(directory, "/")
		var/datum/computer_file/directory/current_dir
		if(!length(directories))
			return OS_DIR_NOT_FOUND
		directory_loop:
			for(var/directory_name in directories)
				if(directory_name == "..")
					directories.Cut(1, 2)
					if(!current_dir)
						return OS_DIR_NOT_FOUND
					current_dir = current_dir.get_directory()
					continue
				var/list/file_list = current_dir ? current_dir.get_held_files() : stored_files
				for(var/datum/computer_file/directory/D in file_list)
					if(D.filename == directory_name)
						directories.Cut(1, 2)
						current_dir = D
						. = D
						continue directory_loop
				// Found a missing directory.
				if(create_directories)
					var/final_path = current_dir ? current_dir.get_file_path() + "/" : ""
					final_path += jointext(directories, "/")
					return add_directory(final_path)
				else
					return OS_DIR_NOT_FOUND

// Preset for borgs and AIs
/obj/item/stock_parts/computer/hard_drive/silicon/install_default_programs()
	var/datum/computer_file/directory/program_directory = ..()
	store_file(new/datum/computer_file/program/records(), program_directory)
	store_file(new/datum/computer_file/program/crew_manifest(), program_directory)
	store_file(new/datum/computer_file/program/email_client(), program_directory)
	store_file(new/datum/computer_file/program/suit_sensors(), program_directory)