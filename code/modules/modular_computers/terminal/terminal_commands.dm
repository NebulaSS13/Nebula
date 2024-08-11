// To cut down on unneeded creation/deletion, these are global.
var/global/list/terminal_commands
/proc/get_terminal_commands()
	if(!global.terminal_commands)
		global.terminal_commands = init_subtypes(/datum/terminal_command)
	return global.terminal_commands

/datum/terminal_command
	var/name                              // Used for man
	var/man_entry                         // Shown when man name is entered. Can be a list of strings, which will then be shown on separate lines.
	var/pattern                           // Matched using regex
	var/regex_flags                       // Used in the regex
	var/regex/regex                       // The actual regex, produced from above.
	var/core_skill = SKILL_COMPUTER       // The skill which is checked
	var/skill_needed = SKILL_ADEPT        // How much skill the user needs to use this. This is not for critical failure effects at unskilled; those are handled globally.
	var/req_access = list()               // Stores access needed, if any
	var/needs_network					  // If this command fails if computer running terminal isn't connected to a network
	var/needs_network_feature			  // Network feature flags which are required by this command.

	var/static/regex/nid_regex			  // Regex for getting network addres out of the line

/datum/terminal_command/New()
	regex = new (pattern, regex_flags)
	..()

/datum/terminal_command/proc/check_access(list/access)
	return has_access(req_access, access)

/datum/terminal_command/proc/get_nid(text)
	if(!nid_regex)
		nid_regex = regex(@"\w\w-\w\w-\w\w-\w\w")
	if(nid_regex.Find(text))
		return uppertext(nid_regex.match)

/datum/terminal_command/proc/get_arguments(text)
	var/argtext = copytext(text, length(pattern) + 1)

	var/cur_string = ""
	var/list/arguments = list()

	var/last_was_escape = FALSE
	for(var/i in 1 to length(argtext)) // Allow players to escape spaces by using '\'.
		var/char = argtext[i]
		if(char == "\\")
			last_was_escape = TRUE
			continue
		last_was_escape = FALSE
		if(char == " ")
			if(!last_was_escape) // Space wasn't escaped.
				if(length(cur_string))
					arguments += cur_string
				cur_string = ""
				continue
		cur_string += char

	if(length(cur_string))
		arguments += cur_string
	return arguments

// null return: continue. "" return will break and show a blank line. Return list() to break and not show anything.
/datum/terminal_command/proc/parse(text, mob/user, datum/terminal/terminal)
	if(!findtext(text, regex))
		return
	if(!user.skill_check(core_skill, skill_needed))
		return skill_fail_message()
	if(!check_access(terminal.get_access(user)))
		return "[name]: ACCESS DENIED"
	if(needs_network && !terminal.computer.get_network_status())
		return "NETWORK ERROR: Check connection and try again."
	if(needs_network_feature && !terminal.computer.get_network_status(needs_network_feature))
		return "NETWORK ERROR: Network rejected the use of this command on your current connection."

	return proper_input_entered(text, user, terminal)

//Should not return null unless you want parser to continue.
/datum/terminal_command/proc/proper_input_entered(text, mob/user, terminal)
	return list()

// Prints data out, split by page number.
/datum/terminal_command/proc/print_as_page(list/data, value_name, selected_page, pg_length)
	. = list()
	var/max_pages = ceil(length(data)/pg_length)
	var/pg = clamp(selected_page, 1, max_pages)

	var/start_index = (pg - 1)*pg_length + 1
	var/end_index = min(length(data), pg*pg_length) + 1

	. += data.Copy(start_index, end_index)
	. += "[length(data)] [value_name]\s. Page [pg] / [max_pages]."

/datum/terminal_command/proc/skill_fail_message()
	var/message = pick(list(
		"Possible encoding mismatch detected.",
		"Update packages found; download suggested.",
		"No such option found.",
		"Flag mismatch."
	))
	return list("Command not understood.", message)
/*
Subtypes
*/
/datum/terminal_command/exit
	name = "exit"
	man_entry = list("Format: exit", "Exits terminal immediately.")
	pattern = @"^exit$"
	skill_needed = SKILL_BASIC

