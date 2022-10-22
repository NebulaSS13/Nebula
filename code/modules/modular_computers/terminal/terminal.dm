// System for a shitty terminal emulator.
/datum/terminal
	var/name = "Terminal"
	var/datum/browser/panel
	var/list/history = list()
	var/list/history_max_length = 20

	var/network_target // Network tag of whatever device is being targeted on the network by commands.

	// Terminal can act as a file transfer utility.
	var/list/disks = list(
		/datum/file_storage/disk,
		/datum/file_storage/disk/removable,
		/datum/file_storage/network
	)
	var/datum/file_storage/current_disk
	var/datum/file_transfer/current_move

	var/datum/extension/interactive/os/computer

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
		if(!result)
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
			append_to_history("File Move: Successfully copied file '[current_move.transferring.filename]' to [current_move.transfer_to].")
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
	content += "<form action='byond://'><input type='hidden' name='src' value='\ref[src]'>> [account_name] <input type='text' size='40' name='input' autofocus><input type='submit' value='Enter'></form>"
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