/datum/shuttle/New(_name, var/obj/effect/shuttle_landmark/initial_location)
	if(!SSpersistence.in_loaded_world)
		return ..()
	
/datum/shuttle/after_deserialize()
	. = ..()

	SSshuttle.shuttles[src.name] = src
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(SSsupply.shuttle)
			CRASH("A supply shuttle is already defined.")
		SSsupply.shuttle = src