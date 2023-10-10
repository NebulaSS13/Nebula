// /program/ files are executable programs that do things.
/datum/computer_file/program
	filetype = "PRG"
	filename = "UnknownProgram"						// File name. FILE NAME MUST BE UNIQUE IF YOU WANT THE PROGRAM TO BE DOWNLOADABLE FROM NETWORK!
	var/requires_access_to_run = 1					// Whether the program checks for read_access when run.
	var/requires_access_to_download = 1				// Whether the program checks for read_access when downloading.
	var/datum/nano_module/NM = null					// If the program uses NanoModule, put it here and it will be automagically opened. Otherwise implement ui_interact.
	var/nanomodule_path = null						// Path to nanomodule, make sure to set this if implementing new program.
	var/program_state = PROGRAM_STATE_KILLED		// PROGRAM_STATE_KILLED or PROGRAM_STATE_BACKGROUND or PROGRAM_STATE_ACTIVE - specifies whether this program is running.
	var/datum/extension/interactive/os/computer		// OS that runs this program.
	var/filedesc = "Unknown Program"				// User-friendly name of this program.
	var/extended_desc = "N/A"						// Short description of this program's function.
	var/category = PROG_MISC
	var/program_icon_state = null					// Program-specific screen icon state
	var/program_key_state = "standby_key"			// Program-specific keyboard icon state
	var/program_menu_icon = "newwin"				// Icon to use for program's link in main menu
	var/requires_network = 0						// Set to 1 for program to require nonstop network connection to run. If network connection is lost program crashes.
	var/requires_network_feature = 0				// Optional, if above is set to 1 checks for specific function of network (currently NETWORK_SOFTWAREDOWNLOAD, NETWORK_PEERTOPEER, NETWORK_SYSTEMCONTROL and NETWORK_COMMUNICATION)
	var/usage_flags = PROGRAM_ALL & ~PROGRAM_PDA	// Bitflags (PROGRAM_CONSOLE, PROGRAM_LAPTOP, PROGRAM_TABLET, PROGRAM_PDA combination) or PROGRAM_ALL
	var/network_destination = null					// Optional string that describes what network server/system this program connects to. Used in default logging.
	var/available_on_network = TRUE					// Whether the program can be downloaded from network. Set to FALSE to disable.
	var/computer_emagged = 0						// Set to 1 if computer that's running us was emagged. Computer updates this every Process() tick
	var/ui_header = null							// Example: "something.gif" - a header image that will be rendered in computer's UI when this program is running at background. Images are taken from /nano/images/status_icons. Be careful not to use too large images!
	var/operator_skill = SKILL_MIN                  // Holder for skill value of current/recent operator for programs that tick.

	mod_access = list(list(access_network))

/datum/computer_file/program/Destroy()
	if(computer && computer.active_program == src)
		computer.kill_program(src)
	computer = null
	. = ..()

/datum/computer_file/program/nano_host()
	return computer && computer.nano_host()

/datum/computer_file/program/PopulateClone(datum/computer_file/program/clone)
	clone = ..()
	clone.read_access        = deepCopyList(read_access)
	clone.nanomodule_path    = nanomodule_path
	clone.filedesc           = filedesc
	clone.program_icon_state = program_icon_state
	clone.requires_network   = requires_network
	clone.requires_network_feature = requires_network_feature
	clone.usage_flags        = usage_flags
	return clone

// Used by programs that manipulate files.
/datum/computer_file/program/proc/get_file(var/filename, var/directory, var/list/accesses, var/mob/user)
	return computer.get_file(filename, directory, accesses, user)

/datum/computer_file/program/proc/create_file(var/newname, var/directory, var/data = "", var/file_type = /datum/computer_file/data, var/list/metadata = null, var/list/accesses, var/mob/user)
	return computer.create_file(newname, directory, data, file_type, metadata, accesses, user)

// Relays icon update to the computer.
/datum/computer_file/program/proc/update_computer_icon()
	if(istype(computer))
		computer.update_host_icon()
		return

// Attempts to create a log on the local network. Returns 1 on success, 0 on fail.
/datum/computer_file/program/proc/generate_network_log(var/text)
	if(computer)
		return computer.add_log(text)
	return 0

/datum/computer_file/program/proc/is_supported_by_hardware(var/hardware_flag, var/mob/user, var/loud = FALSE)
	if(!(hardware_flag & usage_flags))
		if(loud && computer && user)
			computer.show_error(user, "Hardware Error - Incompatible software '[filedesc]'")
		return 0
	return 1

/datum/computer_file/program/proc/get_signal(var/specific_action = 0)
	if(computer)
		return computer.get_network_status(specific_action)
	return 0

// Called by Process() on device that runs us, once every tick.
/datum/computer_file/program/proc/process_tick()
	return 1