/datum/terminal_command/exit/proper_input_entered(text, mob/user, terminal)
	qdel(terminal)
	return list()

/datum/terminal_command/man
	name = "man"
	man_entry = list("Format: man \[pg number / command\]", "Without command specified, shows list of available commands, starting at the page number.", "With command, provides instructions on command use.")
	pattern = @"^man"

/datum/terminal_command/man/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/manargs = get_arguments(text)
	if(!length(manargs) || isnum(text2num(manargs[1])))
		var/selected_page = (length(manargs)) ? text2num(manargs[1]) : 1

		var/list/valid_commands = list()
		for(var/comm in get_terminal_commands())
			var/datum/terminal_command/command_datum = comm
			if(user.skill_check(command_datum.core_skill, command_datum.skill_needed))
				valid_commands += command_datum.name
		return print_as_page(valid_commands, "command", selected_page, terminal.history_max_length - 1)

	var/com_name = manargs[1]
	var/datum/terminal_command/command_datum = terminal.command_by_name(com_name)
	if(!command_datum)
		return "man: command '[com_name]' not found."
	return command_datum.man_entry

/datum/terminal_command/ifconfig
	name = "ifconfig"
	man_entry = list("Format: ifconfig", "Returns network adaptor information.")
	pattern = @"^ifconfig$"

/datum/terminal_command/ifconfig/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/obj/item/stock_parts/computer/network_card/network_card = terminal.computer.get_component(PART_NETWORK)
	if(!istype(network_card))
		return "No network adaptor found."
	if(!network_card.check_functionality())
		return "Network adaptor not activated."
	return "Visible tag: [network_card.get_network_tag()].<br>Address: [network_card.get_nid()]"

/datum/terminal_command/hwinfo
	name = "hwinfo"
	man_entry = list("Format: hwinfo \[name\]", "If no slot specified, lists hardware.", "If slot is specified, runs diagnostic tests.")
	pattern = @"^hwinfo"

/datum/terminal_command/hwinfo/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(text == "hwinfo")
		. = list("Hardware Detected:")
		for(var/obj/item/stock_parts/computer/ch in  terminal.computer.get_all_components())
			. += ch.name
		return
	if(length(text) < 8)
		return "hwinfo: Improper syntax. Use hwinfo \[name\]."
	text = copytext(text, 8)
	var/obj/item/stock_parts/computer/ch = terminal.computer.find_hardware_by_name(text)
	if(!ch)
		return "hwinfo: No such hardware found."
	. = list("Running diagnostic protocols...")
	. += ch.diagnostics()
	return

// Sysadmin
/datum/terminal_command/banned
	name = "banned"
	man_entry = list("Format: banned", "Lists currently banned network ids.")
	pattern = @"^banned$"
	req_access = list(access_network)
	needs_network = TRUE

/datum/terminal_command/banned/proper_input_entered(text, mob/user, datum/terminal/terminal)
	. = list()
	. += "The following ids are banned:"
	var/datum/computer_network/network = terminal.computer.get_network()
	. += jointext(network.banned_nids, ", ") || "No ids banned."

/datum/terminal_command/status
	name = "status"
	man_entry = list("Format: status", "Reports network status information.")
	pattern = @"^status$"
	req_access = list(access_network)

/datum/terminal_command/status/proper_input_entered(text, mob/user, datum/terminal/terminal)
	. = list()
	var/datum/computer_network/network = terminal.computer.get_network()
	. += "Network status: [network ? "ENABLED" : "DISABLED"]"
	. += "Alarm status: [network?.intrusion_detection_enabled ? "ENABLED" : "DISABLED"]"
	if(network.intrusion_detection_alarm)
		. += "NETWORK INCURSION DETECTED"

/datum/terminal_command/locate
	name = "locate"
	man_entry = list("Format: locate nid", "Attempts to locate the device with the given nid by triangulating via relays.")
	pattern = @"locate"
	req_access = list(access_network)
	skill_needed = SKILL_PROF
	needs_network = TRUE

