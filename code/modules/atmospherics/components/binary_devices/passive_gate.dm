#define REGULATE_NONE	0
#define REGULATE_INPUT	1	//shuts off when input side is below the target pressure
#define REGULATE_OUTPUT	2	//shuts off when output side is above the target pressure

/obj/machinery/atmospherics/binary/passive_gate
	icon = 'icons/atmos/passive_gate.dmi'
	icon_state = "map_off"
	level = LEVEL_BELOW_PLATING

	name = "pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. Does not require power."

	use_power = POWER_USE_OFF
	interact_offline = TRUE
	var/unlocked = 0	//If 0, then the valve is locked closed, otherwise it is open(-able, it's a one-way valve so it closes if gas would flow backwards).
	var/target_pressure = ONE_ATMOSPHERE
	var/max_pressure_setting = MAX_PUMP_PRESSURE
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	var/regulate_mode = REGULATE_OUTPUT

	var/flowing = 0	//for icons - becomes zero if the valve closes itself due to regulation mode

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "passivegate"

	identifier = "AGP"
	uncreated_component_parts = null // Does not need power components; does not come with radio stuff, have to install it manually.
	public_variables = list(
		/decl/public_access/public_variable/input_toggle,
		/decl/public_access/public_variable/identifier,
		/decl/public_access/public_variable/passive_gate_unlocked,
		/decl/public_access/public_variable/passive_gate_flow_rate,
		/decl/public_access/public_variable/passive_gate_mode,
		/decl/public_access/public_variable/passive_gate_target_pressure
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_unlocked,
		/decl/public_access/public_method/toggle_input_toggle
	) // Does come with suggested stock configurations, though.
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/passive_gate = 1,
		/decl/stock_part_preset/radio/event_transmitter/passive_gate = 1
	)

	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	base_type = /obj/machinery/atmospherics/binary/passive_gate

/obj/machinery/atmospherics/binary/passive_gate/on
	unlocked = 1
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/passive_gate/Initialize()
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5

/obj/machinery/atmospherics/binary/passive_gate/on_update_icon()
	icon_state = (unlocked && flowing)? "on" : "off"

	build_device_underlays(FALSE)

/obj/machinery/atmospherics/binary/passive_gate/hide(var/i)
	update_icon()

/obj/machinery/atmospherics/binary/passive_gate/Process()
	..()

	last_flow_rate = 0

	if(!unlocked)
		return 0

	var/output_starting_pressure = air2.return_pressure()
	var/input_starting_pressure = air1.return_pressure()

	var/pressure_delta
	switch (regulate_mode)
		if (REGULATE_INPUT)
			pressure_delta = input_starting_pressure - target_pressure
		if (REGULATE_OUTPUT)
			pressure_delta = target_pressure - output_starting_pressure

	//-1 if pump_gas() did not move any gas, >= 0 otherwise
	var/returnval = -1
	if((regulate_mode == REGULATE_NONE || pressure_delta > 0.01) && (air1.temperature > 0 || air2.temperature > 0))	//since it's basically a valve, it makes sense to check both temperatures
		flowing = 1

		//flow rate limit
		var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles

		//Figure out how much gas to transfer to meet the target pressure.
		switch (regulate_mode)
			if (REGULATE_INPUT)
				transfer_moles = min(transfer_moles, air1.total_moles*(pressure_delta/input_starting_pressure))
			if (REGULATE_OUTPUT)
				var/datum/pipe_network/output = network_in_dir(dir)
				transfer_moles = min(transfer_moles, calculate_transfer_moles(air1, air2, pressure_delta, output?.volume))

		//pump_gas() will return a negative number if no flow occurred
		returnval = pump_gas_passive(src, air1, air2, transfer_moles)

	if (returnval >= 0)
		update_networks()

	if (last_flow_rate)
		flowing = 1

	update_icon()

/obj/machinery/atmospherics/binary/passive_gate/interface_interact(mob/user)
	ui_interact(user)
	return

/obj/machinery/atmospherics/binary/passive_gate/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]

	data = list(
		"on" = unlocked,
		"pressure_set" = round(target_pressure*100),	//Nano UI can't handle rounded non-integers, apparently.
		"max_pressure" = max_pressure_setting,
		"input_pressure" = round(air1.return_pressure()*100),
		"output_pressure" = round(air2.return_pressure()*100),
		"regulate_mode" = regulate_mode,
		"set_flow_rate" = round(set_flow_rate*10),
		"last_flow_rate" = round(last_flow_rate*10),
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "pressure_regulator.tmpl", name, 470, 370)
		ui.set_initial_data(data)	// when the ui is first opened this is the data it will use
		ui.open()					// open the new ui window
		ui.set_auto_update(1)		// auto update every Master Controller tick


