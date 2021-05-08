/datum/shuttle/autodock/overmap/created
	defer_initialisation = TRUE

/datum/shuttle/autodock/overmap/created/New(map_hash, obj/effect/shuttle_landmark/initial_location, list/initial_areas, tag)
	name = tag
	. = ..()
	// Because these are created at runtime, we manually add the shuttle areas to the subsystem.
	shuttle_area = initial_areas
	SSshuttle.shuttle_areas += shuttle_area