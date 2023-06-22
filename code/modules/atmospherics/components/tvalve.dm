/obj/machinery/atmospherics/tvalve
	icon = 'icons/atmos/tvalve.dmi'
	icon_state = "map_tvalve0"
	var/base_icon_state = "tvalve"

	name = "manual switching valve"
	desc = "A pipe valve."

	level = 1
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST

	var/state = 0 // 0 = go straight, 1 = go to side

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	connect_dir_type = SOUTH | WEST | NORTH
	pipe_class = PIPE_CLASS_TRINARY

	build_icon = 'icons/atmos/tvalve.dmi'
	build_icon_state = "map_tvalve0"

	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable
	)
	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	base_type = /obj/machinery/atmospherics/tvalve/buildable
	interact_offline = TRUE

/obj/machinery/atmospherics/tvalve/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/tvalve/on_update_icon(animation)
	if(animation)
		flick("[base_icon_state][src.state][!src.state]",src)
	else
		icon_state = "[base_icon_state][state]"

	build_device_underlays(FALSE)

/obj/machinery/atmospherics/tvalve/hide(var/i)
	update_icon()

/obj/machinery/atmospherics/tvalve/proc/paired_dirs() // these two dirs are connected
	if(state) // "go to side"
		return list(turn(dir, 180), turn(dir, -90))
	else      // "go straight"
		return list(turn(dir, 180), dir)

// feed in node; recover all the other nodes that this one should be connected to, depending on state
/obj/machinery/atmospherics/tvalve/proc/get_nodes_connected_to(obj/machinery/atmospherics/node)
	var/node_dir = get_dir(src, node)
	. = nodes_in_dir(node_dir) // other nodes in the same dir
	var/other_dir // but maybe we need to also be connecting to all nodes in one other dir

	var/paired_dirs = paired_dirs()
	if(node_dir in paired_dirs) // fish out the other one
		paired_dirs -= node_dir
		other_dir = paired_dirs[1]

	if(other_dir)
		. |= nodes_in_dir(other_dir)

/obj/machinery/atmospherics/tvalve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	for(var/obj/machinery/atmospherics/node as anything in get_nodes_connected_to(reference))
		if(nodes_to_networks[node] != new_network)
			QDEL_NULL(nodes_to_networks[node])
			nodes_to_networks[node] = new_network
			if(node != reference)
				node.network_expand(new_network, src)
	new_network.normal_members |= src

