var/global/list/announcers = list()

/proc/get_announcer(var/z)
	if(isatom(z))
		var/turf/T = get_turf(z)
		z = T?.z
	if(!z)
		return null
	if(!global.announcers["[z]"])
		var/list/connected = SSmapping.get_connected_levels(z)
		var/obj/item/radio/announcer/announcer = new(null, z)
		for(var/oz in connected)
			global.announcers["[oz]"] = announcer
		SSnetworking.try_connect(get_extension(announcer, /datum/extension/network_device)) // Force an immediate check instead of waiting.
		announcer.sync_channels_with_network()
	return global.announcers["[z]"]

/obj/item/radio/announcer
	cell = null
	canhear_range = 0
	power_usage =   0
	listening =     FALSE
	anchored =      TRUE
	simulated =     FALSE
	invisibility =  INVISIBILITY_MAXIMUM
	decrypt_all_messages = TRUE
	is_spawnable_type = FALSE

/obj/item/radio/announcer/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	PRINT_STACK_TRACE("attempt to delete a [src.type] prevented.")
	return QDEL_HINT_LETMELIVE

// NOTE TO SELF: this is not really viable, protect it against being blown up somehow
/obj/item/radio/announcer/Initialize(var/ml, var/nz)
	var/list/sector = SSmapping.get_connected_levels(nz)
	for(var/obj/machinery/network/telecomms_hub/T in global.telecomms_hubs)
		if((T.z in sector) && T.can_receive_message())
			forceMove(get_turf(T))
			break
	. = ..()
