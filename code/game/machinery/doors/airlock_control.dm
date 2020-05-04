
// Public access

/obj/machinery/door/airlock
	public_methods = list(
		/decl/public_access/public_method/toggle_door,
		/decl/public_access/public_method/airlock_toggle_bolts,
		/decl/public_access/public_method/open_door,
		/decl/public_access/public_method/close_door,
		/decl/public_access/public_method/airlock_unlock,
		/decl/public_access/public_method/airlock_lock,
		/decl/public_access/public_method/toggle_input_toggle
	)
	public_variables = list(
		/decl/public_access/public_variable/input_toggle,
		/decl/public_access/public_variable/airlock_door_state,
		/decl/public_access/public_variable/airlock_bolt_state
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock = 1,
		/decl/stock_part_preset/radio/event_transmitter/airlock =1
	)

/decl/stock_part_preset/radio/receiver/airlock
	frequency = AIRLOCK_FREQ
	receive_and_call = list(
		"toggle_door" = /decl/public_access/public_method/toggle_door,
		"toggle_bolts" = /decl/public_access/public_method/airlock_toggle_bolts,
		"unlock" = /decl/public_access/public_method/airlock_unlock,
		"open" = /decl/public_access/public_method/open_door,
		"close" = /decl/public_access/public_method/close_door,
		"lock" = /decl/public_access/public_method/airlock_lock,
		"status" = /decl/public_access/public_method/toggle_input_toggle
	)

/decl/stock_part_preset/radio/event_transmitter/airlock
	frequency = AIRLOCK_FREQ
	event = /decl/public_access/public_variable/input_toggle
	transmit_on_event = list(
		"door_status" = /decl/public_access/public_variable/airlock_door_state,
		"lock_status" = /decl/public_access/public_variable/airlock_bolt_state
	)

/decl/stock_part_preset/radio/receiver/airlock/external_air
	frequency = EXTERNAL_AIR_FREQ

/decl/stock_part_preset/radio/event_transmitter/airlock/external_air
	frequency = EXTERNAL_AIR_FREQ

/decl/stock_part_preset/radio/receiver/airlock/shuttle
	frequency = SHUTTLE_AIR_FREQ

/decl/stock_part_preset/radio/event_transmitter/airlock/shuttle
	frequency = SHUTTLE_AIR_FREQ

/decl/public_access/public_method/airlock_lock
	name = "engage bolts"
	desc = "Bolts the airlock, if possible."
	call_proc = /obj/machinery/door/airlock/proc/lock

/decl/public_access/public_method/airlock_unlock
	name = "disengage bolts"
	desc = "Unbolts the airlock, if possible."
	call_proc = /obj/machinery/door/airlock/proc/unlock

/decl/public_access/public_method/airlock_toggle_bolts
	name = "toggle bolts"
	desc = "Toggles whether the airlock is bolted or not, if possible."
	call_proc = /obj/machinery/door/airlock/proc/toggle_lock

/decl/public_access/public_variable/airlock_door_state
	expected_type = /obj/machinery/door/airlock
	name = "airlock door state"
	desc = "Whether the door is closed (\"closed\") or not (\"open\")."
	can_write = FALSE
	has_updates = FALSE
	var_type = IC_FORMAT_STRING

/decl/public_access/public_variable/airlock_door_state/access_var(obj/machinery/door/airlock/door)
	return door.density ? "closed" : "open"

/decl/public_access/public_variable/airlock_bolt_state
	expected_type = /obj/machinery/door/airlock
	name = "airlock bolt state"
	desc = "Whether the door is bolted (\"locked\") or not (\"unlocked\")."
	can_write = FALSE
	has_updates = FALSE
	var_type = IC_FORMAT_STRING

/decl/public_access/public_variable/airlock_bolt_state/access_var(obj/machinery/door/airlock/door)
	return door.locked ? "locked" : "unlocked"

/obj/machinery/airlock_sensor
	name = "airlock sensor"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	layer = ABOVE_WINDOW_LAYER

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
			pressure_var.write_var(src, new_pressure)

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