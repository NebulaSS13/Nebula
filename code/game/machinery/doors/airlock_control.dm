
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
	call_proc = TYPE_PROC_REF(/obj/machinery/door/airlock, lock)

/decl/public_access/public_method/airlock_unlock
	name = "disengage bolts"
	desc = "Unbolts the airlock, if possible."
	call_proc = TYPE_PROC_REF(/obj/machinery/door/airlock, unlock)

/decl/public_access/public_method/airlock_toggle_bolts
	name = "toggle bolts"
	desc = "Toggles whether the airlock is bolted or not, if possible."
	call_proc = TYPE_PROC_REF(/obj/machinery/door/airlock, toggle_lock)

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

/////////////////////////////////////////////////////////////////////////////////////
// Airlock Sensor
/////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/airlock_sensor
	name = "airlock sensor"
	icon = 'icons/obj/machines/airlock_sensor.dmi'
	icon_state = "sensor"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	power_channel = ENVIRON
	public_variables = list(
		/decl/public_access/public_variable/airlock_pressure,
		/decl/public_access/public_variable/input_toggle,
		/decl/public_access/public_variable/set_airlock_cycling/airlock_sensor
	)
	public_methods = list(/decl/public_access/public_method/toggle_input_toggle)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/basic_transmitter/airlock_sensor = 1,
		/decl/stock_part_preset/radio/receiver/airlock_sensor = 1
	)
	//#TODO: Make the sensor considered as missing parts if it doesn't have at the very least a transmitter
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/radio/transmitter/basic/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)
	base_type = /obj/machinery/airlock_sensor/buildable
	construct_state = /decl/machine_construction/wall_frame/panel_closed/simple
	frame_type = /obj/item/frame/button/airlock_controller_config/airlock_sensor
	directional_offset = @'{"NORTH":{"y":-18}, "SOUTH":{"y":24}, "EAST":{"x":-22}, "WEST":{"x":22}}'
	var/alert = FALSE
	var/master_cycling = FALSE
	var/pressure

/obj/machinery/airlock_sensor/buildable
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc = 1
	)

/obj/machinery/airlock_sensor/Initialize(mapload, d, populate_parts)
	. = ..()
	update_icon()

/obj/machinery/airlock_sensor/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance < 2)
		to_chat(user, SPAN_INFO("The pressure indicator reads '[pressure? round(pressure, 0.1) : 0] kPa'."))
	if(master_cycling)
		to_chat(user, SPAN_WARNING("It's warning that the master airlock is cycling!"))
	if(alert)
		to_chat(user, SPAN_WARNING("The low-pressure warning light is blinking!"))

/obj/machinery/airlock_sensor/on_update_icon()
	cut_overlays()
	if(inoperable() || !use_power)
		set_light(0)
		return
	//Cycling takes priority over alert
	if(master_cycling)
		add_overlay("sensor_light_cycle")
		set_light(l_range = 1, l_power = 0.2, l_color = "#ff0000")
	else if(alert)
		add_overlay("sensor_light_alert")
		set_light(l_range = 1, l_power = 0.2, l_color = "#ff0000")
	else
		add_overlay("sensor_light_standby")
		set_light(l_range = 1, l_power = 0.2, l_color = "#99ff33")


/obj/machinery/airlock_sensor/Process()
	if(!(stat & (NOPOWER | BROKEN)))
		var/datum/gas_mixture/air_sample = return_air()
		var/new_pressure = round(air_sample.return_pressure(),0.1)

		if(abs(pressure - new_pressure) > 0.001 || pressure == null)
			var/decl/public_access/public_variable/airlock_pressure/pressure_var = GET_DECL(/decl/public_access/public_variable/airlock_pressure)
			pressure_var.write_var(src, new_pressure)

			var/new_alert = (pressure < (0.8 ATM))
			if(new_alert != alert)
				alert = new_alert
				update_icon()

/**Meant to update the icon when the master airlock controller is cycling */
/obj/machinery/airlock_sensor/proc/set_master_cycling(var/state)
	master_cycling = state
	update_icon()

/obj/machinery/airlock_sensor/set_id_tag(var/new_id_tag)
	. = ..()
	for(var/obj/item/stock_parts/radio/R in get_all_components_of_type(/obj/item/stock_parts/radio))
		R.set_id_tag(id_tag)

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

/decl/public_access/public_variable/set_airlock_cycling/airlock_sensor
	expected_type = /obj/machinery/airlock_sensor
	can_write     = TRUE
	var_type      = IC_FORMAT_BOOLEAN

/decl/public_access/public_variable/set_airlock_cycling/airlock_sensor/access_var(obj/machinery/airlock_sensor/owner)
	return owner.master_cycling

/decl/public_access/public_variable/set_airlock_cycling/airlock_sensor/write_var(obj/machinery/airlock_sensor/owner, new_value)
	if(!..())
		return
	owner.master_cycling = new_value
	owner.update_icon()

