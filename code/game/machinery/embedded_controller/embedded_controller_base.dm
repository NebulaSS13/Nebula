/obj/machinery/embedded_controller
	name = "Embedded Controller"
	anchored = 1
	idle_power_usage = 10
	layer = ABOVE_WINDOW_LAYER
	clicksound = "button"
	var/datum/computer/file/embedded_program/program	//the currently executing program
	var/on = 1

/obj/machinery/embedded_controller/Initialize(mapload, d, populate_parts)
	if(ispath(program))
		program = new program(src)
	return ..()

/obj/machinery/embedded_controller/Destroy()
	if(istype(program))
		qdel(program) // the program will clear the ref in its Destroy
	return ..()

/obj/machinery/embedded_controller/proc/post_signal(datum/signal/signal, comm_line)
	return 0

/obj/machinery/embedded_controller/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!signal || signal.encryption) return

	if(program)
		program.receive_signal(signal, receive_method, receive_param)
	update_icon()
			//spawn(5) program.process() //no, program.process sends some signals and machines respond and we here again and we lag -rastaf0

/obj/machinery/embedded_controller/Topic(href, href_list)
	if(..())
		update_icon()
		return
	if(usr)
		usr.set_machine(src)
	if(program)
		return program.receive_user_command(href_list["command"]) // Any further sanitization should be done in here.

/obj/machinery/embedded_controller/Process()
	if(program)
		program.process()

/obj/machinery/embedded_controller/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/embedded_controller/radio
	icon                    = 'icons/obj/airlock_machines.dmi'
	icon_state              = "airlock_control_off"
	power_channel           = ENVIRON
	density                 = FALSE
	unacidable              = TRUE
	obj_flags               = OBJ_FLAG_MOVES_UNSUPPORTED
	construct_state         = /decl/machine_construction/wall_frame/panel_closed
	frame_type              = /obj/item/frame/button/airlock_controller
	base_type               = /obj/machinery/embedded_controller/radio/simple_docking_controller
	directional_offset      = "{'NORTH':{'y':-22}, 'SOUTH':{'y':24}, 'EAST':{'x':-22}, 'WEST':{'x':22}}"
	required_interaction_dexterity = DEXTERITY_TOUCHSCREENS
	var/frequency           = EXTERNAL_AIR_FREQ
	///Icon state of the screen used by dummy controllers to match the same state
	var/tmp/screen_state    = "screen_standby"
	///Bitflag to indicate which indicator lights are on so dummy controllers can match the same state
	var/tmp/indicator_state = 0
	///If set, this controller will route its commands to the master controller with the same id_tag.
	var/obj/machinery/embedded_controller/radio/master
	///Radio connection to use for emiting commands
	var/datum/radio_frequency/radio_connection

	//Indicator flags
	///Used to tell the "indicator_done" light should be lit up on the controller
	var/static/const/INDICATOR_FLAG_DONE   = BITFLAG(1)
	///Used to tell the "indicator_active" light should be lit up on the controller
	var/static/const/INDICATOR_FLAG_ACTIVE = BITFLAG(2)
	///Used to tell the "indicator_forced" light should be lit up on the controller
	var/static/const/INDICATOR_FLAG_FORCED = BITFLAG(3)

/obj/machinery/embedded_controller/radio/Initialize(mapload, d, populate_parts)
	. = ..()
	set_frequency(frequency)
	set_extension(src, /datum/extension/interactive/multitool/embedded_controller)
	update_icon()

/obj/machinery/embedded_controller/radio/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/embedded_controller/radio/on_update_icon()
	cut_overlays()
	screen_state = null
	indicator_state = 0
	if(!on || !istype(program) || inoperable())
		set_light(0)
		return
	if(!program.memory["processing"])
		screen_state = "screen_standby"
		indicator_state |= INDICATOR_FLAG_DONE
		set_light(l_range = 2, l_power = 0.5, l_color = "#3eac5c")
	else
		indicator_state |= INDICATOR_FLAG_ACTIVE

	var/datum/computer/file/embedded_program/docking/airlock/docking_program = program
	var/datum/computer/file/embedded_program/airlock/airlock_program = program
	if(istype(docking_program))
		if(docking_program.override_enabled)
			indicator_state |= INDICATOR_FLAG_FORCED
		airlock_program = docking_program.airlock_program

	if(istype(airlock_program) && airlock_program.memory["processing"])
		if(airlock_program.memory["pump_status"] == "siphon")
			screen_state = "screen_drain"
			set_light(l_range = 2, l_power = 0.5, l_color = "#bf3133")
		else
			screen_state = "screen_fill"
			set_light(l_range = 2, l_power = 0.5, l_color = "#4073e7")

	if(screen_state)
		add_overlay(screen_state)
	if(indicator_state & INDICATOR_FLAG_DONE)
		add_overlay("indicator_done")
	if(indicator_state & INDICATOR_FLAG_ACTIVE)
		add_overlay("indicator_active")
	if(indicator_state & INDICATOR_FLAG_FORCED)
		add_overlay("indicator_forced")

