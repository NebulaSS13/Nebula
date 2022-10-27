/datum/computer_file/program/shutoff_valve
	filename = "shutoffcontrol"
	filedesc = "Automatic Shutoff Valve Monitoring"
	nanomodule_path = /datum/nano_module/program/shutoff_monitor
	program_icon_state = "atmos_control"
	program_key_state = "atmos_key"
	program_menu_icon = "shuffle"
	extended_desc = "This program allows remote control and monitoring of shutoff valves."
	read_access = list(access_atmospherics)
	requires_network = 1
	requires_network_feature = NET_FEATURE_SYSTEMCONTROL
	network_destination = "atmospheric control system"
	category = PROG_ENG
	size = 10

/datum/nano_module/program/shutoff_monitor
	name = "Shutoff valve monitor"

/datum/nano_module/program/shutoff_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/list/data = host.initial_data()
	var/list/z_valves = list()
	var/list/zs = SSmapping.get_connected_levels(get_z(nano_host()))

	for(var/obj/machinery/atmospherics/valve/shutoff/S in shutoff_valves)
		if(S.z in zs)
			z_valves += S

	data["valves"] = list()
	for(var/obj/machinery/atmospherics/valve/shutoff/S in z_valves)
		data["valves"][++data["valves"].len] = list("name" = S.name, "enable" = S.close_on_leaks, "open" = S.open, "location" = get_area(S), "ref" = "\ref[S]")

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shutoff_monitor.tmpl", "Shutoff Valve Monitoring", 800, 500, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/shutoff_monitor/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["toggle_enable"])
		var/obj/machinery/atmospherics/valve/shutoff/S = locate(href_list["toggle_enable"])

		// Invalid ref
		if(!istype(S) || QDELETED(S))
			return 1

		S.close_on_leaks = !S.close_on_leaks

	return


