/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

//Request Console Screens
#define RCS_MAINMENU 0	// Main menu
#define RCS_RQASSIST 1	// Request supplies
#define RCS_RQSUPPLY 2	// Request assistance
#define RCS_SENDINFO 3	// Relay information
#define RCS_SENTPASS 4	// Message sent successfully
#define RCS_SENTFAIL 5	// Message sent unsuccessfully
#define RCS_VIEWMSGS 6	// View messages
#define RCS_MESSAUTH 7	// Authentication before sending
#define RCS_ANNOUNCE 8	// Send announcement

var/global/req_console_assistance = list()
var/global/req_console_supplies = list()
var/global/req_console_information = list()

/obj/machinery/network/requests_console
	name = "Requests Console"
	desc = "A console intended to send requests to different departments."
	anchored = TRUE
	density = FALSE
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp0"
	var/department = "Unknown" //The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/list/message_log = list() //List of all messages
	var/newmessagepriority = 0
		// 0 = no new message
		// 1 = normal priority
		// 2 = high priority
	var/screen = RCS_MAINMENU
	var/silent = 0 // set to 1 for it not to beep all the time
	var/announcementConsole = 0
		// 0 = This console cannot be used to send department announcements
		// 1 = This console can send department announcementsf
	var/open = 0 // 1 if open
	var/announceAuth = 0 //Will be set to 1 when you authenticate yourself for announcements
	var/msgVerified = "" //Will contain the name of the person who varified it
	var/msgStamped = "" //If a message is stamped, this will contain the stamp name
	var/message = ""
	var/recipient = "" //the department which will be receiving the message
	var/priority = -1 //Priority of the message being sent
	light_range = 0
	var/datum/announcement/announcement = new

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/wall_frame/panel_closed
	frame_type = /obj/item/frame/stock_offset/request_console

/obj/machinery/network/requests_console/on_update_icon()
	if(stat & NOPOWER)
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(icon_state == "req_comp_off")
			icon_state = "req_comp[newmessagepriority]"

/obj/machinery/network/requests_console/Initialize(mapload, d)
	. = ..()
	announcement.newscast = 1
	// Try and find it; this is legacy mapping compatibility for the most part.
	var/decl/department/dept = SSjobs.get_department_by_name(department)
	if(dept)
		set_department(dept)
	else
		var/found_name = FALSE
		var/list/all_departments = decls_repository.get_decls_of_subtype(/decl/department)
		for(var/key in all_departments)
			var/decl/department/candidate = all_departments[key]
			if(lowertext(candidate.name) == lowertext(department))
				set_department(candidate)
				found_name = TRUE
				break
		if(!found_name)
			set_department(department)
	set_light(1)

/obj/machinery/network/requests_console/proc/set_department(var/decl/department/_department)
	if(istype(_department))
		department = _department.name
		announcement.title = "[_department.name] announcement"
		SetName("[_department.name] Requests Console")
	else if(istext(department))
		department = _department
		announcement.title = "[_department] announcement"
		SetName("[_department] Requests Console")

/obj/machinery/network/requests_console/Destroy()
	. = ..()

