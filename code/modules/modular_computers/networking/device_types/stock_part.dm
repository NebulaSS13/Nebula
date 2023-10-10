// Attached to a stock part for issuing commands to machinery via networks.
/datum/extension/network_device/stock_part
	has_commands = TRUE
	internet_allowed = TRUE // GOOSE devices, network locks, etc. can all connect over PLEXUS

/datum/extension/network_device/stock_part/get_wired_connection()
	var/atom/H = holder
	var/obj/machinery/M = H.loc
	if(!istype(M))
		return
	var/obj/item/stock_parts/computer/lan_port/port = M.get_component_of_type(/obj/item/stock_parts/computer/lan_port)
	if(!port || !port.terminal)
		return
	var/obj/structure/network_cable/terminal/term = port.terminal
	return term.get_graph()

/datum/extension/network_device/stock_part/get_command_target()
	return get_top_holder()

/datum/extension/network_device/stock_part/get_top_holder()
	var/atom/A = holder
	var/obj/machinery/M = A.loc
	if(istype(M))
		return M