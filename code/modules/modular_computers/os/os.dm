/datum/extension/interactive/os
	base_type = /datum/extension/interactive/os
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/on = FALSE
	var/datum/computer_file/program/active_program = null	// A currently active program running on the computer.
	var/list/running_programs = list()						// All programms currently running, background or active.

	var/screen_icon_file									// dmi where the screen overlays are kept, defaults to holder's icon if unset
	var/menu_icon = "menu"									// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/screensaver_icon = "standby"

	// Used for deciding if various tray icons need to be updated
	var/last_battery_percent							
	var/last_world_time
	var/list/last_header_icons

	//Pain and suffering
	var/receives_updates = TRUE
	var/updating = FALSE
	var/updates = 0
	var/update_progress = 0
	var/update_postshutdown

	var/list/terminals

/datum/extension/interactive/os/Destroy()
	system_shutdown()
	. = ..()

/datum/extension/interactive/os/Process()
	if(on && !host_status())
		system_shutdown()
	if(!on)
		return
	if(updating)
		process_updates()
		return
	for(var/datum/computer_file/program/P in running_programs)
		if(P.requires_network && !get_network_status(P.requires_network_feature))
			P.event_networkfailure(P != active_program)
		else
			P.process_tick()
	regular_ui_update()

/datum/extension/interactive/os/proc/host_status()
	return TRUE

/datum/extension/interactive/os/proc/get_network()
	var/datum/extension/network_device/D = get_extension(get_component(PART_NETWORK), /datum/extension/network_device)
	if(D)
		return D.get_network()

/datum/extension/interactive/os/proc/system_shutdown()
	on = FALSE
	for(var/datum/computer_file/program/P in running_programs)
		kill_program(P, 1)
	
	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		var/datum/extension/network_device/D = get_extension(network_card, /datum/extension/network_device)
		D?.disconnect()

	if(updating)
		updating = FALSE
		updates = 0
		update_progress = 0
		var/obj/item/stock_parts/computer/hard_drive/hard_drive = get_component(PART_HDD)
		if(hard_drive)
			if(prob(10))
				hard_drive.visible_message("<span class='warning'>[src] emits some ominous clicks.</span>")
				hard_drive.take_damage(0.5 * hard_drive.health)
			else if(prob(5))
				hard_drive.visible_message("<span class='warning'>[src] emits some ominous clicks.</span>")
				hard_drive.take_damage(hard_drive.health)
	update_host_icon()

/datum/extension/interactive/os/proc/system_boot()
	on = TRUE
	var/datum/computer_file/data/autorun = get_file("autorun")
	if(istype(autorun))
		run_program(autorun.stored_data)
	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		var/datum/extension/network_device/D = get_extension(network_card, /datum/extension/network_device)
		D.connect()
	update_host_icon()

/datum/extension/interactive/os/proc/kill_program(var/datum/computer_file/program/P, var/forced = 0)
	if(!P)
		return
	P.on_shutdown(forced)
	running_programs -= P
	if(active_program == P)
		active_program = null
		if(ismob(usr))
			ui_interact(usr) // Re-open the UI on this computer. It should show the main screen now.
	update_host_icon()

/datum/extension/interactive/os/proc/run_program(filename)
	var/datum/computer_file/program/P = get_file(filename)

	var/mob/user = usr
	if(!P || !istype(P)) // Program not found or it's not executable program.
		show_error(user, "I/O ERROR - Unable to run [filename]")
		return

	if(!P.is_supported_by_hardware(get_hardware_flag(), user, TRUE))
		return

	minimize_program(user)

	if(P in running_programs)
		P.program_state = PROGRAM_STATE_ACTIVE
		active_program = P
	else if(P.can_run(user, 1, null, get_network()))
		P.on_startup(user, src)
		active_program = P
	else
		return
	running_programs |= P
	update_host_icon()
	return 1

/datum/extension/interactive/os/proc/minimize_program(mob/user)
	if(!active_program)
		return
	active_program.program_state = PROGRAM_STATE_BACKGROUND // Should close any existing UIs
	SSnano.close_uis(active_program.NM ? active_program.NM : active_program)
	active_program = null
	update_host_icon()
	if(istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.

/datum/extension/interactive/os/proc/set_autorun(program)
	var/datum/computer_file/data/autorun = get_file("autorun")
	if(istype(autorun))
		autorun.stored_data = "[program]"
	else
		create_file("autorun", "[program]")

/datum/extension/interactive/os/proc/add_log(var/text)
	var/datum/extension/network_device/D = get_extension(get_component(PART_NETWORK), /datum/extension/network_device)
	if(D)
		D.add_log(text)

/datum/extension/interactive/os/proc/get_physical_host()
	var/atom/A = holder
	if(istype(A))
		return A

/datum/extension/interactive/os/proc/handle_updates(shutdown_after)
	updating = TRUE
	update_progress = 0
	update_postshutdown = shutdown_after

// Used by camera monitor program
/datum/extension/interactive/os/proc/check_eye(var/mob/user)
	if(active_program)
		return active_program.check_eye(user)

/datum/extension/interactive/os/proc/process_updates()
	if(update_progress < updates)
		update_progress += rand(0, 2500)
		return

	//It's done.
	updating = FALSE
	update_host_icon()
	updates = 0
	update_progress = 0

	if(update_postshutdown)
		system_shutdown()

/datum/extension/interactive/os/proc/event_powerfailure()
	for(var/datum/computer_file/program/P in running_programs)
		P.event_powerfailure(P != active_program)

/datum/extension/interactive/os/proc/event_idremoved()
	for(var/datum/computer_file/program/P in running_programs)
		P.event_idremoved(P != active_program)

/datum/extension/interactive/os/proc/has_terminal(mob/user)
	for(var/datum/terminal/terminal in terminals)
		if(terminal.get_user() == user)
			return terminal

/datum/extension/interactive/os/proc/open_terminal(mob/user)
	if(!on)
		return
	if(has_terminal(user))
		return
	LAZYADD(terminals, new /datum/terminal/(user, src))

/datum/extension/interactive/os/proc/emagged()
	return FALSE

/datum/extension/interactive/os/proc/get_processing_power()
	var/obj/item/stock_parts/computer/processor_unit/CPU = get_component(PART_CPU)
	return CPU?.processing_power