/obj/machinery/atmospherics/tvalve/proc/go_to_side()
	if(state)
		return 0

	state = 1
	// we are just going to rebuild networks, as we can't split them anyway.

	for(var/node in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
	build_network()

	update_icon()
	return 1

/obj/machinery/atmospherics/tvalve/proc/go_straight()
	if(!state)
		return 0

	state = 0

	for(var/node in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
	build_network()

	update_icon()
	return 1

/obj/machinery/atmospherics/tvalve/proc/toggle()
	return state ? go_straight() : go_to_side()

/obj/machinery/atmospherics/tvalve/physical_attack_hand(mob/user)
	user_toggle()
	return TRUE

/obj/machinery/atmospherics/tvalve/proc/user_toggle()
	update_icon(1)
	sleep(10)
	toggle()

/obj/machinery/atmospherics/tvalve/Process()
	..()
	return PROCESS_KILL

/obj/machinery/atmospherics/tvalve/return_network_air(datum/pipe_network/reference)
	return null

/obj/machinery/atmospherics/tvalve/deconstruction_pressure_check()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > (2 ATM))
		return FALSE
	return TRUE

/decl/public_access/public_variable/tvalve_state
	expected_type = /obj/machinery/atmospherics/tvalve
	name = "valve state"
	desc = "If true, the output is diverted to the side; if false, the output goes straight."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/tvalve_state/access_var(obj/machinery/atmospherics/tvalve/tvalve)
	return tvalve.state

/decl/public_access/public_method/tvalve_go_straight
	name = "valve go straight"
	desc = "Sets the valve to send output straight."
	call_proc = /obj/machinery/atmospherics/tvalve/proc/go_straight

/decl/public_access/public_method/tvalve_go_side
	name = "valve go side"
	desc = "Redirects output to the side."
	call_proc = /obj/machinery/atmospherics/tvalve/proc/go_to_side

/decl/public_access/public_method/tvalve_toggle
	name = "valve toggle"
	desc = "Toggles the output direction."
	call_proc = /obj/machinery/atmospherics/tvalve/proc/toggle

/decl/stock_part_preset/radio/receiver/tvalve
	frequency = FUEL_FREQ
	receive_and_call = list(
		"valve_open" = /decl/public_access/public_method/tvalve_go_side,
		"valve_close" = /decl/public_access/public_method/tvalve_go_straight,
		"valve_toggle" = /decl/public_access/public_method/tvalve_toggle
	)

//Mirrored editions
/obj/machinery/atmospherics/tvalve/mirrored
	icon_state = "map_tvalvem0"
	base_icon_state = "tvalvem"

	connect_dir_type = SOUTH | EAST | NORTH
	build_icon_state = "map_tvalvem0"
	base_type = /obj/machinery/atmospherics/tvalve/mirrored/buildable

/obj/machinery/atmospherics/tvalve/mirrored/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/tvalve/mirrored/paired_dirs()
	if(state) // "go to side" but other side
		return list(turn(dir, 180), turn(dir, 90))
	else
		return list(turn(dir, 180), dir)

/obj/machinery/atmospherics/tvalve/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_tvalve.dmi'
	icon_state = "map_tvalve0"

	build_icon = 'icons/atmos/digital_tvalve.dmi'
	build_icon_state = "map_tvalve0"

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/power/apc/buildable
	)
	public_variables = list(/decl/public_access/public_variable/tvalve_state)
	public_methods = list(
		/decl/public_access/public_method/tvalve_go_side,
		/decl/public_access/public_method/tvalve_go_straight,
		/decl/public_access/public_method/tvalve_toggle
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/tvalve = 1)
	base_type = /obj/machinery/atmospherics/tvalve/digital/buildable

/obj/machinery/atmospherics/tvalve/digital/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/tvalve/digital/on_update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "tvalvenopower"

/obj/machinery/atmospherics/tvalve/digital/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	user_toggle()
	return TRUE

/obj/machinery/atmospherics/tvalve/digital/physical_attack_hand(mob/user)
	return FALSE

/obj/machinery/atmospherics/tvalve/mirrored/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_tvalve.dmi'
	icon_state = "map_tvalvem0"

	build_icon = 'icons/atmos/digital_tvalve.dmi'
	build_icon_state = "map_tvalvem0"

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/power/apc/buildable
	)
	public_variables = list(/decl/public_access/public_variable/tvalve_state)
	public_methods = list(
		/decl/public_access/public_method/tvalve_go_side,
		/decl/public_access/public_method/tvalve_go_straight,
		/decl/public_access/public_method/tvalve_toggle
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/tvalve = 1)
	base_type = /obj/machinery/atmospherics/tvalve/mirrored/digital/buildable

/obj/machinery/atmospherics/tvalve/mirrored/digital/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/tvalve/mirrored/digital/on_update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "tvalvemnopower"

/obj/machinery/atmospherics/tvalve/mirrored/digital/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	user_toggle()
	return TRUE

/obj/machinery/atmospherics/tvalve/mirrored/digital/physical_attack_hand(mob/user)
	return FALSE

//Bypass editions
/obj/machinery/atmospherics/tvalve/digital/bypass
	icon_state = "map_tvalve1"
	state = 1

/obj/machinery/atmospherics/tvalve/bypass
	icon_state = "map_tvalve1"
	state = 1

/obj/machinery/atmospherics/tvalve/mirrored/bypass
	icon_state = "map_tvalvem1"
	state = 1

/obj/machinery/atmospherics/tvalve/mirrored/digital/bypass
	icon_state = "map_tvalvem1"
	state = 1