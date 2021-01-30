/obj/effect/landmark/map_data
	name = "Map Data"
	desc = "An unknown location."
	invisibility = 101

	var/height = 1     ///< The number of Z-Levels in the map.
	var/turf/edge_type ///< What the map edge should be formed with. (null = world.turf)

	VAR_PROTECTED/UT_turf_exceptions_by_door_type // An associate list of door types/list of allowed turfs
