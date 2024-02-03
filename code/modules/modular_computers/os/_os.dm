/datum/extension/interactive/os
	base_type = /datum/extension/interactive/os
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE

	var/on = FALSE
	var/datum/computer_file/program/active_program = null	// A currently active program running on the computer.
	var/list/running_programs = list()						// All programms currently running, background or active.

	var/login												// The current network account login
	var/password											// The current network account password.
	var/weakref/current_account								// Reference to the current account to improve lookup speed.

	var/screen_icon_file									// dmi where the screen overlays are kept, defaults to holder's icon if unset
	var/menu_icon = "menu"									// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/screensaver_icon = "standby"
	var/default_icon = "generic"							//Overlay icon for programs that have a screen overlay the host doesn't have.
	var/os_name = "GOOSE"
	var/os_full_name = "GOOSE v2.0.4b"

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

/datum/extension/interactive/os/proc/get_access(var/mob/user)
	. = list()
	var/datum/computer_file/data/account/access_account = get_account()
	if(access_account)
		var/datum/computer_network/network = get_network()
		if(network)
			var/location = "[network.network_id]"
			. += "[access_account.login]@[location]" // User access uses '@'
			for(var/group in access_account.groups)
				. += "[group].[location]"	// Group access uses '.'
			for(var/group in access_account.parent_groups) // Membership in a child group grants access to anything with an access requirement set to the parent group.
				. += "[group].[location]"
	if(user)
		var/obj/item/card/id/I = user.GetIdCard()
		if(I)
			. += I.GetAccess(access_account?.login) // Ignore any access that's already on the user account.

// Returns the current account, if possible. User var is passed only for updating program access from ID, if no account is found.
/datum/extension/interactive/os/proc/get_account(var/mob/user)
	if(!current_account)
		return null
	var/datum/computer_file/data/account/check_account = current_account?.resolve()
	if(!istype(check_account))
		logout_account(user)
		return null
	if(check_account.login != login || check_account.password != password) // The most likely case - login or password were changed.
		logout_account(user)
		return null
	// Check if the account can be located on the network.
	var/datum/computer_network/network = get_network()
	if(!network || !(check_account in network.get_accounts_unsorted()))
		logout_account(user)
		return null
	return check_account

// Returns the current account without bothering to check if it can still be found.
/datum/extension/interactive/os/proc/get_account_nocheck()
	return current_account?.resolve()

/datum/extension/interactive/os/proc/login_account(var/new_login, var/new_password, var/mob/user)
	var/datum/computer_network/network = get_network()
	var/datum/computer_file/data/account/prev_acount = get_account(user)
	if(prev_acount)
		if(prev_acount.login == new_login && (prev_acount.password == new_password))
			return TRUE
		else // Log out of the current account first if we're trying to log into something else.
			logout_account(user)
	if(network)
		for(var/datum/computer_file/data/account/check_account in network.get_accounts())
			if(check_account.login == new_login && check_account.password == new_password)
				login = new_login
				password = new_password
				current_account = weakref(check_account)
				check_account.logged_in_os += weakref(src)

				for(var/datum/computer_file/program/P in running_programs)
					P.update_access(user)
				return TRUE

/datum/extension/interactive/os/proc/logout_account(var/mob/user)
	var/datum/computer_file/data/account/check_account = current_account?.resolve()
	if(check_account)
		check_account.logged_in_os -= weakref(src)
	current_account = null
	login = null
	password = null
	for(var/datum/computer_file/program/P in running_programs)
		P.update_access(user)

/datum/extension/interactive/os/proc/login_prompt(var/mob/user)
	var/obj/item/card/id/I = user.GetIdCard()
	var/default_login = I?.associated_network_account["login"]
	var/default_password = I?.associated_network_account["password"]

	var/new_login = sanitize(input(user, "Enter your account login:", "Account login", default_login) as text|null)
	if(!new_login || !CanUseTopic(user, global.default_topic_state))
		return
	var/new_password = sanitize(input(user, "Enter your account password:", "Account password", default_password) as text|null)
	if(!new_password || !CanUseTopic(user, global.default_topic_state))
		return

	if(login_account(new_login, new_password, user))
		to_chat(user, SPAN_NOTICE("Account login successful: Welcome [new_login]!"))
	else
		to_chat(user, SPAN_NOTICE("Account login failed: Check login or password."))

/datum/extension/interactive/os/proc/system_shutdown()
	on = FALSE
	for(var/datum/computer_file/program/P in running_programs)
		kill_program(P, 1)

	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		var/datum/extension/network_device/D = get_extension(network_card, /datum/extension/network_device)
		D?.disconnect()
	logout_account()

	if(updating)
		updating = FALSE
		updates = 0
		update_progress = 0
		var/obj/item/stock_parts/computer/hard_drive/hard_drive = get_component(PART_HDD)
		if(hard_drive)
			if(prob(10))
				hard_drive.visible_message("<span class='warning'>[src] emits some ominous clicks.</span>")
				hard_drive.take_damage(0.5 * hard_drive.current_health)
			else if(prob(5))
				hard_drive.visible_message("<span class='warning'>[src] emits some ominous clicks.</span>")
				hard_drive.take_damage(hard_drive.current_health)

	update_host_icon()

/datum/extension/interactive/os/proc/system_boot()
	on = TRUE
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
	var/datum/computer_file/program/P = get_file(filename, programs_dir)

	var/mob/user = usr
	if(!P || !istype(P)) // Program not found or it's not executable program.
		show_error(user, " - Unable to run [filename]")
		return

	if(!P.is_supported_by_hardware(get_hardware_flag(), user, TRUE))
		return

	if(P.requires_network)
		if(!get_network()) // No network at all
			show_error(user, "NETWORK ERROR - Unable to run [filename]")
			return
		if(!get_network_status(P.requires_network_feature))
			show_error(user, "NETWORK ERROR - Network rejected use of [filename] on your current connection")
			return

	minimize_program(user)

	if(P in running_programs)
		P.program_state = PROGRAM_STATE_ACTIVE
		active_program = P
	else if(P.can_run(get_access(user), user, TRUE))
		active_program = P
		P.on_startup(user, src)
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
	if(active_program.browser_module)
		SSnano.close_uis(active_program.browser_module)
	active_program = null
	update_host_icon()
	if(istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.

/datum/extension/interactive/os/proc/set_autorun(program)
	var/datum/computer_file/data/autorun = get_file("autorun", "local")
	if(istype(autorun))
		autorun.stored_data = "[program]"
	else
		create_file("autorun", "local", "[program]") // Autorun file is created in the root directory.

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
	return -1

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

/datum/extension/interactive/os/proc/mail_received(datum/computer_file/data/email_message/received)
	var/datum/computer_file/program/email_client/e_client = locate() in running_programs
	if(e_client)
		e_client.mail_received(received)

/datum/extension/interactive/os/proc/run_script(mob/user, var/datum/computer_file/data/script)
	open_terminal(user)
	var/datum/terminal/T = has_terminal(user)
	if(!istype(T))
		return  TOPIC_HANDLED

	T.show_terminal(user)
	T.append_to_history(">Running '[script.filename].[script.filetype]'")
	var/list/lines = splittext(script.stored_data, "\[br\]")
	for(var/line in lines)
		var/output = T.parse(line, user)
		if(QDELETED(T)) // Check for exit.
			return TOPIC_HANDLED
		T.append_to_history(output)
		CHECK_TICK