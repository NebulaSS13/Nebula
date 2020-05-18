/datum/shuttle/autodock/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	if(!SSpersistence.in_loaded_world)
		return ..()