/datum/terminal_command/locate/proper_input_entered(text, mob/user, datum/terminal/terminal)
	. = "Failed to find device with given nid. Try ping for diagnostics."
	var/nid = get_nid(text)
	if(!nid)
		return
	var/datum/extension/interactive/os/origin = terminal.computer
	if(!origin || !origin.get_network_status())
		return
	var/datum/computer_network/network = origin.get_network()
	var/datum/extension/interactive/os/comp = network.get_os_by_nid(nid)
	if(!comp || !comp.host_status() || !comp.get_network_status())
		return
	var/area/A = get_area(comp.get_physical_host())
	return "... Estimating location: \the [A.proper_name]"

/datum/terminal_command/ping
	name = "ping"
	man_entry = list("Format: ping nid", "Checks connection to the given nid.")
	pattern = @"^ping"
	req_access = list(access_network)
	needs_network = TRUE

/datum/terminal_command/ping/proper_input_entered(text, mob/user, datum/terminal/terminal)
	. = list("pinging ...")
	var/nid = get_nid(text)
	if(!nid)
		. += "ping: Improper syntax. Use ping nid."
		return
	var/datum/extension/interactive/os/origin = terminal.computer
	if(!origin || !origin.get_network_status())
		. += "failed. Check network status."
		return
	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/interactive/os/comp = network.get_os_by_nid(nid)
	if(!comp || !comp.host_status() || !comp.get_network_status())
		. += "failed. Target device not responding."
		return
	. += "ping successful."

/datum/terminal_command/ssh
	name = "ssh"
	man_entry = list("Format: ssh nid", "Opens a remote terminal at the location of nid, if a valid device nid is specified.")
	pattern = @"^ssh"
	req_access = list(access_network)
	needs_network = TRUE

/datum/terminal_command/ssh/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(istype(terminal, /datum/terminal/remote))
		return "ssh is not supported on remote terminals."
	if(length(text) < 5)
		return "ssh: Improper syntax. Use ssh nid."
	var/datum/extension/interactive/os/origin = terminal.computer
	if(!origin || !origin.get_network_status())
		return "ssh: Check network connectivity."
	var/nid = text2num(copytext(text, 5))
	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/interactive/os/comp = network.get_os_by_nid(nid)
	if(comp == origin)
		return "ssh: Error; can not open remote terminal to self."
	if(!comp || !comp.host_status() || !comp.get_network_status())
		return "ssh: No active device with this nid found."
	if(comp.has_terminal(user))
		return "ssh: A remote terminal to this device is already active."
	var/datum/terminal/remote/new_term = new (user, comp, origin)
	LAZYADD(comp.terminals, new_term)
	LAZYADD(origin.terminals, new_term)
	return "ssh: Connection established."

/datum/terminal_command/cd
	name = "cd"
	man_entry = list("Format: cd \[path\]", "Changes the current working directory.", "Both relative and absolute paths are supported.")
	pattern = @"^cd"

/datum/terminal_command/cd/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(length(text) < 4)
		return "cd: Improper syntax, use cd \[target\]."

	var/list/cd_args = get_arguments(text)

	var/target_directory = cd_args[1]

	var/list/cd_targets = terminal.parse_directory(target_directory)
	if(!islist(cd_targets))
		return "cd: [get_terminal_error(target_directory, cd_targets)]."

	terminal.current_disk = cd_targets[1]
	terminal.current_directory = cd_targets[2]
	return ""

/datum/terminal_command/ls
	name = "ls"
	man_entry = list("Format: ls \[pg number\]", "Lists the files in the working directory, starting from the page number.")
	pattern = @"^ls"

/datum/terminal_command/ls/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/ls_args = get_arguments(text)

	var/selected_page = (length(ls_args)) ? text2num(ls_args[1]) : 1
	if(!isnum(selected_page))
		return "ls: Improper syntax, use format ls \[page number\]."

	if(!terminal.current_disk)
		return print_as_page(terminal.computer.mounted_storage, "disk", selected_page, terminal.history_max_length - 1)
	var/list/files = terminal.current_disk.get_dir_files(terminal.current_directory)
	var/list/file_data = list()
	for(var/datum/computer_file/F in files)
		if(istype(F, /datum/computer_file/directory))
			file_data += "[F.filename] - DIR"
		else
			file_data += "[F.filename].[F.filetype] - [F.size] GQ"

	return print_as_page(file_data, "file", selected_page, terminal.history_max_length - 1)

