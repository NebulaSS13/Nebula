//--------------------------------------------
// Base omni device
//--------------------------------------------
/obj/machinery/atmospherics/omni
	name = "omni device"
	icon = 'icons/atmos/omni_devices.dmi'
	icon_state = "base"
	initialize_directions = 0
	level = 1
	var/core_icon

	var/configuring = 0

	var/tag_north = ATM_NONE
	var/tag_south = ATM_NONE
	var/tag_east = ATM_NONE
	var/tag_west = ATM_NONE
	var/tag_filter_gas_north //These are GAS DECLS IDs. /decl/material/gas.
	var/tag_filter_gas_south
	var/tag_filter_gas_east
	var/tag_filter_gas_west

	var/overlays_on[5]
	var/overlays_off[5]
	var/overlays_error[2]
	var/underlays_current[4]

	var/list/ports = new()

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	pipe_class = PIPE_CLASS_OMNI
	connect_dir_type = SOUTH | NORTH | EAST | WEST

	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/keyboard,
		/obj/item/stock_parts/console_screen
	)
	stat_immune = 0
	frame_type = /obj/item/pipe

/obj/machinery/atmospherics/omni/Initialize()
	icon_state = "base"

	ports = new()
	for(var/d in global.cardinal)
		var/datum/omni_port/new_port = new(src, d)
		switch(d)
			if(NORTH)
				new_port.mode = tag_north
				if(new_port.mode == ATM_FILTER && tag_filter_gas_north)
					if(!istext(tag_filter_gas_north))
						CRASH("The tag_filter_gas_north var of [src] ([x],[y],[z]) was not set to a material uid string! Got : '[tag_filter_gas_north]'.")
					new_port.filtering = decls_repository.get_decl_by_id(tag_filter_gas_north)
				if(tag_north >= 3 && tag_north < 8)
					new_port.filtering = handle_legacy_gas_filtering(tag_north)
					new_port.mode = ATM_FILTER
			if(SOUTH)
				new_port.mode = tag_south
				if(new_port.mode == ATM_FILTER && tag_filter_gas_south)
					if(!istext(tag_filter_gas_south))
						CRASH("The tag_filter_gas_south var of [src] ([x],[y],[z]) was not set to a material uid string! Got : '[tag_filter_gas_south]'.")
					new_port.filtering = decls_repository.get_decl_by_id(tag_filter_gas_south)
				if(tag_south >= 3 && tag_south < 8)
					new_port.filtering = handle_legacy_gas_filtering(tag_south)
					new_port.mode = ATM_FILTER
			if(EAST)
				new_port.mode = tag_east
				if(new_port.mode == ATM_FILTER && tag_filter_gas_east)
					if(!istext(tag_filter_gas_east))
						CRASH("The tag_filter_gas_east var of [src] ([x],[y],[z]) was not set to a material uid string! Got : '[tag_filter_gas_east]'.")
					new_port.filtering = decls_repository.get_decl_by_id(tag_filter_gas_east)
				if(tag_east >= 3 && tag_east < 8)
					new_port.filtering = handle_legacy_gas_filtering(tag_east)
					new_port.mode = ATM_FILTER
			if(WEST)
				new_port.mode = tag_west
				if(new_port.mode == ATM_FILTER && tag_filter_gas_west)
					if(!istext(tag_filter_gas_west))
						CRASH("The tag_filter_gas_west var of [src] ([x],[y],[z]) was not set to a material uid string! Got : '[tag_filter_gas_west]'.")
					new_port.filtering = decls_repository.get_decl_by_id(tag_filter_gas_west)
				if(tag_west >= 3 && tag_west < 8)
					new_port.filtering = handle_legacy_gas_filtering(tag_west)
					new_port.mode = ATM_FILTER
		ports += new_port

	. = ..()

	build_icons()

/obj/machinery/atmospherics/omni/proc/handle_legacy_gas_filtering(var/input)
	switch(input)
		if(3)
			. = /decl/material/gas/oxygen
		if(4)
			. = /decl/material/gas/nitrogen
		if(5)
			. = /decl/material/gas/carbon_dioxide
		if(6)
			. = /decl/material/gas/nitrous_oxide
		if(7)
			. = /decl/material/gas/hydrogen

/obj/machinery/atmospherics/omni/get_initialize_directions()
	. = 0
	for(var/datum/omni_port/port in ports)
		if(port.mode > 0)
			. |= port.direction

/obj/machinery/atmospherics/omni/on_update_icon()
	if(stat & NOPOWER)
		overlays = overlays_off
	else if(error_check())
		overlays = overlays_error
	else
		overlays = use_power ? (overlays_on) : (overlays_off)

	underlays = underlays_current

	return

/obj/machinery/atmospherics/omni/proc/error_check()
	return

/obj/machinery/atmospherics/omni/Process()
	last_power_draw = 0
	last_flow_rate = 0

	if(error_check())
		update_use_power(POWER_USE_OFF)

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return 0
	return 1

/obj/machinery/atmospherics/omni/deconstruction_pressure_check(state_path, mob/user)
	var/int_pressure = 0
	for(var/datum/omni_port/P in ports)
		int_pressure += P.air.return_pressure()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_pressure - env_air.return_pressure()) > (2 ATM))
		return FALSE
	return TRUE

