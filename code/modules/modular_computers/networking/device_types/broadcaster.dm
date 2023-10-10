/datum/extension/network_device/broadcaster
	expected_type = /obj/machinery
	receiver_type = RECEIVER_BROADCASTER
	var/allow_wifi = TRUE

/datum/extension/network_device/broadcaster/proc/get_broadcast_strength()
	var/obj/machinery/M = holder
	if(!istype(M) || !M.operable())
		return 0
		
	var/rating = clamp(M.total_component_rating_of_type(/obj/item/stock_parts/micro_laser), 1, 3)
	return NETWORK_BASE_BROADCAST_STRENGTH * rating