/datum/terminal_command/remove
	name = "rm"
	man_entry = list("Format: rm \[file path\]", "Removes the file with the given path.")
	pattern = @"^rm\b"

/datum/terminal_command/remove/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/file_path = copytext(text, 4)
	var/list/file_loc = terminal.parse_file(file_path)
	// Errored!
	if(!islist(file_loc))
		return "rm: [get_terminal_error(file_path, file_loc)]."

	var/datum/file_storage/disk = file_loc[1]
	var/datum/computer_file/file = file_loc[3]
	var/deleted = disk.delete_file(file, terminal.get_access(user), user)
	if(deleted == OS_FILE_SUCCESS)
		return "rm: Removed file '[file.filename]'."
	if(deleted == OS_FILE_NO_WRITE)
		return "rm: You do not have permission to remove file '[file.filename]'."
	// Other error. Most likely, the hard drive is non-functional.
	return "rm: Failed to delete file '[file.filename]'. Hard drive may be non-functional."
/datum/terminal_command/move
	name = "mv"
	man_entry = list("Format: mv \[file path\] \[destination\] \[copying (0/1) \]", "Moves a file to another directory.")
	pattern = @"^mv"

/datum/terminal_command/move/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!terminal.current_disk)
		return "mv: No disk selected."

	var/list/mv_args = get_arguments(text)
	if(length(mv_args) < 2)
		return "mv: Improper syntax, use mv \[file path\] \[destination\] \[copying (0/1) \]."
	var/source_path = mv_args[1]
	var/list/file_loc = terminal.parse_file(source_path)
	if(!islist(file_loc)) // Errored!
		return "mv: [get_terminal_error(source_path, file_loc)]."

	var/datum/computer_file/F = file_loc[3]
	var/copying = length(mv_args) > 2 ? text2num(mv_args[3]) : FALSE
	// Find the destination.
	var/target_path = mv_args[2]

	var/list/destination = terminal.parse_directory(target_path)
	if(!islist(destination))
		return "mv: [get_terminal_error(target_path, file_loc)]."

	// Check file permisisons.
	var/error = check_file_transfer(destination[2], F, copying, terminal.get_access(user), user)
	if(error)
		return "mv: [error]."

	terminal.current_move = new(file_loc[1], destination[1], destination[2], F, copying)
	return "mv: Beginning file move..."

/datum/terminal_command/copy
	name = "cp"
	man_entry = list("Format: cp \[file path\]", "Copies the file with the given path.")
	pattern = @"^cp"

/datum/terminal_command/copy/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!terminal.current_disk)
		return "cp: No disk selected."

	if(length(text) < 4)
		return "cp: Improper syntax, use copy \[file path\]."

	var/file_path = copytext(text, 4)
	var/list/file_loc = terminal.parse_file(file_path)
	// Errored!
	if(!islist(file_loc))
		var/list/dirs_and_file = splittext(file_path, "/")
		var/dir_path = jointext(dirs_and_file, "/", 1, dirs_and_file.len)
		var/filename = dirs_and_file[dirs_and_file.len]
		return "cp: [get_terminal_error(filename, dir_path, file_loc)]."

	var/datum/file_storage/disk = file_loc[1]
	var/datum/computer_file/file = file_loc[3]

	var/datum/computer_file/copy = file.Clone(TRUE)
	if(!istype(copy))
		return
	var/success = disk.store_file(copy, file_loc[2], FALSE, terminal.get_access(user), user)
	if(success == OS_FILE_SUCCESS)
		return "cp: Successfully copied file [file.filename]."

	return "cp: [get_terminal_error(file_path, success)]."

/datum/terminal_command/rename
	name = "rename"
	man_entry = list("Format: rename \[file path\] \[new name\]", "Renames a file with the given path.")
	pattern = @"^rename"