/obj/machinery/network/requests_console/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/network/requests_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["department"] = department
	data["screen"] = screen
	data["message_log"] = message_log
	data["newmessagepriority"] = newmessagepriority
	data["silent"] = silent
	data["announcementConsole"] = announcementConsole

	data["assist_dept"] = req_console_assistance
	data["supply_dept"] = req_console_supplies
	data["info_dept"]   = req_console_information

	data["message"] = message
	data["recipient"] = recipient
	data["priortiy"] = priority
	data["msgStamped"] = msgStamped
	data["msgVerified"] = msgVerified
	data["announceAuth"] = announceAuth

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "request_console.tmpl", name, 520, 410)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/network/requests_console/OnTopic(user, href_list)
	if(reject_bad_text(href_list["write"]))
		recipient = href_list["write"] //write contains the string of the receiving department's name

		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
			screen = RCS_MESSAUTH
			switch(href_list["priority"])
				if("1") priority = 1
				if("2")	priority = 2
				else	priority = 0
		else
			reset_message(1)
		return TOPIC_REFRESH

	if(href_list["writeAnnouncement"])
		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
		else
			reset_message(1)
		return TOPIC_REFRESH

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)	return
		announcement.Announce(message, msg_sanitized = 1)
		reset_message(1)
		return TOPIC_REFRESH

	if( href_list["department"] && message )
		var/log_msg = message
		screen = RCS_SENTFAIL
		var/obj/machinery/network/message_server/MS = get_message_server(get_z(src))
		if(MS)
			if(MS.send_rc_message(ckey(href_list["department"]),department,log_msg,msgStamped,msgVerified,priority))
				screen = RCS_SENTPASS
				message_log += "<B>Message sent to [recipient]</B><BR>[message]"
		else
			audible_message("[html_icon(src)] *The Requests Console beeps: 'NOTICE: No server detected!'", null, 4)
		return TOPIC_REFRESH

	//Handle screen switching
	if(href_list["setScreen"])
		var/tempScreen = text2num(href_list["setScreen"])
		if(tempScreen == RCS_ANNOUNCE && !announcementConsole)
			return
		if(tempScreen == RCS_VIEWMSGS)
			var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
			var/datum/computer_network/network = network_device?.get_network()
			for(var/datum/extension/network_device/console in network?.devices)
				var/obj/machinery/network/requests_console/Console = console.holder
				if(istype(Console) && Console.department == department)
					Console.newmessagepriority = 0
					Console.icon_state = "req_comp0"
					Console.set_light(1)
		if(tempScreen == RCS_MAINMENU)
			reset_message()
		screen = tempScreen
		return TOPIC_REFRESH

	//Handle silencing the console
	if(href_list["toggleSilent"])
		silent = !silent
		return TOPIC_REFRESH

	if(href_list["set_department"])
		var/list/choices = list()
		var/list/all_departments = decls_repository.get_decls_of_subtype(/decl/department)
		for(var/dtype in all_departments)
			choices += all_departments[dtype]
		var/choice = input(user, "Select a new department from the list:", "Department Selection", department) as null|anything in (choices + "Custom")
		if(!CanPhysicallyInteract(user))
			return TOPIC_HANDLED
		if(choice == "Custom")
			var/input = input(user, "Enter a custom name:", "Custom Selection", department) as null|text
			if(!CanPhysicallyInteract(user))
				return TOPIC_HANDLED
			if(!input)
				return TOPIC_HANDLED
			sanitize(input)
			set_department(input)
			return TOPIC_REFRESH
		else if(!istype(choice, /decl/department))
			return TOPIC_HANDLED
		set_department(choice)
		return TOPIC_REFRESH

/obj/machinery/network/requests_console/attackby(var/obj/item/O, var/mob/user)
	if (istype(O, /obj/item/card/id))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/card/id/T = O
			msgVerified = text("<font color='green'><b>Verified by [T.registered_name] ([T.assignment])</b></font>")
			SSnano.update_uis(src)
		if(screen == RCS_ANNOUNCE)
			var/obj/item/card/id/ID = O
			if (access_RC_announce in ID.GetAccess())
				announceAuth = 1
				announcement.announcer = ID.assignment ? "[ID.assignment] [ID.registered_name]" : ID.registered_name
			else
				reset_message()
				to_chat(user, "<span class='warning'>You are not authorized to send announcements.</span>")
			SSnano.update_uis(src)
	if (istype(O, /obj/item/stamp))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/stamp/T = O
			msgStamped = text("<font color='blue'><b>Stamped with the [T.name]</b></font>")
			SSnano.update_uis(src)
	return ..()

/obj/machinery/network/requests_console/proc/reset_message(var/mainmenu = 0)
	message = ""
	recipient = ""
	priority = 0
	msgVerified = ""
	msgStamped = ""
	announceAuth = 0
	announcement.announcer = ""
	if(mainmenu)
		screen = RCS_MAINMENU
