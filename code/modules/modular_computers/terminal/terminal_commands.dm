// To cut down on unneeded creation/deletion, these are global.
GLOBAL_LIST_INIT(terminal_commands, init_subtypes(/datum/terminal_command))

/datum/terminal_command
	var/name                              // Used for man
	var/man_entry                         // Shown when man name is entered. Can be a list of strings, which will then be shown on separate lines.
	var/pattern                           // Matched using regex
	var/regex_flags                       // Used in the regex
	var/regex/regex                       // The actual regex, produced from above.
	var/core_skill = SKILL_COMPUTER       // The skill which is checked
	var/skill_needed = SKILL_EXPERT       // How much skill the user needs to use this. This is not for critical failure effects at unskilled; those are handled globally.
	var/req_access = list()               // Stores access needed, if any
	var/needs_network					  // If this command fails if computer running terminal isn't connected to a network

	var/global/regex/nid_regex			  // Regex for getting network addres out of the line

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
	pattern = "^exit$"
	skill_needed = SKILL_BASIC

/datum/terminal_command/exit/proper_input_entered(text, mob/user, terminal)
	qdel(terminal)
	return list()

/datum/terminal_command/man
	name = "man"
	man_entry = list("Format: man \[command\]", "Without command specified, shows list of available commands.", "With command, provides instructions on command use.")
	pattern = "^man"

/datum/terminal_command/man/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(text == "man")
		. = list("The following commands are available.", "Some may require additional access.")
		for(var/command in GLOB.terminal_commands)
			var/datum/terminal_command/command_datum = command
			if(user.skill_check(command_datum.core_skill, command_datum.skill_needed))
				. += command_datum.name
		return
	if(length(text) < 5)
		return "man: improper syntax. Use man \[command\]"
	text = copytext(text, 5)
	var/datum/terminal_command/command_datum = terminal.command_by_name(text)
	if(!command_datum)
		return "man: command '[text]' not found."
	return command_datum.man_entry

/datum/terminal_command/ifconfig
	name = "ifconfig"
	man_entry = list("Format: ifconfig", "Returns network adaptor information.")
	pattern = "^ifconfig$"

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
	pattern = "^hwinfo"

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
	pattern = "^banned$"
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
	pattern = "^status$"
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
	pattern = "locate"
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
	pattern = "^ping"
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
	pattern = "^ssh"
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
