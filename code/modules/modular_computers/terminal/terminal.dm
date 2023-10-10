// System for a shitty terminal emulator.
/datum/terminal
	var/name = "Terminal"
	var/datum/browser/panel
	var/list/history = list()
	var/list/history_max_length = 20

	var/network_target // Network tag of whatever device is being targeted on the network by commands.

	// Terminal can act as a file transfer utility.
	var/datum/file_storage/current_disk
	var/datum/computer_file/directory/current_directory

	var/datum/file_transfer/current_move

	var/datum/extension/interactive/os/computer
	var/list/disks = list()

/datum/terminal/New(mob/user, datum/extension/interactive/os/computer)
	..()
	src.computer = computer
	if(user && can_use(user))
		show_terminal(user)
	for(var/D in disks)
		disks[D] = new D(computer)
	START_PROCESSING(SSprocessing, src)

/datum/terminal/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(computer && computer.terminals)
		computer.terminals -= src
	computer = null
	current_disk = null
	for(var/D in disks)
		qdel(disks[D])
	disks = null
	if(current_move)
		qdel(current_move)
	if(panel)
		panel.close()
		QDEL_NULL(panel)
	return ..()

/datum/terminal/proc/can_use(mob/user)
	if(!user)
		return FALSE
	if(!CanInteractWith(user, computer, global.default_topic_state))
		return FALSE
	if(!computer || !computer.on)
		return FALSE
	return TRUE

/datum/terminal/Process()
	if(current_move)
		var/result = current_move.update_progress()
		if(result != OS_FILE_SUCCESS)
			if(QDELETED(current_move))
				append_to_history("File Move Cancelled: Unknown error.")
			else
				append_to_history("File Move Cancelled: Unable to store '[current_move.transferring.filename]' at [current_move.transfer_to]")
			QDEL_NULL(current_move)
			return
		if(current_move.left_to_transfer)
			var/completion = round(1 - (current_move.left_to_transfer / current_move.transferring.size), 0.01) * 100
			append_to_history("File Move: [completion]% complete.")
		else
			append_to_history("File Move: Successfully [current_move.copying ? "copied" : "moved"] file '[current_move.transferring.filename]' to '[current_move.transfer_to.get_dir_path(current_move.directory_to, TRUE)]'.")
			QDEL_NULL(current_move)

	if(!can_use(get_user()))
		qdel(src)

/datum/terminal/proc/command_by_name(name)
	for(var/command in get_terminal_commands())
		var/datum/terminal_command/command_datum = command
		if(command_datum.name == name)
			return command

/datum/terminal/proc/get_user()
	if(panel)
		return panel.user

/datum/terminal/proc/show_terminal(mob/user)
	panel = new(user, "terminal-\ref[computer]", name, 500, 546, src)
	update_content()
	panel.open()

/datum/terminal/proc/update_content()
	var/list/content = history.Copy()
	var/account_name
	// current_account will be reset on access check if account look up fails.
	var/datum/extension/interactive/os/account_computer = get_account_computer()
	if(account_computer.login && account_computer.current_account)
		var/datum/computer_network/network = account_computer.get_network()
		if(network)
			account_name = "[account_computer.login]@[network.network_id]"
		else
			account_name = "LOCAL"
	else
		account_name = "GUEST"
	content += "<form action='byond://'><input type='hidden' name='src' value='\ref[src]'>>[account_name]:/[current_disk?.get_dir_path(current_directory, TRUE)]<input type='text' size='40' name='input' autofocus><input type='submit' value='Enter'></form>"
	content += "<i>type `man` for a list of available commands.</i>"
	panel.set_content("<tt>[jointext(content, "<br>")]</tt>")

/datum/terminal/Topic(href, href_list)
	if(..())
		return 1
	if(!can_use(usr) || href_list["close"])
		qdel(src)
		return 1
	if(href_list["input"])
		var/input = sanitize(href_list["input"])
		history += "> [input]"
		var/output = parse(input, usr)
		if(QDELETED(src)) // Check for exit.
			return 1
		append_to_history(output)
		return 1

/datum/terminal/proc/append_to_history(var/text)
	if(length(text))
		history += text
		if(length(history) > history_max_length)
			history.Cut(1, length(history) - history_max_length + 1)
	update_content()
	panel.update()

