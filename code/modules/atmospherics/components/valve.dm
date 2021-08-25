/obj/machinery/atmospherics/valve
	icon = 'icons/atmos/valve.dmi'
	icon_state = "map_valve0"

	name = "manual valve"
	desc = "A pipe valve."

	level = 1
	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/open = 0
	var/openDuringInit = 0

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	connect_dir_type = SOUTH | NORTH
	rotate_class = PIPE_ROTATE_TWODIR
	pipe_class = PIPE_CLASS_BINARY
	build_icon_state = "mvalve"

	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc
	)
	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	base_type = /obj/machinery/atmospherics/valve/buildable

/obj/machinery/atmospherics/valve/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/valve/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/valve/on_update_icon(animation)
	if(animation)
		flick("valve[src.open][!src.open]",src)
	else
		icon_state = "valve[open]"

	build_device_underlays(FALSE)

/obj/machinery/atmospherics/valve/hide(var/i)
	update_icon()

/obj/machinery/atmospherics/valve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(open) // connect everything
		for(var/obj/machinery/atmospherics/node AS_ANYTHING in nodes_to_networks)
			if(nodes_to_networks[node] != new_network)
				QDEL_NULL(nodes_to_networks[node])
				nodes_to_networks[node] = new_network
				if(node != reference)
					node.network_expand(new_network, src)
		new_network.normal_members |= src
	else
		..() // connect along each dir separately; this is base behavior

/obj/machinery/atmospherics/valve/proc/open()
	if(open) 
		return 0

	open = TRUE

	if(LAZYLEN(nodes_to_networks))
		var/datum/pipe_network/winner_network = nodes_to_networks[nodes_to_networks[1]]
		for(var/node in nodes_to_networks)
			if(nodes_to_networks[node] != winner_network)
				winner_network.merge(nodes_to_networks[node]) // this will reset nodes_to_networks[node] to winner_network
		winner_network.update = 1

	update_icon()
	return 1

/obj/machinery/atmospherics/valve/proc/close()
	if(!open)
		return 0

	open = FALSE

	for(var/node in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])

	build_network()

	update_icon()
	return 1

/obj/machinery/atmospherics/valve/proc/toggle()
	return open ? close() : open()

/obj/machinery/atmospherics/valve/physical_attack_hand(mob/user)
	user_toggle()
	return TRUE

/obj/machinery/atmospherics/valve/proc/user_toggle()
	update_icon(1)
	sleep(10)
	toggle()

/obj/machinery/atmospherics/valve/Process()
	..()
	return PROCESS_KILL

/obj/machinery/atmospherics/valve/atmos_init()
	..()
	if(openDuringInit)
		close()
		open()
		openDuringInit = 0

/obj/machinery/atmospherics/valve/return_network_air(datum/pipe_network/reference)
	return null

/obj/machinery/atmospherics/valve/deconstruction_pressure_check()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		return FALSE
	return TRUE

/obj/machinery/atmospherics/valve/examine(mob/user)
	. = ..()
	to_chat(user, "It is [open ? "open" : "closed"].")

/decl/public_access/public_variable/valve_open
	expected_type = /obj/machinery/atmospherics/valve
	name = "valve open"
	desc = "Whether or not the valve is open."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/valve_open/access_var(obj/machinery/atmospherics/valve/valve)
	return valve.open

/decl/public_access/public_method/open_valve
	name = "open valve"
	desc = "Sets the valve to open."
	call_proc = /obj/machinery/atmospherics/valve/proc/open

/decl/public_access/public_method/close_valve
	name = "open valve"
	desc = "Sets the valve to open."
	call_proc = /obj/machinery/atmospherics/valve/proc/close

/decl/public_access/public_method/toggle_valve
	name = "toggle valve"
	desc = "Toggles whether the valve is open or closed."
	call_proc = /obj/machinery/atmospherics/valve/proc/toggle

/obj/machinery/atmospherics/valve/digital		// can be controlled by AI
	name = "digital valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_valve.dmi'
	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/power/apc/buildable
	)
	public_variables = list(/decl/public_access/public_variable/valve_open)
	public_methods = list(
		/decl/public_access/public_method/open_valve,
		/decl/public_access/public_method/close_valve,
		/decl/public_access/public_method/toggle_valve
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/valve = 1)

	build_icon_state = "dvalve"
	base_type = /obj/machinery/atmospherics/valve/digital/buildable

/obj/machinery/atmospherics/valve/digital/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/valve/digital/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	user_toggle()
	return TRUE

/obj/machinery/atmospherics/valve/digital/physical_attack_hand(mob/user)
	return FALSE

/obj/machinery/atmospherics/valve/digital/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/valve/digital/on_update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "valve[open]nopower"

/decl/stock_part_preset/radio/receiver/valve
	frequency = FUEL_FREQ
	receive_and_call = list(
		"valve_open" = /decl/public_access/public_method/open_valve,
		"valve_close" = /decl/public_access/public_method/close_valve,
		"valve_toggle" = /decl/public_access/public_method/toggle_valve
	)