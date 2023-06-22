/datum/computer_file/program/revelation
	filename = "revelation"
	filedesc = "Revelation"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "home"
	extended_desc = "This virus can destroy hard drive of system it is executed on. It may be obfuscated to look like another non-malicious program. Once armed, it will destroy the system upon next execution."
	size = 13
	available_on_network = 0
	nanomodule_path = /datum/nano_module/program/revelation/
	var/armed = 0

/datum/computer_file/program/revelation/on_startup(var/mob/living/user)
	. = ..(user)
	if(armed)
		activate()

/datum/computer_file/program/revelation/proc/activate()
	if(!computer)
		return

	computer.visible_error("Hardware error: Voltage reaching unsafe leve-")
	computer.system_shutdown()
	computer.voltage_overload()

/datum/computer_file/program/revelation/Topic(href, href_list)
	if(..())
		return 1
	else if(href_list["PRG_arm"])
		armed = !armed
	else if(href_list["PRG_activate"])
		activate()
	else if(href_list["PRG_obfuscate"])
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter new program name: "))
		if(!newname)
			return
		filedesc = newname
		var/datum/computer_network/net = computer.get_network()
		if(net)
			for(var/datum/computer_file/program/P in net.get_software_list())
				if(filedesc == P.filedesc)
					program_menu_icon = P.program_menu_icon
					break
	return 1

/datum/computer_file/program/revelation/PopulateClone(datum/computer_file/program/revelation/clone)
	clone = ..()
	clone.armed = armed
	return clone

/datum/nano_module/program/revelation
	name = "Revelation Virus"

/datum/nano_module/program/revelation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = list()
	var/datum/computer_file/program/revelation/PRG = program
	if(!istype(PRG))
		return

	data = PRG.get_header_data()

	data["armed"] = PRG.armed

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "revelation.tmpl", "Revelation Virus", 400, 250, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

