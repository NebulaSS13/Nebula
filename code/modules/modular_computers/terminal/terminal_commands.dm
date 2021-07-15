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

	var/static/regex/nid_regex			  // Regex for getting network addres out of the line

/datum/terminal_command/New()
	regex = new (pattern, regex_flags)
	..()

/datum/terminal_command/proc/check_access(mob/user)
	return has_access(req_access, user.GetAccess())

/datum/terminal_command/proc/get_nid(text)
	if(!nid_regex)
		nid_regex = regex(@"\w\w-\w\w-\w\w-\w\w")
	if(nid_regex.Find(text))
		return uppertext(nid_regex.match)

/datum/terminal_command/proc/get_arguments(text)
	var/argtext = copytext(text, length(pattern) + 1)
	return splittext(argtext, " ")

// null return: continue. "" return will break and show a blank line. Return list() to break and not show anything.
/datum/terminal_command/proc/parse(text, mob/user, datum/terminal/terminal)
	if(!findtext(text, regex))
		return
	if(!user.skill_check(core_skill, skill_needed))
		return skill_fail_message()
	if(!check_access(user))
		return "[name]: ACCESS DENIED"
	if(needs_network && !terminal.computer.get_network_status())
		return "NETWORK ERROR: Check connection and try again."

	return proper_input_entered(text, user, terminal)

//Should not return null unless you want parser to continue.
/datum/terminal_command/proc/proper_input_entered(text, mob/user, terminal)
	return list()

// Prints data out, split by page number.
/datum/terminal_command/proc/print_as_page(list/data, value_name, selected_page, pg_length)
	. = list()
	var/max_pages = CEILING(length(data)/pg_length)
	var/pg = clamp(selected_page, 1, max_pages)

	var/start_index = (pg - 1)*pg_length + 1
	var/end_index = min(length(data), (pg)*pg_length)+1

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
	var/datum/extension/interactive/ntos/origin = terminal.computer
	if(!origin || !origin.get_network_status())
		return
	var/datum/computer_network/network = origin.get_network()
	var/datum/extension/interactive/ntos/comp = network.get_os_by_nid(nid)
	if(!comp || !comp.host_status() || !comp.get_network_status())
		return
	var/area/A = get_area(comp.get_physical_host())
	return "... Estimating location: \the [A.name]"

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
	var/datum/extension/interactive/ntos/origin = terminal.computer
	if(!origin || !origin.get_network_status())
		. += "failed. Check network status."
		return
	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/interactive/ntos/comp = network.get_os_by_nid(nid)
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
	var/datum/extension/interactive/ntos/origin = terminal.computer
	if(!origin || !origin.get_network_status())
		return "ssh: Check network connectivity."
	var/nid = text2num(copytext(text, 5))
	var/datum/computer_network/network = terminal.computer.get_network()
	var/datum/extension/interactive/ntos/comp = network.get_os_by_nid(nid)
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
	man_entry = list("Format: cd \[target\] \[network tag\]", "Changes the current disk to the target.", "LOCAL, REMOVABLE, and NETWORK are supported.")
	pattern = @"^cd"

/datum/terminal_command/cd/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(length(text) < 4)
		return "cd: Improper syntax, use cd \[target\]."

	var/list/cd_args = get_arguments(text)

	var/target = uppertext(cd_args[1])
	if(target == "LOCAL")
		terminal.current_disk = terminal.disks[/datum/file_storage/disk]
		if(!terminal.current_disk)
			return "cd: Could not locate disk."
		var/error = terminal.current_disk.check_errors()
		if(error)
			terminal.current_disk = null
			return "cd: [error]"
		return "cd: Changed to local disk."
	else if(target == "REMOVABLE")
		terminal.current_disk = terminal.disks[/datum/file_storage/disk/removable]
		if(!terminal.current_disk)
			return "cd: Could not locate removable disk."
		var/error = terminal.current_disk.check_errors()
		if(error)
			terminal.current_disk = null
			return "cd: [error]"
		return "cd: Changed to removable disk"

	else if(target == "NETWORK")
		var/datum/extension/interactive/ntos/origin = terminal.computer
		if(!origin || !origin.get_network_status())
			return "cd: Check network connectivity."
		var/datum/computer_network/network = terminal.computer.get_network()
		// Get the network tag input into the command, or the current network_target otherwise.
		var/network_tag = (length(cd_args) >= 2) ? cd_args[2] : terminal.network_target
		var/datum/extension/network_device/mainframe/M = network.get_device_by_tag(network_tag)
		if(!istype(M))
			return "cd: Could not locate file server with tag [network_tag]."
		if(!M.has_access(user))
			return "cd: Access denied to file server with tag [network_tag]"
		terminal.current_disk = terminal.disks[/datum/file_storage/network]
		if(!terminal.current_disk)
			return "cd: Could not locate remote file server."

		var/datum/file_storage/network/N = terminal.current_disk
		N.server = network_tag
		var/error = terminal.current_disk.check_errors()
		if(error)
			terminal.current_disk = null
			return "cd: [error]"
		return "cd: Changed to remote file server with tag [network_tag]."
	else
		return "cd: Target disk not recognized. LOCAL, REMOVABLE, and NETWORK are supported."

/datum/terminal_command/ls
	name = "ls"
	man_entry = list("Format: ls \[pg number\]", "Lists the files in the current disk, starting from the page number.")
	pattern = @"^ls"