#define AIRLOCK_CONTROL_RANGE 22

/obj/machinery/embedded_controller/radio/post_signal(datum/signal/signal, var/radio_filter = null)
	if(radio_connection)
		return radio_connection.post_signal(src, signal, radio_filter, AIRLOCK_CONTROL_RANGE)
	else
		qdel(signal)

#undef AIRLOCK_CONTROL_RANGE

/obj/machinery/embedded_controller/radio/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	var/list/filters = program?.get_receive_filters()
	for(var/filter in filters)
		radio_connection = radio_controller.add_object(src, frequency, filter)
	update_icon()

// resets all id_tags (including in programs) based on the given tag.
/obj/machinery/embedded_controller/radio/proc/reset_id_tags(base_tag)
	id_tag = base_tag
	if(program)
		program.reset_id_tags(base_tag)
	update_icon()

/datum/extension/interactive/multitool/embedded_controller/get_interact_window(var/obj/item/multitool/M, var/mob/user)
	var/obj/machinery/embedded_controller/radio/controller = holder
	if(!istype(holder))
		return
	. = list()
	. += "ID tag: <a href='?src=\ref[src];set_tag=1'>[controller.id_tag]</a><br>"
	. += "Frequency: <a href='?src=\ref[src];set_freq=1'>[controller.frequency]</a><br>"
	. += "Likely tags used by controller:<br>"
	var/list/tags = controller.program?.get_receive_filters(TRUE)
	if(!length(tags))
		. += "None."
	else
		. += "<table>"
		for(var/tag in tags)
			. += "<tr>"
			. += "<td>[tags[tag]]</td>"
			. += "<td>[tag]</td>"
			. += "</tr>"
		. += "</table>"
	. = JOINTEXT(.)

/datum/extension/interactive/multitool/embedded_controller/on_topic(href, href_list, user)
	var/obj/machinery/embedded_controller/radio/controller = holder
	if(href_list["set_tag"])
		var/new_tag = input(user, "Enter a new tag to use. Warning: this will reset all tags used by this machine, not just the main one!", "Tag Selection", controller.id_tag) as text|null
		if(extension_status(user) != STATUS_INTERACTIVE)
			return MT_NOACTION
		new_tag = sanitize_name(new_tag, MAX_MESSAGE_LEN, TRUE, FALSE)
		if(new_tag)
			controller.reset_id_tags(new_tag)
			controller.set_frequency(controller.frequency)
			return MT_REFRESH

	if(href_list["set_freq"])
		var/new_frequency = input(user, "Enter a new frequency to use.", "frequency Selection", controller.frequency) as num|null
		if(!new_frequency || (extension_status(user) != STATUS_INTERACTIVE))
			return MT_NOACTION
		new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
		controller.set_frequency(new_frequency)
		return MT_REFRESH

/decl/stock_part_preset/radio/receiver/vent_pump/airlock
	frequency = EXTERNAL_AIR_FREQ
	filter    = null

/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock
	frequency = EXTERNAL_AIR_FREQ
	filter    = null

/obj/machinery/atmospherics/unary/vent_pump/airlock
	controlled                      = FALSE
	external_pressure_bound         = MAX_PUMP_PRESSURE
	external_pressure_bound_default = MAX_PUMP_PRESSURE
	internal_pressure_bound         = MAX_PUMP_PRESSURE
	internal_pressure_bound_default = MAX_PUMP_PRESSURE
	stock_part_presets              = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/airlock = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock = 1
	)

/obj/machinery/atmospherics/unary/vent_pump/cabled/airlock
	controlled                      = FALSE
	external_pressure_bound         = MAX_PUMP_PRESSURE
	external_pressure_bound_default = MAX_PUMP_PRESSURE
	internal_pressure_bound         = MAX_PUMP_PRESSURE
	internal_pressure_bound_default = MAX_PUMP_PRESSURE
	stock_part_presets              = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/airlock = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock = 1,
		/decl/stock_part_preset/terminal_connect/offset_dir = 1,
	)

/obj/machinery/atmospherics/unary/vent_pump/high_volume/airlock
	controlled                      = FALSE
	external_pressure_bound         = MAX_PUMP_PRESSURE
	external_pressure_bound_default = MAX_PUMP_PRESSURE
	internal_pressure_bound         = MAX_PUMP_PRESSURE
	internal_pressure_bound_default = MAX_PUMP_PRESSURE
	stock_part_presets              = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/airlock = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock = 1
	)