/datum/terminal_command/rename/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/rename_args = get_arguments(text)
	if(length(rename_args) < 2)
		return "rename: Improper syntax, use rename \[file name\] \[new name\]."
	var/file_path = rename_args[1]
	var/list/file_loc = terminal.parse_file(file_path)
	// Errored!
	if(!islist(file_loc))
		return "rename: [get_terminal_error(file_path, file_loc)]."

	var/datum/file_storage/disk = file_loc[1]
	var/datum/computer_file/F = file_loc[3]
	var/new_name = sanitize_for_file(rename_args[2])

	if(length(new_name))
		if(F.unrenamable || !(F.get_file_perms(terminal.get_access(user), user) & OS_WRITE_ACCESS))
			return "rename: You lack permission to rename [F.filename]."
		if(disk.rename_file(F, new_name, user))
			return "rename: File renamed to '[new_name]'."
		else
			return "rename: Unable to rename file."
	else
		return "rename: Invalid file name."

/datum/terminal_command/mkdir
	name = "mkdir"
	man_entry = list("Format: mkdir \[dir path\]", "Creates a directory with the given path.")
	pattern = @"^mkdir"

/datum/terminal_command/mkdir/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/mkdir_args = get_arguments(text)
	if(!length(mkdir_args))
		return "mv: Improper syntax, use mkdir \[dir path\]."
	var/list/file_loc = terminal.parse_directory(mkdir_args[1], TRUE)
	if(!islist(file_loc) || (length(file_loc) > 1 && file_loc[2] == null)) // Don't return the error directly since we're attempting to create a directory, not just parse one.
		return "mkdir: Unable to create directory '[mkdir_args[1]]'."

	var/datum/computer_file/directory/created_dir = file_loc[2]
	return "mkdir: Successfully created directory '[created_dir.get_file_path()]'."

/datum/terminal_command/target
	name = "target"
	man_entry = list("Format: target \[network tag\]", "Gets or sets the target network tag for terminal commands.")
	pattern = @"^target"

/datum/terminal_command/target/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/target_args = get_arguments(text)
	if(!length(target_args))
		return "target: The current target network tag is [terminal.network_target]."

	terminal.network_target = uppertext(target_args[1])
	return "target: Changed network target to [terminal.network_target]."

/datum/terminal_command/login
	name = "login"
	man_entry = list("Format: login \[account login\] \[account password\]", "Logs in to the given user account.")
	pattern = @"^login"
	needs_network = TRUE

/datum/terminal_command/login/proper_input_entered(text, mob/user, datum/terminal/terminal)

	var/list/login_args = get_arguments(text)

	if(length(login_args) < 2)
		return "login: Improper syntax, use login \[account login\] \[account password\]."

	var/datum/extension/interactive/os/account_computer = terminal.get_account_computer()
	var/login_success = account_computer.login_account(login_args[1], login_args[2])
	if(login_success)
		return "login: Login successful. Welcome [login_args[1]]!"
	return "login: Could not log in to account [login_args[1]]. Check password or network connectivity."

/datum/terminal_command/logout
	name = "logout"
	man_entry = list("Format: logout", "Logs out of the current user account.")
	pattern = @"^logout"
	needs_network =  TRUE

/datum/terminal_command/logout/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/datum/extension/interactive/os/account_computer = terminal.get_account_computer()
	account_computer.logout_account()
	return "logout: Log out successful."

/datum/terminal_command/permmod
	name = "permmod"
	man_entry = list("Format: permmod \[file path\] \[access key\] \[permission mod flags\]", "Modifies or lists the permissions of the given file. Do not pass an access key to list permissions.",
	"Supported flags are as follows:",
	"'+/-' - Add or Remove access requirement",
	"'r/w/m' - Target read/write/modification access",
	"'u/g' - Add group or individual user access requirement",
	"For example, the command 'permmod TestFile bronte.lowe +ru' would add bronte.lowe to the read permissions list of the file TestFile."
	) // TODO: Add an actual flags option for terminal commands in addition to arguments
	pattern = @"^permmod"
	needs_network = TRUE