/datum/terminal/proc/parse(text, mob/user)
	if(current_move)
		return "File transfer in progress."
	if(user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		for(var/datum/terminal_command/command in get_terminal_commands())
			. = command.parse(text, user, src)
			if(!isnull(.))
				return
	else
		. = skill_critical_fail(user)
		if(!isnull(.)) // If it does something silently, we give generic text.
			return
	return "Command [text] not found."

/datum/terminal/proc/skill_critical_fail(user)
	var/list/candidates = list()
	for(var/datum/terminal_skill_fail/scf in get_terminal_fails())
		if(scf.can_run(user, src))
			candidates[scf] = scf.weight
	var/datum/terminal_skill_fail/chosen = pickweight(candidates)
	return chosen.execute(src)

// Returns the computer used for the terminal's account
/datum/terminal/proc/get_account_computer()
	return computer

/datum/terminal/proc/get_access(mob/user)
	var/datum/extension/interactive/os/account_computer = get_account_computer()
	return(account_computer.get_access(user))

// Returns list(/datum/file_storage, directory) on success. Returns error code on failure.
/datum/terminal/proc/parse_directory(directory_path, create_directories = FALSE)
	var/datum/file_storage/target_disk = current_disk
	var/datum/computer_file/directory/root_dir = current_directory
	
	if(!length(directory_path))
		return list(target_disk, root_dir)

	if(directory_path[1] == "/") // This is an absolute path, so we can pass it directly to the OS proc to be processed.
		return computer.parse_directory(directory_path, create_directories)

	// Otherwise, we append the working directory path to the passed path.
	var/list/directories = splittext(directory_path, "/")
	
	// When splitting the text, there could be blank strings at either end, so remove them. If there's any in the body of the path, there was a 
	// missed input, so leave them.
	if(!length(directories[1]))
		directories.Cut(1, 2)
	if(!length(directories[directories.len]))
		directories.Cut(directories.len)

	for(var/dir in directories)
		if(dir == "..") // Up a directory.
			if(root_dir)
				root_dir = root_dir.get_directory()
				directories.Cut(1, 2)
				continue
			if(target_disk)
				target_disk = null
				directories.Cut(1, 2)
				continue
			// We're trying to move up past the mounting points, return failure.
			return OS_DIR_NOT_FOUND

		if(!target_disk)
			target_disk = computer.mounted_storage[dir]
			if(!target_disk) // Invalid disk entered.
				return OS_DIR_NOT_FOUND
			directories.Cut(1, 2)
			
		break // Any further use of ../ is handled by the hard drive.

	// If we were only pathing to the parent of a directory or to a disk, we can return early.
	if(!length(directories))
		return list(target_disk, root_dir)

	// Assemble the final path from whatever root directory we're in, and the remaining entered paths.
	// The hard drive handles the rest.
	var/final_path = root_dir ? root_dir.get_file_path()  + "/" : ""
	final_path += jointext(directories, "/")
	var/datum/computer_file/directory/target_directory = target_disk.parse_directory(final_path, create_directories)
	if(!istype(target_directory))
		return OS_DIR_NOT_FOUND
	
	return list(target_disk, target_directory)

// Returns list(/datum/file_storage, /datum/computer_file/directory, /datum/computer_file) on success. Returns error code on failure.
/datum/terminal/proc/parse_file(file_path)
	if(!length(file_path))
		return OS_FILE_NOT_FOUND
	if(file_path[1] == "/") // As above, this is an absolute path, which the OS can handle directly.
		return computer.parse_file(file_path)

	var/list/dirs_and_file = splittext(file_path, "/")
	if(!length(dirs_and_file))
		return OS_DIR_NOT_FOUND
	
	// Join together everything but the filename into a path.
	var/list/file_loc = parse_directory(jointext(dirs_and_file, "/", 1, dirs_and_file.len))
	if(!islist(file_loc)) // Errored!
		return file_loc

	var/datum/file_storage/target_disk = file_loc[1]
	var/datum/computer_file/directory/target_dir = file_loc[2]
	if(!istype(target_disk))
		return OS_DIR_NOT_FOUND
	
	var/filename = dirs_and_file[dirs_and_file.len]
	var/datum/computer_file/target_file = target_disk.get_file(filename, target_dir)
	if(!istype(target_file))
		return OS_FILE_NOT_FOUND

	return list(target_disk, target_dir, target_file)

/proc/get_terminal_error(path, error_code)
	var/list/dirs_and_file = splittext(path, "/")
	var/dir_path = jointext(dirs_and_file, "/", 1, dirs_and_file.len)
	if(!length(dirs_and_file))
		return "Unable to parse passed path."
	var/filename = dirs_and_file[dirs_and_file.len]

	switch(error_code)
		if(OS_FILE_NOT_FOUND)
			return "Unable to locate the file[length(filename) ? "'[filename]'" : ""]"
		if(OS_DIR_NOT_FOUND)
			return "Unable to locate the directory[length(dir_path) ? "'[dir_path]'" : ""]"
		if(OS_FILE_EXISTS)
			return "A file with name '[filename]' already exists"
		if(OS_BAD_NAME)
			return "The file name '[filename]' is invalid"
		if(OS_FILE_NO_READ)
			return "You do not have permission to read the file[length(filename) ? "'[filename]'" : ""]"
		if(OS_FILE_NO_WRITE)
			return "You do not have permission to modify the file[length(filename) ? "'[filename]'" : ""]"
		if(OS_HARDDRIVE_SPACE)
			return "Insufficient harddrive space"
		if(OS_HARDDRIVE_ERROR)
			return "I/O error, Harddrive may be non-functional"
		if(OS_NETWORK_ERROR)
			return "Unable to connect to the network"
	
	return "An unspecified error occured."