//a docking port that uses a single door
/obj/machinery/embedded_controller/radio/simple_docking_controller
	name = "docking hatch controller"
	program = /datum/computer/file/embedded_program/docking/simple
	var/tag_door

/obj/machinery/embedded_controller/radio/simple_docking_controller/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(tag_door, map_hash)

/obj/machinery/embedded_controller/radio/simple_docking_controller/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = global.default_topic_state)
	var/data[0]
	var/datum/computer/file/embedded_program/docking/simple/docking_program = program

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = 	docking_program.memory["door_status"]["state"],
		"door_lock" = 	docking_program.memory["door_status"]["lock"],
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "simple_docking_console.tmpl", name, 470, 290, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple
	var/tag_door

/datum/computer/file/embedded_program/docking/simple/New(var/obj/machinery/embedded_controller/M)
	..(M)
	memory["door_status"] = list(state = "closed", lock = "locked")		//assume closed and locked in case the doors dont report in

/datum/computer/file/embedded_program/docking/simple/reset_id_tags(base_tag)
	. = ..()
	if (istype(master, /obj/machinery/embedded_controller/radio/simple_docking_controller))
		var/obj/machinery/embedded_controller/radio/simple_docking_controller/controller = master

		tag_door = (!base_tag && controller.tag_door) || "[id_tag]_hatch"

		spawn(10)
			signalDoor()		//signals connected doors to update their status

/datum/computer/file/embedded_program/docking/simple/get_receive_filters()
	. = ..()
	.[tag_door] = "doors"

/datum/computer/file/embedded_program/docking/simple/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]

	if(!receive_tag) return

	if(receive_tag==tag_door)
		if("door_status" in signal.data)
			memory["door_status"]["state"] = signal.data["door_status"]
		if("lock_status" in signal.data)
			memory["door_status"]["lock"] = signal.data["lock_status"]

	..(signal, receive_method, receive_param)

/datum/computer/file/embedded_program/docking/simple/receive_user_command(command)
	. = TRUE
	switch(command)
		if("force_door")
			if (override_enabled)
				toggleDoor(memory["door_status"], tag_door, TRUE, "toggle")
		if("toggle_override")
			if (override_enabled)
				disable_override()
			else
				enable_override()
		else
			. = FALSE

//tell the docking port to start getting ready for docking - e.g. pressurize
/datum/computer/file/embedded_program/docking/simple/prepare_for_docking()
	return		//don't need to do anything

//are we ready for docking?
/datum/computer/file/embedded_program/docking/simple/ready_for_docking()
	return 1	//don't need to do anything

//we are docked, open the doors or whatever.
/datum/computer/file/embedded_program/docking/simple/finish_docking()
	toggleDoor(memory["door_status"], tag_door, TRUE, "open")

//tell the docking port to start getting ready for undocking - e.g. close those doors.
/datum/computer/file/embedded_program/docking/simple/prepare_for_undocking()
	toggleDoor(memory["door_status"], tag_door, TRUE, "close")

//are we ready for undocking?
/datum/computer/file/embedded_program/docking/simple/ready_for_undocking()
	return (memory["door_status"]["state"] == "closed" && memory["door_status"]["lock"] == "locked")

/*** DEBUG VERBS ***

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/view_state()
	set category = "Debug"
	set src in view(1)
	src.program:print_state()

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/spoof_signal(var/command as text, var/sender as text)
	set category = "Debug"
	set src in view(1)
	var/datum/signal/signal = new
	signal.data["tag"] = sender
	signal.data["command"] = command
	signal.data["recipient"] = id_tag

	src.program:receive_signal(signal)

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/debug_init_dock(var/target as text)
	set category = "Debug"
	set src in view(1)
	src.program:initiate_docking(target)

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/debug_init_undock()
	set category = "Debug"
	set src in view(1)
	src.program:initiate_undocking()

*/