var/global/list/all_warrants

/datum/computer_file/program/digitalwarrant
	filename = "digitalwarrant"
	filedesc = "Warrant Assistant"
	extended_desc = "Official NTsec program for creation and handling of warrants."
	size = 8
	program_icon_state = "warrant"
	program_key_state = "security_key"
	program_menu_icon = "star"
	requires_network = 1
	available_on_network = 1
	required_access = list(access_security)
	nanomodule_path = /datum/nano_module/program/digitalwarrant/
	category = PROG_SEC

/datum/nano_module/program/digitalwarrant/
	name = "Warrant Assistant"
	var/datum/computer_file/report/warrant/active

/datum/nano_module/program/proc/get_warrants()
	var/datum/computer_network/network = program.computer.get_network()
	if(network)
		return network.get_all_files_of_type(/datum/computer_file/report/warrant)

/datum/nano_module/program/proc/remove_warrant(datum/computer_file/report/warrant/W)
	var/datum/computer_network/network = program.computer.get_network()
	if(network)
		return network.remove_file(W)

/datum/nano_module/program/proc/save_warrant(datum/computer_file/report/warrant/W)
	var/datum/computer_network/network = program.computer.get_network()
	if(network)
		return network.store_file(W)

/datum/nano_module/program/digitalwarrant/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()

	if(active)
		data["details"] = active.generate_nano_data(using_access)
	else
		for(var/datum/computer_file/report/warrant/W in global.all_warrants)
			LAZYADD(data[W.get_category()],  W.get_nano_summary())

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "digitalwarrant.tmpl", name, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/digitalwarrant/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["editwarrant"])
		. = 1
		for(var/datum/computer_file/report/warrant/W in global.all_warrants)
			if(W.uid == text2num(href_list["editwarrant"]))
				active = W
				break

	if(href_list["sendtoarchive"])
		. = 1
		for(var/datum/computer_file/report/warrant/W in global.all_warrants)
			if(W.uid == text2num(href_list["sendtoarchive"]))
				W.archived = TRUE
				break

	if(href_list["restore"])
		. = 1
		for(var/datum/computer_file/report/warrant/W in global.all_warrants)
			if(W.uid == text2num(href_list["restore"]))
				W.archived = FALSE
				break

	if(href_list["addwarrant"])
		. = 1
		var/datum/computer_file/report/warrant/W
		if(href_list["addwarrant"] == "arrest")
			W = new /datum/computer_file/report/warrant/arrest()
		else
			W = new /datum/computer_file/report/warrant/search()
		active = W

	if(href_list["savewarrant"])
		. = 1
		if(!active)
			return
		broadcast_security_hud_message("[active.get_broadcast_summary()] has been [(active in global.all_warrants) ? "edited" : "uploaded"].", nano_host())
		LAZYDISTINCTADD(global.all_warrants, active)
		active = null

	if(href_list["deletewarrant"])
		. = 1
		if(!active)
			for(var/datum/computer_file/report/warrant/W in global.all_warrants)
				if(W.uid == text2num(href_list["deletewarrant"]))
					active = W
					break
		LAZYREMOVE(global.all_warrants, active)
		active = null

	if(href_list["back"])
		. = 1
		active = null

	if(href_list["edit_field"])
		if(!active)
			return
		var/datum/report_field/F = active.field_from_ID(text2num(href_list["edit_field"]))
		if(!F)
			return
		if(!F.verify_access_edit(using_access))
			to_chat(usr, SPAN_WARNING("\The [nano_host()] flashes an \"Access Denied\" warning."))
			return
		F.ask_value(usr)
		return 1