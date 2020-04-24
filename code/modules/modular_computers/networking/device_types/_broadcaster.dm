/datum/extension/network_device/broadcaster
	connection_type = NETWORK_CONNECTION_WIRED

/datum/extension/network_device/broadcaster/proc/get_broadcast_strength()
	var/obj/item/stock_parts/computer/network_card/network_card = get_network_card()
	if(!network_card)
		return 0
	return NETWORK_BASE_BROADCAST_STRENGTH * (network_card.long_range ? 2 : 1)

/datum/extension/network_device/broadcaster/proc/get_network_card()
	var/obj/machinery/M = holder
	if(istype(M))
		return M.get_component_of_type(/obj/item/stock_parts/computer/network_card)