/datum/terminal_command/permmod/proper_input_entered(text, mob/user, datum/terminal/terminal)

	if(!terminal.current_disk)
		return "permmod: No disk selected."

	var/list/permmod_args = get_arguments(text)
	if(!length(permmod_args))
		return "permmod: Improper syntax, use permmod \[file path\] \[access key\] \[permission mod flags\]."

	var/file_path = permmod_args[1]
	var/list/file_loc = terminal.parse_file(file_path)
	if(!islist(file_loc))
		return "permmod: [get_terminal_error(file_path, file_loc)]."

	var/datum/computer_file/F = file_loc[3]

	if(length(permmod_args) < 3)
		return F.get_perms_readable()

	var/flags = permmod_args[3]
	var/mode
	var/access_key
	var/perm
	if(findtext(flags, "-"))
		mode = "-"
	else if(findtext(flags, "+"))
		mode = "+"
	if(!mode)
		return "permmod: Invalid flag syntax. Use man command to learn more about permmod flag syntax."

	if(findtext(flags, "r"))
		perm = OS_READ_ACCESS
	else if(findtext(flags, "w"))
		perm = OS_WRITE_ACCESS
	else if(findtext(flags, "m"))
		perm = OS_MOD_ACCESS
	else
		return "permmod: Invalid flag syntax. Use man command to learn more about permmod flag syntax."
	var/datum/computer_network/network = terminal.computer.get_network()
	if(findtext(flags, "u"))
		var/account_login = permmod_args[2]
		if(!network.find_account_by_login(account_login))
			return "permmod: No user account with login '[account_login]' found."
		access_key = "[account_login]@[network.network_id]"
	else if(findtext(flags, "g"))
		var/group_name = permmod_args[2]
		var/datum/extension/network_device/acl/acl = network.access_controller
		if(!istype(acl))
			return "permmod: No active ACL could be located on the network."
		if(!(group_name in acl.get_all_groups()))
			return "permmod: No group with name '[group_name]' found."
		access_key = "[group_name].[network.network_id]"
	else
		return "permmod: Invalid flag syntax. Use man command to learn more about permmod flag syntax."

	var/success = F.change_perms(mode, perm, access_key, terminal.get_access(user))
	if(success)
		return "permmod: Successfully changed permissions for [F.filename]."
	else
		return "permmod: Could not change permissions for [F.filename]. You may lack permission modification access."

// Terminal commands for passing information to public variables and methods follows
/datum/terminal_command/com
	name = "com"
	man_entry = list("Format: com \[alias\] \[value\]", "Calls a command on the current network target for modifying variables or calling methods.")
	pattern = @"^com"
	needs_network = TRUE
	needs_network_feature = NET_FEATURE_SYSTEMCONTROL

/datum/terminal_command/com/proper_input_entered(text, mob/user, datum/terminal/terminal)
	// If the user is unskilled, call a random method
	if(!user.skill_check(core_skill, SKILL_EXPERT))
		var/target_tag = terminal.network_target
		if(!target_tag)
			return "com: No network target set. Use 'target' to set a network target."

		var/datum/computer_network/network = terminal.computer.get_network()
		var/datum/extension/network_device/D = network.get_device_by_tag(target_tag)

		if(!istype(D))
			return "com: Could not find target device with network tag [target_tag]."

		if(!D.has_commands)
			return "com: Target device cannot receive commmands."

		return D.random_method(user)

	var/list/com_args = get_arguments(text)
	if(!length(com_args))
		return "com: Improper syntax, use com \[variable\] \[value\]."

	var/target_tag = terminal.network_target
	if(!target_tag)
		return "com: No network target set. Use 'target' to set a network target."

	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/network_device/D = network.get_device_by_tag(target_tag)

	if(!istype(D))
		return "com: Could not find target device with network tag [target_tag]."

	if(!D.has_commands)
		return "com: Target device cannot receive commmands."

	var/called_args
	if(length(com_args) > 2)
		called_args = com_args.Copy(2)
	else if(length(com_args) == 2)
		called_args = com_args[2]

	return D.on_command(com_args[1], called_args, terminal.get_access(user))

// Lists the commands available on the target device.
/datum/terminal_command/listcom
	name = "listcom"
	man_entry = list("Format: listcom \[pg number / command\]", "Lists commands available on the current network target.", "If a command is given as an argument, provides information about that command.")
	pattern = @"^listcom"
	needs_network = TRUE
	skill_needed = SKILL_EXPERT
	needs_network_feature = NET_FEATURE_SYSTEMCONTROL

