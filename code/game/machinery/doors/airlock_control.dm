#define AIRLOCK_CONTROL_RANGE 22

// This code allows for airlocks to be controlled externally by setting an id_tag and comm frequency (disables ID access)
/obj/machinery/door/airlock
	var/frequency
	var/shockedby = list()
	var/datum/radio_frequency/radio_connection
	var/cur_command = null	//the command the door is currently attempting to complete

/obj/machinery/door/airlock/Process()
	if (arePowerSystemsOn())
		execute_current_command()
	return ..()

/obj/machinery/door/airlock/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	if(id_tag != signal.data["tag"] || !signal.data["command"]) return

	command(signal.data["command"])

/obj/machinery/door/airlock/proc/command(var/new_command)
	cur_command = new_command

	//if there's no power, recieve the signal but just don't do anything. This allows airlocks to continue to work normally once power is restored
	if(arePowerSystemsOn())
		execute_current_command()

/obj/machinery/door/airlock/proc/execute_current_command()
	set waitfor = FALSE
	if(operating)
		return //emagged or busy doing something else

	if (!cur_command)
		return

	do_command(cur_command)
	if (command_completed(cur_command))
		cur_command = null

/obj/machinery/door/airlock/proc/do_command(var/command)
	switch(command)
		if("open")
			open()

		if("close")
			close()

		if("unlock")
			unlock()

		if("lock")
			lock()

		if("secure_open")
			unlock()

			sleep(2)
			open()

			lock()

		if("secure_close")
			unlock()
			close()

			lock()
			sleep(2)

	send_status()

/obj/machinery/door/airlock/proc/command_completed(var/command)
	switch(command)
		if("open")
			return (!density)

		if("close")
			return density

		if("unlock")
			return !locked

		if("lock")
			return locked

		if("secure_open")
			return (locked && !density)

		if("secure_close")
			return (locked && density)

	return 1	//Unknown command. Just assume it's completed.

/obj/machinery/door/airlock/proc/send_status(var/bumped = 0)
	if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		signal.data["door_status"] = density?("closed"):("open")
		signal.data["lock_status"] = locked?("locked"):("unlocked")

		if (bumped)
			signal.data["bumped_with_access"] = 1

		radio_connection.post_signal(src, signal, id_tag, AIRLOCK_CONTROL_RANGE)


/obj/machinery/door/airlock/open(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


/obj/machinery/door/airlock/close(surpress_send)
	. = ..()
	if(!surpress_send) send_status()

/obj/machinery/door/airlock/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	if(new_frequency)
		frequency = new_frequency
		radio_connection = radio_controller.add_object(src, frequency, id_tag)

/obj/machinery/door/airlock/Initialize()
	. = ..()
	if(frequency)
		set_frequency(frequency)

	update_icon()

/obj/machinery/door/airlock/Destroy()
	if(frequency && radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/airlock_sensor
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "airlock sensor"

	anchored = 1
	power_channel = ENVIRON
	public_variables = list(
		/decl/public_access/public_variable/airlock_pressure,
		/decl/public_access/public_variable/input_toggle
	)
	public_methods = list(/decl/public_access/public_method/toggle_input_toggle)
	stock_part_presets = list(/decl/stock_part_preset/radio/basic_transmitter/airlock_sensor = 1)
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/radio/transmitter/basic/buildable
	)
	base_type = /obj/machinery/airlock_sensor/buildable
	construct_state = /decl/machine_construction/wall_frame/panel_closed/simple
	frame_type = /obj/item/frame/button/airlock_sensor

	var/alert = 0
	var/pressure

/obj/machinery/airlock_sensor/buildable
	uncreated_component_parts = null

/obj/machinery/airlock_sensor/on_update_icon()
	if(!(stat & (NOPOWER | BROKEN)))
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/airlock_sensor/Process()
	if(!(stat & (NOPOWER | BROKEN)))
		var/datum/gas_mixture/air_sample = return_air()
		var/new_pressure = round(air_sample.return_pressure(),0.1)

		if(abs(pressure - new_pressure) > 0.001 || pressure == null)
			var/decl/public_access/public_variable/airlock_pressure/pressure_var = decls_repository.get_decl(/decl/public_access/public_variable/airlock_pressure)
			pressure_var.write_var(src, pressure)

			var/new_alert = (pressure < ONE_ATMOSPHERE*0.8)
			if(new_alert != alert)
				alert = new_alert
				update_icon()

/decl/public_access/public_variable/airlock_pressure
	expected_type = /obj/machinery/airlock_sensor
	name = "airlock sensor pressure"
	desc = "The pressure of the location where the sensor is placed."
	can_write = FALSE
	has_updates = TRUE
	var_type = IC_FORMAT_NUMBER

/decl/public_access/public_variable/airlock_pressure/access_var(obj/machinery/airlock_sensor/sensor)
	return sensor.pressure

/decl/public_access/public_variable/airlock_pressure/write_var(obj/machinery/airlock_sensor/sensor, new_val)
	. = ..()
	if(.)
		sensor.pressure = new_val

/decl/stock_part_preset/radio/basic_transmitter/airlock_sensor
	frequency = EXTERNAL_AIR_FREQ
	transmit_on_change = list(
		"pressure" = /decl/public_access/public_variable/airlock_pressure
	)

/decl/stock_part_preset/radio/basic_transmitter/airlock_sensor/shuttle
	frequency = SHUTTLE_AIR_FREQ

/obj/machinery/airlock_sensor/shuttle
	stock_part_presets = list(/decl/stock_part_preset/radio/basic_transmitter/airlock_sensor/shuttle = 1)

/obj/machinery/button/access
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_button_standby"
	name = "access button"
	interact_offline = TRUE
	public_variables = list(
		/decl/public_access/public_variable/button_active,
		/decl/public_access/public_variable/button_state,
		/decl/public_access/public_variable/input_toggle,
		/decl/public_access/public_variable/button_command
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/event_transmitter/access_button = 1
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable
	)
	var/command = "cycle"

/obj/machinery/button/access/on_update_icon()
	if(stat & (NOPOWER | BROKEN))
		icon_state = "access_button_off"
	else if(operating)
		icon_state = "access_button_cycle"
	else
		icon_state = "access_button_standby"

/obj/machinery/button/access/interior
	command = "cycle_interior"

/obj/machinery/button/access/exterior
	command = "cycle_exterior"

/obj/machinery/button/access/shuttle
	stock_part_presets = list(
		/decl/stock_part_preset/radio/event_transmitter/access_button/shuttle = 1
	)

/obj/machinery/button/access/shuttle/interior
	command = "cycle_interior"

/obj/machinery/button/access/shuttle/exterior
	command = "cycle_exterior"

/decl/public_access/public_variable/button_command
	expected_type = /obj/machinery/button/access
	name = "button command"
	desc = "The command this access button sends when pressed."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_STRING

/decl/public_access/public_variable/button_command/access_var(obj/machinery/button/access/button)
	return button.command

/decl/public_access/public_variable/button_command/write_var(obj/machinery/button/access/button, new_val)
	. = ..()
	if(.)
		button.command = new_val

/decl/stock_part_preset/radio/event_transmitter/access_button
	frequency = EXTERNAL_AIR_FREQ
	event = /decl/public_access/public_variable/button_active
	transmit_on_event = list(
		"command" = /decl/public_access/public_variable/button_command
	)

/decl/stock_part_preset/radio/event_transmitter/access_button/shuttle
	frequency = SHUTTLE_AIR_FREQ