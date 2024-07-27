//Basically a one way passive valve. If the pressure inside is greater than the environment then gas will flow passively,
//but it does not permit gas to flow back from the environment into the injector. Can be turned off to prevent any gas flow.
//When it receives the "inject" signal, it will try to pump it's entire contents into the environment regardless of pressure, using power.

/obj/machinery/atmospherics/unary/outlet_injector
	icon = 'icons/atmos/injector.dmi'
	icon_state = "off"

	name = "injector outlet"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 45000	//45000 W ~ 60 HP

	var/injecting = 0

	var/volume_rate = 50	//flow rate limit

	level = LEVEL_BELOW_PLATING

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	build_icon = 'icons/atmos/injector.dmi'
	build_icon_state = "map_injector"

	identifier = "AO"
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
	)
	public_variables = list(
		/decl/public_access/public_variable/input_toggle,
		/decl/public_access/public_variable/identifier,
		/decl/public_access/public_variable/use_power,
		/decl/public_access/public_variable/volume_rate
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_power,
		/decl/public_access/public_method/inject,
		/decl/public_access/public_method/toggle_input_toggle
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/outlet_injector = 1,
		/decl/stock_part_preset/radio/event_transmitter/outlet_injector = 1
	)

	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	base_type = /obj/machinery/atmospherics/unary/outlet_injector/buildable

/obj/machinery/atmospherics/unary/outlet_injector/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/unary/outlet_injector/Initialize()
	. = ..()
	//Give it a small reservoir for injecting. Also allows it to have a higher flow rate limit than vent pumps, to differentiate injectors a bit more.
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500

/obj/machinery/atmospherics/unary/outlet_injector/on_update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

	build_device_underlays()

/obj/machinery/atmospherics/unary/outlet_injector/proc/get_console_data()
	. = list()
	. += "<table>"
	. += "<tr><td><b>Name:</b></td><td>[name]</td>"
	. += "<tr><td><b>Power:</b></td><td>[use_power?("<font color = 'green'>Injecting</font>"):("<font color = 'red'>Offline</font>")]</td><td><a href='byond://?src=\ref[src];toggle_power=\ref[src]'>Toggle</a></td></tr>"
	. = JOINTEXT(.)

/obj/machinery/atmospherics/unary/outlet_injector/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..()))
		return
	if(href_list["toggle_power"])
		update_use_power(!use_power)
		to_chat(user, "<span class='notice'>The multitool emits a short beep confirming the change.</span>")
		return TOPIC_REFRESH

/obj/machinery/atmospherics/unary/outlet_injector/Process()
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/datum/gas_mixture/environment = loc.return_air()

	if(environment && air_contents.temperature > 0)
		var/transfer_moles = (volume_rate/air_contents.volume)*air_contents.total_moles //apply flow rate limit
		power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
		if(transfer_moles > 0)
			update_networks()

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	return 1

/obj/machinery/atmospherics/unary/outlet_injector/proc/inject()
	set waitfor = 0

	if(injecting || (stat & NOPOWER))
		return 0

	var/datum/gas_mixture/environment = loc.return_air()
	if (!environment)
		return 0

	injecting = 1

	if(air_contents.temperature > 0)
		var/power_used = pump_gas(src, air_contents, environment, air_contents.total_moles, power_rating)
		use_power_oneoff(power_used)
		update_networks()

	flick("inject", src)

/obj/machinery/atmospherics/unary/outlet_injector/hide(var/i)
	update_icon()

/obj/machinery/atmospherics/unary/outlet_injector/attackby(var/obj/item/O, var/mob/user)
	if(IS_MULTITOOL(O))
		var/datum/browser/written_digital/popup = new (user, "Vent Configuration Utility", "[src] Configuration Panel", 600, 200)
		popup.set_content(jointext(get_console_data(),"<br>"))
		popup.open()
		return
	return ..()

/decl/public_access/public_variable/volume_rate
	expected_type = /obj/machinery/atmospherics/unary/outlet_injector
	name = "volume_rate"
	desc = "The rate at which the machine pumps (a number)."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_NUMBER

/decl/public_access/public_variable/volume_rate/access_var(obj/machinery/atmospherics/unary/outlet_injector/machine)
	return machine.volume_rate

/decl/public_access/public_variable/volume_rate/write_var(obj/machinery/atmospherics/unary/outlet_injector/machine, new_value)
	new_value = clamp(new_value, 0, machine.air_contents.volume)
	. = ..()
	if(.)
		machine.volume_rate = new_value

/decl/public_access/public_method/inject
	name = "inject"
	desc = "Injects gas into its environment."
	call_proc = TYPE_PROC_REF(/obj/machinery/atmospherics/unary/outlet_injector, inject)

/decl/stock_part_preset/radio/event_transmitter/outlet_injector
	frequency = ATMOS_TANK_FREQ
	event = /decl/public_access/public_variable/input_toggle
	transmit_on_event = list(
		"device" = /decl/public_access/public_variable/identifier,
		"power" = /decl/public_access/public_variable/use_power,
		"volume_rate" = /decl/public_access/public_variable/volume_rate
	)

/decl/stock_part_preset/radio/receiver/outlet_injector
	frequency = ATMOS_TANK_FREQ
	receive_and_call = list(
		"power_toggle" = /decl/public_access/public_method/toggle_power,
		"valve_toggle" = /decl/public_access/public_method/toggle_power,
		"inject" = /decl/public_access/public_method/inject,
		"status" = /decl/public_access/public_method/toggle_input_toggle
	) // power_toggle and valve_toggle are used by different senders
	receive_and_write = list(
		"set_power" = /decl/public_access/public_variable/use_power,
		"set_volume_rate" = /decl/public_access/public_variable/volume_rate
	)

/decl/stock_part_preset/radio/event_transmitter/outlet_injector/engine
	frequency = ATMOS_ENGINE_FREQ

/decl/stock_part_preset/radio/receiver/outlet_injector/engine
	frequency = ATMOS_ENGINE_FREQ

/obj/machinery/atmospherics/unary/outlet_injector/engine
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/outlet_injector/engine = 1,
		/decl/stock_part_preset/radio/event_transmitter/outlet_injector/engine = 1
	)