/decl/stock_part_preset/radio/receiver/airlock_sensor
	frequency = EXTERNAL_AIR_FREQ
	receive_and_write = list(
		"set_airlock_cycling" = /decl/public_access/public_variable/set_airlock_cycling/airlock_sensor,
	)

/decl/stock_part_preset/radio/basic_transmitter/airlock_sensor/shuttle
	frequency = SHUTTLE_AIR_FREQ

/obj/machinery/airlock_sensor/shuttle
	stock_part_presets = list(/decl/stock_part_preset/radio/basic_transmitter/airlock_sensor/shuttle = 1)

/////////////////////////////////////////////////////////////////////////////////////
// Airlock Button
/////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/button/access
	icon = 'icons/obj/machines/button_airlock.dmi'
	icon_state = "button"
	name = "access button"
	interact_offline = TRUE
	public_variables = list(
		/decl/public_access/public_variable/button_active,
		/decl/public_access/public_variable/button_state,
		/decl/public_access/public_variable/input_toggle,
		/decl/public_access/public_variable/button_command,
		/decl/public_access/public_variable/set_airlock_cycling/access_button
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/event_transmitter/access_button = 1,
		/decl/stock_part_preset/radio/receiver/access_button = 1,
	)
	//#TODO: Make the button considered as missing parts if it doesn't have at the very least a transmitter
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)
	directional_offset = @'{"NORTH":{"y":-22}, "SOUTH":{"y":24}, "EAST":{"x":-20}, "WEST":{"x":20}}'
	frame_type = /obj/item/frame/button/airlock_controller_config/access
	base_type = /obj/machinery/button/access/buildable
	var/command = "cycle"
	var/tmp/master_cycling = FALSE ///Whether the master airlock controller is actually cycling so we can update our icon

/obj/machinery/button/access/interior
	command = "cycle_interior"

/obj/machinery/button/access/exterior
	command = "cycle_exterior"

/obj/machinery/button/access/exterior/cabled
	//Still create a tesla link, to stay coherent with how one would create that button from scratch in-game.
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/terminal/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/event_transmitter/access_button = 1,
		/decl/stock_part_preset/radio/receiver/access_button = 1,
		/decl/stock_part_preset/terminal_setup,
	)

/obj/machinery/button/access/shuttle
	stock_part_presets = list(
		/decl/stock_part_preset/radio/event_transmitter/access_button/shuttle = 1
	)

/obj/machinery/button/access/shuttle/interior
	command = "cycle_interior"

/obj/machinery/button/access/shuttle/exterior
	command = "cycle_exterior"

/obj/machinery/button/access/buildable
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
	)
/obj/machinery/button/access/interior/buildable
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
	)
/obj/machinery/button/access/exterior/buildable
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
	)

/obj/machinery/button/access/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance < 2)
		to_chat(user, SPAN_INFO("The button reads '[command]'."))
	if(master_cycling)
		to_chat(user, SPAN_WARNING("It's warning that the master airlock is cycling!"))

/obj/machinery/button/access/on_update_icon()
	cut_overlays()
	if(inoperable() || !use_power)
		set_light(0)
		return
	if(operating)
		add_overlay("button_light_pressed")
		set_light(l_range = 2, l_power = 0.4, l_color = "#f65555")
	else if(master_cycling)
		add_overlay("button_light_cycle")
		set_light(l_range = 2, l_power = 0.4, l_color = "#f65555")
	else
		add_overlay("button_light_standby")
		set_light(l_range = 2, l_power = 0.4, l_color = "#99ff33")

/obj/machinery/button/access/set_id_tag(var/new_id_tag)
	. = ..()
	for(var/obj/item/stock_parts/radio/R in get_all_components_of_type(/obj/item/stock_parts/radio))
		R.set_id_tag(id_tag)

//
// Button Part Presets
//
/decl/stock_part_preset/radio/receiver/access_button
	frequency = EXTERNAL_AIR_FREQ
	receive_and_write = list(
		"set_airlock_cycling" = /decl/public_access/public_variable/set_airlock_cycling/access_button,
	)

/decl/stock_part_preset/radio/event_transmitter/access_button
	frequency = EXTERNAL_AIR_FREQ
	event = /decl/public_access/public_variable/button_active
	transmit_on_event = list(
		"command" = /decl/public_access/public_variable/button_command
	)

/decl/stock_part_preset/radio/event_transmitter/access_button/shuttle
	frequency = SHUTTLE_AIR_FREQ

//
// Public Variables
//
/decl/public_access/public_variable/set_airlock_cycling/access_button
	expected_type = /obj/machinery/button/access
	can_write     = TRUE
	var_type      = IC_FORMAT_BOOLEAN

/decl/public_access/public_variable/set_airlock_cycling/access_button/access_var(obj/machinery/button/access/owner)
	return owner.master_cycling

/decl/public_access/public_variable/set_airlock_cycling/access_button/write_var(obj/machinery/button/access/owner, new_value)
	if(!..())
		return
	owner.master_cycling = new_value
	owner.update_icon()

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
