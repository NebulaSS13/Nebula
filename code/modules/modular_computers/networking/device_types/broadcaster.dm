/datum/extension/network_device/broadcaster
	expected_type = /obj/machinery
	receiver_type = RECEIVER_BROADCASTER
	var/allow_wifi = TRUE
	var/tmp/cached_rating = null

/datum/extension/network_device/broadcaster/proc/get_broadcast_strength()
	var/obj/machinery/M = holder
	if(!istype(M) || !M.operable())
		return 0

	if(isnull(cached_rating))
		cached_rating = NETWORK_BASE_BROADCAST_STRENGTH * clamp(M.total_component_rating_of_type(/obj/item/stock_parts/micro_laser), 1, 3)
	return cached_rating