//base type for controllers of two-door systems
/obj/machinery/embedded_controller/radio/airlock
	// Setup parameters only
	program = /datum/computer/file/embedded_program/airlock
	base_type = /obj/machinery/embedded_controller/radio/airlock/airlock_controller
	var/tag_exterior_door
	var/tag_interior_door
	var/tag_airpump
	var/tag_chamber_sensor
	var/tag_exterior_sensor
	var/tag_interior_sensor
	var/tag_secure = 0
	var/tag_air_alarm
	var/list/dummy_terminals = list() // Internal use only; set id_tag on the dummy terminal to be added.
	var/cycle_to_external_air = 0
	var/tag_pump_out_external
	var/tag_pump_out_internal

/obj/machinery/embedded_controller/radio/airlock/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(tag_exterior_door, map_hash)
	ADJUST_TAG_VAR(tag_interior_door, map_hash)
	ADJUST_TAG_VAR(tag_airpump, map_hash)
	ADJUST_TAG_VAR(tag_chamber_sensor, map_hash)
	ADJUST_TAG_VAR(tag_exterior_sensor, map_hash)
	ADJUST_TAG_VAR(tag_interior_sensor, map_hash)
	ADJUST_TAG_VAR(tag_air_alarm, map_hash)
	ADJUST_TAG_VAR(tag_pump_out_external, map_hash)
	ADJUST_TAG_VAR(tag_pump_out_internal, map_hash)

/obj/machinery/embedded_controller/radio/airlock/Destroy()
	for(var/obj/machinery/dummy_airlock_controller/terminal in dummy_terminals)
		terminal.on_master_destroyed()
	LAZYCLEARLIST(dummy_terminals)
	return ..()

/obj/machinery/embedded_controller/radio/airlock/CanUseTopic(var/mob/user)
	if(!allowed(user))
		return min(STATUS_UPDATE, ..())
	else
		return ..()

/**Adds a dummy remote controller to our list of dummy controllers. */
/obj/machinery/embedded_controller/radio/airlock/proc/add_remote_terminal(var/obj/machinery/dummy_airlock_controller/C)
	LAZYADD(dummy_terminals, C)

/**Removes a dummy remote controller from our list of dummy controllers. */
/obj/machinery/embedded_controller/radio/airlock/proc/remove_remote_terminal(var/obj/machinery/dummy_airlock_controller/C)
	LAZYREMOVE(dummy_terminals, C)

/obj/machinery/embedded_controller/radio/airlock/on_update_icon()
	. = ..()
	//Make sure we keep our terminals updated
	for(var/obj/machinery/dummy_airlock_controller/terminal in dummy_terminals)
		terminal.update_icon()

//Advanced airlock controller for when you want a more versatile airlock controller - useful for turning simple access control rooms into airlocks
/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller
	name = "Advanced Airlock Controller"
	base_type = /obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller

/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = global.default_topic_state)
	var/data[0]

	data = list(
		"chamber_pressure" = round(program.memory["chamber_sensor_pressure"]),
		"external_pressure" = round(program.memory["external_sensor_pressure"]),
		"internal_pressure" = round(program.memory["internal_sensor_pressure"]),
		"processing" = program.memory["processing"],
		"purge" = program.memory["purge"],
		"secure" = program.memory["secure"]
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "advanced_airlock_console.tmpl", name, 470, 360, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

//Airlock controller for airlock control - most airlocks on the station use this
/obj/machinery/embedded_controller/radio/airlock/airlock_controller
	name = "Airlock Controller"
	tag_secure = 1
	base_type = /obj/machinery/embedded_controller/radio/airlock/airlock_controller

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = global.default_topic_state)
	var/data[0]

	data = list(
		"chamber_pressure" = round(program.memory["chamber_sensor_pressure"]),
		"exterior_status" = program.memory["exterior_status"],
		"interior_status" = program.memory["interior_status"],
		"processing" = program.memory["processing"],
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "simple_airlock_console.tmpl", name, 470, 360, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

//Access controller for door control - used in virology and the like
/obj/machinery/embedded_controller/radio/airlock/access_controller
	name = "Access Controller"
	tag_secure = 1
	base_type = /obj/machinery/embedded_controller/radio/airlock/access_controller

/obj/machinery/embedded_controller/radio/airlock/access_controller/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = global.default_topic_state)
	var/data[0]

	data = list(
		"exterior_status" = program.memory["exterior_status"],
		"interior_status" = program.memory["interior_status"],
		"processing" = program.memory["processing"]
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "door_access_console.tmpl", name, 330, 220, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
