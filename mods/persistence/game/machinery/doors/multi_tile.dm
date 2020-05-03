/obj/machinery/door/airlock/multi_tile/should_save(var/datum/caller)
	if(caller == loc)
		return ..()
	return 0