/obj/machinery/atmospherics/omni/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/atmospherics/omni/proc/build_icons()
	//directional icons are layers 1-4, with the core icon on layer 5
	if(core_icon)
		overlays_off[5] = core_icon
		overlays_on[5] = "[core_icon]_glow"

		overlays_error[1] = core_icon
		overlays_error[2] = "error"

/obj/machinery/atmospherics/omni/proc/update_port_icons()
	for(var/datum/omni_port/P in ports)
		if(P.update)
			var/ref_layer = 0
			switch(P.direction)
				if(NORTH)
					ref_layer = 1
				if(SOUTH)
					ref_layer = 2
				if(EAST)
					ref_layer = 3
				if(WEST)
					ref_layer = 4

			if(!ref_layer)
				continue

			var/list/port_icons = select_port_icons(P)
			if(port_icons)
				if(LAZYLEN(P.nodes))
					underlays_current[ref_layer] = port_icons["pipe_icon"]
				else
					underlays_current[ref_layer] = null
				overlays_off[ref_layer] = port_icons["off_icon"]
				overlays_on[ref_layer] = port_icons["on_icon"]
			else
				underlays_current[ref_layer] = null
				overlays_off[ref_layer] = null
				overlays_on[ref_layer] = null

	update_icon()

/obj/machinery/atmospherics/omni/proc/select_port_icons(var/datum/omni_port/P)
	if(!istype(P))
		return

	if(P.mode > 0)
		var/ic_dir = dir_name(P.direction)
		var/ic_on = ic_dir
		var/ic_off = ic_dir
		switch(P.mode)
			if(ATM_INPUT)
				ic_on += "_in_glow"
				ic_off += "_in"
			if(ATM_OUTPUT)
				ic_on += "_out_glow"
				ic_off += "_out"
			if(ATM_FILTER)
				ic_on += "_filter"
				ic_off += "_out"

		var/pipe_state_key
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		var/obj/machinery/atmospherics/node = LAZYACCESS(P.nodes, 1)
		if(!T.is_plating() && istype(node, /obj/machinery/atmospherics/pipe) && node.level == 1 )
			pipe_state_key = "down"
		else
			pipe_state_key = "intact"
		var/image/pipe_state = image('icons/atmos/pipe_underlays.dmi', pipe_state_key, dir = P.direction)
		pipe_state.color = color_cache_name(node)

		return list("on_icon" = ic_on, "off_icon" = ic_off, "pipe_icon" = pipe_state)

/obj/machinery/atmospherics/omni/hide(var/i)
	for(var/datum/omni_port/P in ports)
		P.update = 1
	update_ports()

/obj/machinery/atmospherics/omni/proc/update_ports()
	sort_ports()
	update_port_icons()
	for(var/datum/omni_port/P in ports)
		P.update = 0

/obj/machinery/atmospherics/omni/proc/sort_ports()
	return


// Housekeeping and pipe network stuff below

/obj/machinery/atmospherics/omni/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	for(var/datum/omni_port/P in ports)
		if((reference in P.nodes) && (new_network != P.network))
			qdel(P.network)
			P.network = new_network
			for(var/obj/machinery/atmospherics/node as anything in P.nodes)
				if(node != reference)
					node.network_expand(new_network, src)

	new_network.normal_members |= src

/obj/machinery/atmospherics/omni/Destroy()
	QDEL_NULL_LIST(ports)
	return ..()

/obj/machinery/atmospherics/omni/atmos_init()
	atmos_initalized = TRUE
	nodes_to_networks = null
	for(var/datum/omni_port/P in ports)
		P.nodes = null
		QDEL_NULL(P.network)
		if(P.mode == 0)
			continue

		for(var/obj/machinery/atmospherics/target in get_step(src, P.direction))
			if(target.initialize_directions & get_dir(target,src))
				if (check_connect_types(target,src))
					LAZYDISTINCTADD(P.nodes, target)
					LAZYDISTINCTADD(nodes_to_networks, target) // we don't fully track networks here, but we do keep a list of nodes in order to share code

	for(var/datum/omni_port/P in ports)
		P.update = 1

	update_ports()

/obj/machinery/atmospherics/omni/build_network()
	for(var/datum/omni_port/P in ports)
		if(!P.network && LAZYLEN(P.nodes))
			P.network = new /datum/pipe_network()
			P.network.normal_members += src
			P.network.build_network(P.nodes[1], src)

/obj/machinery/atmospherics/omni/return_network(obj/machinery/atmospherics/reference)
	build_network()

	for(var/datum/omni_port/P in ports)
		if(reference in P.nodes)
			return P.network

	return null

/obj/machinery/atmospherics/omni/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	for(var/datum/omni_port/P in ports)
		if(P.network == old_network)
			P.network = new_network

	return 1

/obj/machinery/atmospherics/omni/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	for(var/datum/omni_port/P in ports)
		if(P.network == reference)
			results += P.air

	return results

/obj/machinery/atmospherics/omni/disconnect(obj/machinery/atmospherics/reference)
	for(var/datum/omni_port/P in ports)
		if(reference in P.nodes)
			QDEL_NULL(P.network)
			LAZYREMOVE(P.nodes, reference)
			P.update = 1

	LAZYREMOVE(nodes_to_networks, reference)
	update_ports()