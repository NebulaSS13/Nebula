/datum/computer_file/program/atmos_control
	filename = "atmoscontrol"
	filedesc = "Atmosphere Control"
	nanomodule_path = /datum/nano_module/atmos_control
	program_icon_state = "atmos_control"
	program_key_state = "atmos_key"
	program_menu_icon = "shuffle"
	extended_desc = "This program allows remote control of air alarms. This program can not be run on tablet computers."
	read_access = list(access_atmospherics)
	requires_network = 1
	network_destination = "atmospheric control system"
	requires_network_feature = NET_FEATURE_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	category = PROG_ENG
	size = 17

/datum/nano_module/atmos_control
	name = "Atmospherics Control"
	var/list/monitored_alarms = list()
	var/list/filter_strings = list() // user weakref -> string filter
	var/list/alarm_data_cache = list() // user weakref -> cached camera data

/datum/nano_module/atmos_control/proc/set_monitored_alarms(monitored_alarm_ids) // you have to call this after creating the nanomodule if you want to set a custom list.
	for(var/obj/machinery/alarm/alarm in SSmachines.machinery)
		if(!monitored_alarm_ids || (alarm.alarm_id && (alarm.alarm_id in monitored_alarm_ids)))
			monitored_alarms += alarm
	monitored_alarms = dd_sortedObjectList(monitored_alarms)

/datum/nano_module/atmos_control/Topic(href, href_list, state)
	if(..())
		return 1

	if(href_list["alarm"])
		var/ui_ref = SSnano.get_open_ui(usr, src, "main")
		if(ui_ref)
			var/obj/machinery/alarm/alarm = locate(href_list["alarm"]) in (monitored_alarms.len ? monitored_alarms : SSmachines.machinery)
			if(istype(alarm))
				var/datum/topic_state/remote/TS = new (src, alarm, state)
				alarm.ui_interact(usr, master_ui = ui_ref, state = TS)
		return 1

	if(href_list["filter_set"])
		var/string = input(usr, "Set text filter:", "Filter Selection", filter_strings[weakref(usr)]) as null|text
		if(!CanInteract(usr, state))
			return TOPIC_REFRESH
		string = sanitize(string)
		string = lowertext(string)
		if(!string)
			filter_strings -= weakref(usr)
		else
			filter_strings[weakref(usr)] = string
		alarm_data_cache -= weakref(usr)
		return TOPIC_REFRESH

	if(href_list["refresh"])
		alarm_data_cache -= weakref(usr)
		return TOPIC_REFRESH

/datum/nano_module/atmos_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/master_ui = null, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	if(!length(monitored_alarms))
		set_monitored_alarms()

	var/list/alarms_data = alarm_data_cache[weakref(user)]
	var/filter = filter_strings[weakref(user)]

	if(!alarms_data)
		var/Z = get_host_z()
		var/list/alarms = list()
		var/list/alarmsAlert = list()
		var/list/alarmsDanger = list()

		for(var/obj/machinery/alarm/alarm in monitored_alarms)
			if (!Z || !SSmapping.are_connected_levels(Z, alarm.z))
				continue
			var/alarm_name = sanitize(alarm.name)
			alarm_name = replacetext(alarm_name, " Air Alarm", "") // shorten titles

			if(filter && !findtext(lowertext(alarm_name), filter))
				continue

			var/danger_level = max(alarm.danger_level, alarm.alarm_area.atmosalm)
			if(danger_level == 2)
				alarmsAlert[++alarmsAlert.len] = list("name" = alarm_name, "ref"= "\ref[alarm]", "danger" = danger_level)
			else if(danger_level == 1)
				alarmsDanger[++alarmsDanger.len] = list("name" = alarm_name, "ref"= "\ref[alarm]", "danger" = danger_level)
			else
				alarms[++alarms.len] = list("name" = alarm_name, "ref"= "\ref[alarm]", "danger" = danger_level)

		alarms_data = list()
		alarms_data["alarms"] =       sortTim(alarms,       /proc/cmp_list_name_key_asc)
		alarms_data["alarmsAlert"] =  sortTim(alarmsAlert,  /proc/cmp_list_name_key_asc)
		alarms_data["alarmsDanger"] = sortTim(alarmsDanger, /proc/cmp_list_name_key_asc)
		alarm_data_cache[weakref(user)] = alarms_data

	data += alarms_data
	data["filter"] = filter || "---"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "atmos_control.tmpl", src.name, 625, 625, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)