/obj/machinery/atmospherics/binary/passive_gate/Topic(href,href_list)
	if(..()) return 1

	if(href_list["toggle_valve"])
		unlocked = !unlocked

	if(href_list["regulate_mode"])
		switch(href_list["regulate_mode"])
			if ("off") regulate_mode = REGULATE_NONE
			if ("input") regulate_mode = REGULATE_INPUT
			if ("output") regulate_mode = REGULATE_OUTPUT

	switch(href_list["set_press"])
		if ("min")
			target_pressure = 0
		if ("max")
			target_pressure = max_pressure_setting
		if ("set")
			var/new_pressure = input(usr,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure Control",src.target_pressure) as num
			src.target_pressure = clamp(new_pressure, 0, max_pressure_setting)

	switch(href_list["set_flow_rate"])
		if ("min")
			set_flow_rate = 0
		if ("max")
			set_flow_rate = air1.volume
		if ("set")
			var/new_flow_rate = input(usr,"Enter new flow rate limit (0-[air1.volume]kPa)","Flow Rate Control",src.set_flow_rate) as num
			src.set_flow_rate = clamp(new_flow_rate, 0, air1.volume)

	usr.set_machine(src)	//Is this even needed with NanoUI?
	src.update_icon()
	src.add_fingerprint(usr)
	return

/obj/machinery/atmospherics/binary/passive_gate/proc/toggle_unlocked()
	unlocked = !unlocked

/obj/machinery/atmospherics/binary/passive_gate/cannot_transition_to(state_path, mob/user)
	if(state_path == /decl/machine_construction/default/deconstructed)
		if (unlocked)
			return SPAN_WARNING("You cannot take this [src] apart, close the valve first.")
	return ..()

/decl/public_access/public_variable/passive_gate_unlocked
	expected_type = /obj/machinery/atmospherics/binary/passive_gate
	name = "valve open"
	desc = "Whether or not the valve is open, allowing gas to pass in one direction."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_BOOLEAN

/decl/public_access/public_variable/passive_gate_unlocked/access_var(obj/machinery/atmospherics/binary/passive_gate/machine)
	return machine.unlocked

/decl/public_access/public_variable/passive_gate_unlocked/write_var(obj/machinery/atmospherics/binary/passive_gate/machine, new_value)
	new_value = !!new_value
	. = ..()
	if(.)
		machine.unlocked = new_value

/decl/public_access/public_variable/passive_gate_flow_rate
	expected_type = /obj/machinery/atmospherics/binary/passive_gate
	name = "flow rate cap"
	desc = "A cap on the volume flow rate of the gate."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_NUMBER

/decl/public_access/public_variable/passive_gate_flow_rate/access_var(obj/machinery/atmospherics/binary/passive_gate/machine)
	return machine.set_flow_rate

/decl/public_access/public_variable/passive_gate_flow_rate/write_var(obj/machinery/atmospherics/binary/passive_gate/machine, new_value)
	new_value = clamp(new_value, 0, machine.air1?.volume)
	. = ..()
	if(.)
		machine.set_flow_rate = new_value

/decl/public_access/public_variable/passive_gate_mode
	expected_type = /obj/machinery/atmospherics/binary/passive_gate
	name = "regulation mode"
	desc = "A number describing the form of regulation the gate is attempting. The possible values are 0 (no air passed), 1 (regulates input pressure), or 2 (regulates output pressure)."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_NUMBER

/decl/public_access/public_variable/passive_gate_mode/access_var(obj/machinery/atmospherics/binary/passive_gate/machine)
	return machine.regulate_mode

/decl/public_access/public_variable/passive_gate_mode/write_var(obj/machinery/atmospherics/binary/passive_gate/machine, new_value)
	new_value = sanitize_integer(new_value, 0, 2, machine.regulate_mode)
	. = ..()
	if(.)
		machine.regulate_mode = new_value

/decl/public_access/public_variable/passive_gate_target_pressure
	expected_type = /obj/machinery/atmospherics/binary/passive_gate
	name = "target pressure"
	desc = "The input or output pressure the gate aims to stay below."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_NUMBER

/decl/public_access/public_variable/passive_gate_target_pressure/access_var(obj/machinery/atmospherics/binary/passive_gate/machine)
	return machine.target_pressure

/decl/public_access/public_variable/passive_gate_target_pressure/write_var(obj/machinery/atmospherics/binary/passive_gate/machine, new_value)
	new_value = clamp(new_value, 0, machine.max_pressure_setting)
	. = ..()
	if(.)
		machine.target_pressure = new_value

/decl/public_access/public_method/toggle_unlocked
	name = "toggle valve"
	desc = "Open or close the valve."
	call_proc = TYPE_PROC_REF(/obj/machinery/atmospherics/binary/passive_gate, toggle_unlocked)

/decl/stock_part_preset/radio/event_transmitter/passive_gate
	frequency = PUMP_FREQ
	event = /decl/public_access/public_variable/input_toggle
	transmit_on_event = list(
		"device" = /decl/public_access/public_variable/identifier,
		"power" = /decl/public_access/public_variable/passive_gate_unlocked,
		"target_output" = /decl/public_access/public_variable/passive_gate_target_pressure,
		"regulate_mode" = /decl/public_access/public_variable/passive_gate_mode,
		"set_flow_rate" = /decl/public_access/public_variable/passive_gate_flow_rate
	)

/decl/stock_part_preset/radio/receiver/passive_gate
	frequency = PUMP_FREQ
	receive_and_call = list(
		"power_toggle" = /decl/public_access/public_method/toggle_unlocked,
		"status" = /decl/public_access/public_method/toggle_input_toggle
	)
	receive_and_write = list(
		"set_power" = /decl/public_access/public_variable/passive_gate_unlocked,
		"set_regulate_mode" = /decl/public_access/public_variable/passive_gate_mode,
		"set_target_pressure" = /decl/public_access/public_variable/passive_gate_target_pressure,
		"set_volume_rate" = /decl/public_access/public_variable/passive_gate_flow_rate
	)

#undef REGULATE_NONE
#undef REGULATE_INPUT
#undef REGULATE_OUTPUT
