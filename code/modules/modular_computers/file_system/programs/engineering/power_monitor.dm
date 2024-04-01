/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitoring"
	nanomodule_path = /datum/nano_module/program/power_monitor/
	program_icon_state = "power_monitor"
	program_key_state = "power_key"
	program_menu_icon = "battery-3"
	extended_desc = "This program connects to sensors to provide information about electrical systems"
	ui_header = "power_norm.gif"
	read_access = list(access_engine)
	requires_network = 1
	requires_network_feature = NET_FEATURE_SYSTEMCONTROL
	network_destination = "power monitoring system"
	size = 9
	category = PROG_ENG
	var/has_alert = 0

/datum/computer_file/program/power_monitor/process_tick()
	..()
	var/datum/nano_module/program/power_monitor/NMA = NM
	if(istype(NMA) && NMA.has_alarm())
		if(!has_alert)
			program_icon_state = "power_monitor_warn"
			ui_header = "power_warn.gif"
			update_computer_icon()
			has_alert = 1
	else
		if(has_alert)
			program_icon_state = "power_monitor"
			ui_header = "power_norm.gif"
			update_computer_icon()
			has_alert = 0

/datum/nano_module/program/power_monitor
	name = "Power monitor"
	var/list/grid_sensors
	var/active_sensor = null	//name_tag of the currently selected sensor

/datum/nano_module/program/power_monitor/New()
	..()
	refresh_sensors()

/datum/nano_module/program/power_monitor/Destroy()
	for(var/grid_sensor in grid_sensors)
		remove_sensor(grid_sensor, FALSE)
	grid_sensors = null
	. = ..()

// Checks whether there is an active alarm, if yes, returns 1, otherwise returns 0.
/datum/nano_module/program/power_monitor/proc/has_alarm()
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(S.check_grid_warning())
			return 1
	return 0

// If PC is not null header template is loaded. Use PC.get_header_data() to get relevant nanoui data from it. All data entries begin with "PC_...."
// In future it may be expanded to other modular computer devices.
/datum/nano_module/program/power_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()

	var/list/sensors = list()
	// Focus: If it remains null if no sensor is selected and UI will display sensor list, otherwise it will display sensor reading.
	var/obj/machinery/power/sensor/focus = null

	// Build list of data from sensor readings.
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		sensors.Add(list(list(
		"name" = html_encode(S.id_tag),
		"alarm" = S.check_grid_warning()
		)))
		if(S.id_tag == active_sensor)
			focus = S

	data["all_sensors"] = sensors
	if(focus)
		data["focus"] = focus.return_reading_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "power_monitor.tmpl", "Power Monitoring Console", 800, 500, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// Refreshes list of active sensors kept on this computer.
/datum/nano_module/program/power_monitor/proc/refresh_sensors()
	grid_sensors = list()
	var/connected_z_levels = SSmapping.get_connected_levels(get_host_z())
	for(var/obj/machinery/power/sensor/S in SSmachines.machinery)
		if(get_z(S) in connected_z_levels) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
			grid_sensors += S
			events_repository.register(/decl/observ/destroyed, S, src, TYPE_PROC_REF(/datum/nano_module/program/power_monitor, remove_sensor))

/datum/nano_module/program/power_monitor/proc/remove_sensor(var/removed_sensor, var/update_ui = TRUE)
	if(active_sensor == removed_sensor)
		active_sensor = null
		if(update_ui)
			SSnano.update_uis(src)
	grid_sensors -= removed_sensor
	events_repository.unregister(/decl/observ/destroyed, removed_sensor, src, TYPE_PROC_REF(/datum/nano_module/program/power_monitor, remove_sensor))

/datum/nano_module/program/power_monitor/proc/is_sysadmin(var/mob/user)
	if(program)
		has_access(list(access_network), get_access(user))
	return FALSE

// Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/nano_module/program/power_monitor/Topic(href, href_list, state)
	if(..())
		return 1

	var/mob/user = usr

	if( href_list["clear"] )
		active_sensor = null
		. = 1
	if( href_list["refresh"] )
		refresh_sensors()
		. = 1

	if(href_list["toggle_breaker"])
		var/obj/machinery/power/apc/A = locate(href_list["toggle_breaker"])

		if(!CanInteract(user, state) || QDELETED(A))
			return 0

		A.toggle_breaker()

	if(href_list["toggle_powerchannel_equip"] || href_list["toggle_powerchannel_light"] || href_list["toggle_powerchannel_enviro"]) //I'm sure there's a better way to do this.
		var/obj/machinery/power/apc/A
		var/powerchannel = 0
		var/power_setting

		if(href_list["toggle_powerchannel_equip"])
			A = locate(href_list["toggle_powerchannel_equip"])
			powerchannel = APC_POWERCHAN_EQUIPMENT

		if(href_list["toggle_powerchannel_light"])
			A = locate(href_list["toggle_powerchannel_light"])
			powerchannel = APC_POWERCHAN_LIGHTING

		if(href_list["toggle_powerchannel_enviro"])
			A = locate(href_list["toggle_powerchannel_enviro"])
			powerchannel = APC_POWERCHAN_ENVIRONMENT

		if(A.is_critical && !is_sysadmin(user))
			to_chat(user, SPAN_WARNING("Unsyndicated connections require system administrator access."))
			return 0

		var/list/answers_list = list("ON", "OFF", "AUTO")
		var/input = input("Select a power channel mode.", "Power Channel Mode") as null|anything in answers_list

		if(!CanInteract(user, state) || QDELETED(A))
			return 0

		switch(input)
			if("ON")
				power_setting = POWERCHAN_ON
			if("OFF")
				power_setting = POWERCHAN_OFF
			if("AUTO")
				power_setting = POWERCHAN_ON_AUTO

		A.set_channel_state_manual(powerchannel, power_setting)


	else if( href_list["setsensor"] )
		active_sensor = html_decode(href_list["setsensor"])
		. = 1
