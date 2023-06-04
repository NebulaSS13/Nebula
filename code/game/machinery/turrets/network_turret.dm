#define MAX_TURRET_LOGS 50
// Standard buildable model of turret.
/obj/machinery/turret/network
	name = "sentry turret"
	desc = "An automatic turret capable of identifying and dispatching targets using a mounted firearm."

	idle_power_usage = 5 KILOWATTS
	active_power_usage = 5 KILOWATTS // Determines how fast energy weapons can be recharged, so highly values are better.

	reloading_speed = 10

	installed_gun = null
	gun_looting_prob = 100

	traverse = 360
	turning_rate = 270

	base_type = /obj/machinery/turret/network
	construct_state = /decl/machine_construction/default/panel_closed
	stat_immune = NOSCREEN | NOINPUT

	hostility = /decl/hostility/turret/network

	// Targeting modes.
	var/check_access = FALSE
	var/check_weapons = FALSE
	var/check_records = FALSE
	var/check_arrest = FALSE
	var/check_lifeforms = FALSE

	var/list/logs

/obj/machinery/turret/network/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device/sentry_turret)

/obj/machinery/turret/network/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/stock_parts/computer/hard_drive/portable))
		if(!check_access(user))
			to_chat(user, SPAN_WARNING("\The [src] flashes a red light: you lack access to download its logfile."))
			return
		var/obj/item/stock_parts/computer/hard_drive/portable/drive = I
		var/datum/computer_file/data/logfile/turret_log = prepare_log_file()
		if(drive.store_file(turret_log) == OS_FILE_SUCCESS)
			to_chat(user, SPAN_NOTICE("\The [src] flashes a blue light as it downloads its log file onto \the [drive]!"))
		else
			to_chat(user, SPAN_WARNING("\The [src] flashes a red light: it failed to download its log file onto \the [drive]. Maybe it's full?"))

/obj/machinery/turret/network/RefreshParts()
	. = ..()
	active_power_usage = 5*clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 1, 5) KILOWATTS
	reloading_speed = 10*clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 1, 5)

	var/new_range = clamp(total_component_rating_of_type(/obj/item/stock_parts/scanning_module)*3, 4, 8)
	if(vision_range != new_range)
		vision_range = new_range
		proximity?.set_range(vision_range)

/obj/machinery/turret/network/proc/add_log(var/log_string)
	LAZYADD(logs, "([stationtime2text()], [stationdate2text()]) [log_string]")
	if(LAZYLEN(logs) > MAX_TURRET_LOGS)
		LAZYREMOVE(logs, LAZYACCESS(logs, 1))

/obj/machinery/turret/network/proc/prepare_log_file()
	var/datum/extension/network_device/turret = get_extension(src, /datum/extension/network_device)
	var/device_tag = turret.network_tag
	var/datum/computer_file/data/logfile/turret_log = new()
	turret_log.filename = "[device_tag]"
	turret_log.stored_data = "\[b\]Logfile of turret [device_tag]\[/b\]\[BR\]"
	for(var/log_string in logs)
		turret_log.stored_data += "[log_string]\[BR\]"
	turret_log.calculate_size()

	return turret_log

/obj/machinery/turret/network/add_target(atom/A)
	. = ..()
	if(.)
		add_log("Target Engaged: \the [A]")

/obj/machinery/turret/network/toggle_enabled()
	. = ..()
	if(.)
		add_log("Turret was [enabled ? "enabled" : "disabled"]")

/obj/machinery/turret/network/change_firemode(firemode_index)
	. = ..()
	if(.)
		if(installed_gun && length(installed_gun.firemodes))
			var/datum/firemode/current_mode = installed_gun.firemodes[firemode_index]
			add_log("Turret firing mode changed to [current_mode.name]")

/obj/machinery/turret/network/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, datum/topic_state/state = global.default_topic_state)
	var/data = list()
	data["network"] = TRUE
	data["enabled"] = enabled
	data["weaponName"] = installed_gun ? installed_gun.name : null
	data["currentBearing"] = current_bearing
	data["weaponHasFiremodes"] = installed_gun ? LAZYLEN(installed_gun.firemodes) : 0
	data["defaultBearing"] = isnull(default_bearing) ? "None" : default_bearing

	var/list/settings = list()
	settings[++settings.len] = list("category" = "Check Weapon Authorization", "setting" = "check_weapons", "value" = check_weapons)
	settings[++settings.len] = list("category" = "Check Security Records", "setting" = "check_records", "value" = check_records)
	settings[++settings.len] = list("category" = "Check Arrest Status", "setting" = "check_arrest", "value" = check_arrest)
	settings[++settings.len] = list("category" = "Check Access Authorization", "setting" = "check_access", "value" = check_access)
	settings[++settings.len] = list("category" = "Check misc. Lifeforms", "setting" = "check_lifeforms", "value" = check_lifeforms)

	data["settings"] = settings

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "turret.tmpl", "Turret Controls", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/turret/network/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["settings"])
		var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
		device?.ui_interact(user, state = state)
		return TOPIC_REFRESH

	if(href_list["targeting_comm"] && href_list["targeting_value"])
		var/targeting_bool = text2num(href_list["targeting_value"])
		switch(href_list["targeting_comm"])
			if("check_weapons")
				check_weapons = targeting_bool
			if("check_records")
				check_records = targeting_bool
			if("check_arrest")
				check_arrest = targeting_bool
			if("check_access")
				check_access = targeting_bool
			if("check_lifeforms")
				check_lifeforms = targeting_bool
		return TOPIC_REFRESH
	return ..()

/datum/extension/network_device/sentry_turret

/obj/item/stock_parts/circuitboard/sentry_turret
	name = "circuitboard (sentry turret)"
	board_type = "machine"
	build_path = /obj/machinery/turret/network
	origin_tech = "{'programming':5,'combat':5,'engineering':4}"
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 2)

#undef MAX_TURRET_LOGS