/datum/terminal_command/listcom/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/target_tag = terminal.network_target
	if(!target_tag)
		return "listcom: No network target set. Use 'target' to set a network target."

	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/network_device/D = network.get_device_by_tag(target_tag)

	if(!istype(D))
		return "listcom: Could not find target device with network tag [target_tag]."

	if(!D.has_commands)
		return "listcom: Target device cannot receive commmands."

	var/list/listcom_args = get_arguments(text)
	if(!length(listcom_args) || isnum(text2num(listcom_args[1])))
		. = list()
		var/selected_page = (length(listcom_args)) ? text2num(listcom_args[1]) : 1

		var/list/valid_commands = list()
		for(var/alias in D.command_and_call)
			valid_commands += "Method - [alias]"
		for(var/alias in D.command_and_write)
			valid_commands += "Variable - [alias]"

		return print_as_page(valid_commands, "command", selected_page, terminal.history_max_length - 1)

	var/selected_alias = listcom_args[1]
	var/decl/public_access/selected_ref = D.command_and_call[selected_alias] || D.command_and_write[selected_alias]
	if(selected_alias in D.command_and_call)
		selected_ref = D.command_and_call[selected_alias]
	else if(selected_alias in D.command_and_write)
		selected_ref = D.command_and_write[selected_alias]
	else
		return "listcom: No command with alias '[selected_alias]' found."

	. = list()
	. += "[selected_ref.name]: [selected_ref.desc]"
	if(istype(selected_ref, /decl/public_access/public_variable))
		var/decl/public_access/public_variable/pub_var = selected_ref
		. += "Var Type: [pub_var.var_type]"
		. += "Writable: [pub_var.can_write ? "TRUE" : "FALSE"]"
	else if(istype(selected_ref, /decl/public_access/public_method))
		var/decl/public_access/public_method/pub_method = selected_ref
		. += "Has Arguments: [pub_method.forward_args ? "TRUE" : "FALSE"]"

// Adds a command attached to a random reference, either a variable or a method.
/datum/terminal_command/addcom
	name = "addcom"
	man_entry = list("Format: addcom \[type\] \[alias\]", "Adds a command on the current network target. Accepts types 'METHOD' or 'VARIABLE'")
	pattern = @"^addcom"
	needs_network = TRUE
	skill_needed = SKILL_EXPERT
	needs_network_feature = NET_FEATURE_SYSTEMCONTROL

/datum/terminal_command/addcom/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/addcom_args = get_arguments(text)
	if(!length(addcom_args))
		return "addcom: Improper syntax, use addcom \[type\] \[alias\]. Accepts types 'METHOD' or 'VARIABLE'"

	var/target_tag = terminal.network_target
	if(!target_tag)
		return "addcom: No network target set. Use 'target' to set a network target."

	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/network_device/D = network.get_device_by_tag(target_tag)

	if(!istype(D))
		return "addcom: Could not find target device with network tag [target_tag]."

	if(!D.has_commands)
		return "addcom: Target device cannot receive commmands."

	var/alias = (length(addcom_args) >= 2) ? addcom_args[2] : 0
	if(addcom_args[1] == "METHOD")
		alias = D.add_command(D.command_and_call, alias, D.get_public_methods())
	else if(addcom_args[1] == "VARIABLE")
		alias = D.add_command(D.command_and_write, alias, D.get_public_variables())
	else
		return "addcom: Improper syntax, use addcom \[type\] \[alias\]. Accepts types 'METHOD' or 'VARIABLE'"
	return "addcom: Added '[addcom_args[1]]' command with alias [alias]"

/datum/terminal_command/modcom
	name = "modcom"
	man_entry = list("Format: modcom \[alias\] \[index\]", "Modifies a command on the current network target. Leave index blank to return a list of possible references")
	pattern = @"^modcom"
	needs_network = TRUE
	skill_needed = SKILL_PROF // addcom only adds a randomly chosen command to the device - you need to be significantly more skilled to select a specific one remotely.
	needs_network_feature = NET_FEATURE_SYSTEMCONTROL