// Check if the user can run program. Only humans can operate computer. Automatically called in run_program()
// User has to wear their ID or have it inhand for ID Scan to work.
// Can also be called manually, with optional parameter being access_to_check to scan the user's ID
/datum/computer_file/program/proc/can_run(var/list/accesses, var/mob/user, var/loud = 0)
	if(!requires_access_to_run)
		return TRUE

	if(get_file_perms(accesses, user) & OS_READ_ACCESS)
		return TRUE

	if(!istype(user))
		return FALSE

	if(loud)
		to_chat(user, SPAN_WARNING("The OS flashes an \"Access Denied\" warning."))
		return FALSE

// This attempts to retrieve header data for NanoUIs. If implementing completely new device of different type than existing ones
// always include the device here in this proc. This proc basically relays the request to whatever is running the program.
/datum/computer_file/program/proc/get_header_data(file_browser = FALSE)
	if(computer)
		return computer.get_header_data(file_browser)
	return list()

// This is performed on program startup. May be overriden to add extra logic. Remember to include ..() call.
// When implementing new program based device, use this to run the program.
/datum/computer_file/program/proc/on_startup(var/mob/living/user, var/datum/extension/interactive/os/new_host)
	program_state = PROGRAM_STATE_ACTIVE
	computer = new_host
	if(nanomodule_path)
		NM = new nanomodule_path(src, new /datum/topic_manager/program(src), src)
		if(user)
			NM.using_access = computer.get_access() // Nano modules nab access from users in their get_access() proc so don't bother adding it
													// to the using list as well.
	if(requires_network && network_destination)
		generate_network_log("Connection opened to [network_destination].")
	return 1

/datum/computer_file/program/proc/update_access()
	if(NM)
		NM.using_access = computer.get_access()

// Use this proc to kill the program. Designed to be implemented by each program if it requires on-quit logic, such as the NTNRC client.
/datum/computer_file/program/proc/on_shutdown(var/forced = 0)
	SHOULD_CALL_PARENT(TRUE)
	program_state = PROGRAM_STATE_KILLED
	if(network_destination)
		generate_network_log("Connection to [network_destination] closed.")
	if(NM)
		qdel(NM)
		NM = null
	return 1

// Called on active or minimized programs when a mounted file storage is removed from the OS.
/datum/computer_file/program/proc/on_file_storage_removal(var/datum/file_storage/removed)

// This is called every tick when the program is enabled. Ensure you do parent call if you override it. If parent returns 1 continue with UI initialisation.
// It returns 0 if it can't run or if NanoModule was used instead. I suggest using NanoModules where applicable.
/datum/computer_file/program/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	SHOULD_CALL_PARENT(TRUE)
	..()
	if(program_state < PROGRAM_STATE_ACTIVE) // Our program was closed. Close the ui if it exists.
		if(ui)
			ui.close()
		return computer.ui_interact(user)
	if(program_state == PROGRAM_STATE_BROWSER)
		return 0
	if(istype(NM))
		NM.ui_interact(user, ui_key, null, force_open)
		return 0
	return 1

/datum/nano_module/program/proc/get_records()
	var/datum/computer_network/network = program?.computer?.get_network()
	if(network)
		return network.get_crew_records()

// CONVENTIONS, READ THIS WHEN CREATING NEW PROGRAM AND OVERRIDING THIS PROC:
// Topic calls are automagically forwarded from NanoModule this program contains.
// Calls beginning with "PRG_" are reserved for programs handling.
// Calls beginning with "PC_" are reserved for computer handling (by whatever runs the program).
// Calls beginning with "BRS_" are reserved for program file browser handling (not to be confused with the file manager program).
// ALWAYS INCLUDE PARENT CALL ..() OR DIE IN FIRE.
/datum/computer_file/program/Topic(href, href_list)
	if(..())
		return 1
	if(computer)
		return computer.Topic(href, href_list)

// Relays the call to nano module, if we have one
/datum/computer_file/program/proc/check_eye(var/mob/user)
	if(NM)
		return NM.check_eye(user)
	else
		return -1

/datum/nano_module/program
	available_to_ai = FALSE
	var/datum/computer_file/program/program = null	// Program-Based computer program that runs this nano module. Defaults to null.

/datum/nano_module/program/New(var/host, var/topic_manager, var/program)
	..()
	src.program = program

/datum/nano_module/program/proc/get_network()
	return program.computer.get_network()

/datum/topic_manager/program
	var/datum/program

/datum/topic_manager/program/New(var/datum/program)
	..()
	src.program = program

// Calls forwarded to PROGRAM itself should begin with "PRG_"
// Calls forwarded to COMPUTER running the program should begin with "PC_"
/datum/topic_manager/program/Topic(href, href_list)
	return program && program.Topic(href, href_list)

/datum/computer_file/program/apply_visual(mob/M)
	if(NM)
		NM.apply_visual(M)

/datum/computer_file/program/remove_visual(mob/M)
	if(NM)
		NM.remove_visual(M)