/datum/terminal_command/ls/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!terminal.current_disk || ispath(terminal.current_disk))
		return "ls: No disk selected."
	
	var/list/ls_args = get_arguments(text)

	var/selected_page = (length(ls_args)) ? text2num(ls_args[1]) : 1
	if(!isnum(selected_page))
		return "ls: Improper syntax, use format ls \[page number\]."

	var/list/files = terminal.current_disk.get_all_files()
	var/list/file_data = list()
	for(var/datum/computer_file/F in files)
		file_data += "[F.filename].[F.filetype] - [F.size] GQ"
	
	return print_as_page(file_data, "file", selected_page, terminal.history_max_length - 1)

/datum/terminal_command/remove
	name = "rm"
	man_entry = list("Format: rm \[file name\]", "Removes the file given in the current disk.")
	pattern = @"^rm\b"

/datum/terminal_command/remove/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!terminal.current_disk)
		return "rm: No disk selected."
	
	var/file_name = copytext(text, 4)

	var/deleted = terminal.current_disk.delete_file(file_name)
	if(deleted)
		return "rm: Removed file [file_name]."
	else
		return "rm: Failed to remove file [file_name]."

/datum/terminal_command/move
	name = "mv"
	man_entry = list("Format: mv \[file name\] \[destination\]", "Moves a file in the current disk to another.")
	pattern = @"^mv"

/datum/terminal_command/move/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!terminal.current_disk)
		return "mv: No disk selected."
	
	var/list/mv_args = get_arguments(text)
	if(length(mv_args) < 2)
		return "mv: Improper syntax, use mv \[file name\] \[destination\]."
	var/datum/computer_file/F = terminal.current_disk.get_file(mv_args[1])
	if(!F)
		return "mv: Could not find file with name [mv_args[1]]."

	// Find the destination.
	var/datum/file_storage/dest
	var/target = uppertext(mv_args[2])
	if(target == "LOCAL")
		dest = terminal.disks[/datum/file_storage/disk]
		if(!dest)
			return "mv: Could not locate disk."
		var/error = dest.check_errors()
		if(error)
			return "mv: [error]"
	else if(target == "REMOVABLE")
		dest = terminal.disks[/datum/file_storage/disk/removable]
		if(!dest)
			return "mv: Could not locate removable disk."
		var/error = dest.check_errors()
		if(error)
			return "mv: [error]"
	else
		var/datum/extension/interactive/ntos/origin = terminal.computer
		if(!origin || !origin.get_network_status())
			return "mv: Check network connectivity."
		var/datum/computer_network/network = terminal.computer.get_network()
		var/datum/extension/network_device/mainframe/M = network.get_device_by_tag(target)
		if(!istype(M))
			return "mv: Could not locate destination with tag [target]."
		if(!M.has_access(user))
			return "mv: Access denied to destination with tag [target]"
		dest = terminal.disks[/datum/file_storage/network]
		if(!dest)
			return "mv: Could not locate remote file server."

		var/datum/file_storage/network/N = dest
		N.server = target
		var/error = dest.check_errors()
		if(error)
			return "mv: [error]"

	if(!dest)
		return "mv: Could not locate file destination."
	
	terminal.current_move = new(terminal.current_disk, dest, F)
	return "mv: Beginning file move..."

/datum/terminal_command/copy
	name = "cp"
	man_entry = list("Format: cp \[file name\]", "Copies a file in the current disk.")
	pattern = @"^cp"

/datum/terminal_command/copy/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!terminal.current_disk)
		return "cp: No disk selected."
	
	if(length(text) < 4)
		return "cp: Improper syntax, use copy \[file name\]."

	var/target_name = copytext(text, 4)
	var/datum/computer_file/F = terminal.current_disk.get_file(target_name)
	if(!F)
		return "cp: Could not find file with name [target_name]."

	var/copied_file = F.clone(TRUE)
	if(terminal.current_disk.store_file(copied_file))
		return "cp: Successfully copied file [F.filename]."
	else
		return "cp: Could not copy file!"

/datum/terminal_command/rename
	name = "rename"
	man_entry = list("Format: rename \[file name\] \[new name\]", "Renames a file in the current disk.")
	pattern = @"^rename"

/datum/terminal_command/rename/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!terminal.current_disk)
		return "rename: No disk selected."

	var/list/rename_args = get_arguments(text)

	if(length(rename_args) < 2)
		return "rename: Improper syntax, use rename \[file name\] \[new name\]."
	var/datum/computer_file/F = terminal.current_disk.get_file(rename_args[1])
	if(!F)
		return "rename: Could not find file with name [rename_args[1]]."
	
	var/new_name = sanitize(rename_args[2])

	if(length(new_name))
		F.filename = new_name
		return "rename: File renamed to [new_name]."
	else
		return "rename: Could not rename file."

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

// Terminal commands for passing information to public variables and methods follows
/datum/terminal_command/com
	name = "com"
	man_entry = list("Format: com \[alias\] \[value\]", "Calls a command on the current network target for modifying variables or calling methods.")
	pattern = @"^com"
	needs_network = TRUE

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

	return D.on_command(com_args[1], called_args, user)

// Lists the commands available on the target device.
/datum/terminal_command/listcom
	name = "listcom"
	man_entry = list("Format: listcom \[pg number / command\]", "Lists commands available on the current network target.", "If a command is given as an argument, provides information about that command.")
	pattern = @"^listcom"
	needs_network = TRUE
	skill_needed = SKILL_EXPERT

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