/datum/terminal_command/modcom/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/modcom_args = get_arguments(text)
	if(!length(modcom_args))
		return "modcom: Improper syntax, use modcom \[alias\] \[index\].'"

	var/target_tag = terminal.network_target
	if(!target_tag)
		return "modcom: No network target set. Use 'target' to set a network target."

	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/network_device/D = network.get_device_by_tag(target_tag)

	if(!istype(D))
		return "modcom: Could not find target device with network tag [target_tag]."

	if(!D.has_commands)
		return "modcom: Target device cannot receive commmands."

	var/alias = modcom_args[1]
	var/list/valid_commands = list()
	var/list/device_command_list
	// Find the valid methods or variables this command can reference
	if(alias in D.command_and_call)
		device_command_list = D.command_and_call
		valid_commands = D.get_public_methods()
	else if(alias in D.command_and_write)
		device_command_list = D.command_and_write
		valid_commands = D.get_public_variables()
	else
		return "modcom: No command with [alias] found."

	var/selected_index = (length(modcom_args) >= 2) ? modcom_args[2] : null

	// If there is no given index, return a list of available indexes.
	if(!selected_index)
		var/list/options = list()
		var/index = 1
		options += "Index - Reference."
		for(var/path in valid_commands)
			var/decl/public_access/reference = valid_commands[path]
			options += "([index] - [reference.name])"
			index++
		return options

	selected_index = text2num(selected_index)
	if(selected_index > length(valid_commands))
		return "modcom: Invalid index."
	var/selected_path =  valid_commands[selected_index]
	var/decl/public_access/selected_reference = valid_commands[selected_path]

	D.set_command_reference(device_command_list, alias, selected_reference)

	return "modcom: Set command with alias '[alias]' to reference '[selected_reference.name]'"

/datum/terminal_command/namecom
	name = "namecom"
	man_entry = list("Format: namecom \[old alias\] \[new alias\]", "Renames a command with the given alias on the current network target.")
	pattern = @"^namecom"
	needs_network = TRUE
	skill_needed = SKILL_EXPERT
	needs_network_feature = NET_FEATURE_SYSTEMCONTROL

/datum/terminal_command/namecom/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/namecom_args = get_arguments(text)
	if(length(namecom_args) < 2)
		return "namecom: Improper syntax, use namecom \[old alias\] \[new alias\]."

	var/target_tag = terminal.network_target
	if(!target_tag)
		return "namecom: No network target set. Use 'target' to set a network target."

	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/network_device/D = network.get_device_by_tag(target_tag)

	if(!istype(D))
		return "namecom: Could not find target device with network tag [target_tag]."

	if(!D.has_commands)
		return "namecom: Target device cannot receive commmands."

	if(D.change_command_alias(namecom_args[1], namecom_args[2]))
		return "namecom: Changed alias '[namecom_args[1]]' to '[namecom_args[2]]'"
	else
		return "namecom: Failed to change alias, '[namecom_args[2]]' already in use."

/datum/terminal_command/rmcom
	name = "rmcom"
	man_entry = list("Format: rmcom \[alias\]", "Removes a command with the given alias on the current network target.")
	pattern = @"^rmcom"
	needs_network = TRUE
	skill_needed = SKILL_EXPERT
	needs_network_feature = NET_FEATURE_SYSTEMCONTROL

/datum/terminal_command/rmcom/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/rmcom_args = get_arguments(text)
	if(!length(rmcom_args))
		return "rmcom: Improper syntax, use rmcom \[alias\]."

	var/target_tag = terminal.network_target
	if(!target_tag)
		return "rmcom: No network target set. Use 'target' to set a network target."

	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/network_device/D = network.get_device_by_tag(target_tag)

	if(!istype(D))
		return "rmcom: Could not find target device with network tag [target_tag]."

	if(!D.has_commands)
		return "rmcom: Target device cannot receive commmands."

	if(D.remove_command(rmcom_args[1]))
		return "rmcom: Removed command with alias '[rmcom_args[1]]' from target device."
	else
		return "rmcom: No command with alias '[rmcom_args[1]]' found on target device."