/datum/shuttle/autodock/overmap/created
	defer_initialisation = TRUE

/datum/shuttle/autodock/overmap/created/New(map_hash, obj/effect/shuttle_landmark/initial_location, list/initial_areas, tag)
	if(!tag)
		CRASH("Shuttle was created without a shuttle tag!")
	name = tag
	if(!length(initial_areas))
		CRASH("Shuttle was created without initial areas!")
	shuttle_area = initial_areas
	. = ..()