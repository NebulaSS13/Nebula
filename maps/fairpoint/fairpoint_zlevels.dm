/datum/map/fairpoint
#ifndef UNIT_TEST
	station_levels = list(1, 2, 3)
	contact_levels = list(1, 2, 3)
	player_levels = list(1, 2, 3)

	// A list of turfs and their default turfs for serialization optimization.
	base_turf_by_z = list(
		"1" = /turf/exterior/barren,
		"2" = /turf/exterior/dirt,
		"3" = /turf/exterior/open,
		"4" = /turf/space,
	)
#else
	station_levels = list(5, 6, 7)
	contact_levels = list(5, 6, 7)
	player_levels = list(5, 6, 7)

	// A list of turfs and their default turfs for serialization optimization.
	base_turf_by_z = list(
		"5" = /turf/exterior/barren,
		"6" = /turf/exterior/dirt,
		"7" = /turf/exterior/open,
		"8" = /turf/space,
	)
#endif