/datum/map/cynosure
	disconnected_wires_test_exempt_turfs = list(
		// breaker box
		list(115,105,1, NORTH),
		list(114,106,1, EAST),
		// shuttle pad with charge line
		list(110,158,2, NORTH)
	)
	apc_test_exempt_areas = list(
		/area/turbolift                              = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/space                                  = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet                              = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/surface/outside                        = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/surface/cave                           = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/surface/wilderness                     = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shuttle/escape_pod_cynosure_a          = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shuttle/escape_pod_cynosure_b          = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/holodeck/alphadeck                     = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/surface/outpost/checkpoint             = NO_SCRUBBER|NO_VENT,
		/area/cynosure/cargo/d1/mining_outside       = NO_SCRUBBER|NO_VENT,
		/area/cynosure/maintenance/d1                = NO_SCRUBBER|NO_VENT,
		/area/cynosure/maintenance/substation/d1     = NO_SCRUBBER|NO_VENT,
		/area/cynosure/science/d1/toxins_testing     = NO_SCRUBBER|NO_VENT,
		/area/cynosure/science/d1/testing_site       = NO_SCRUBBER|NO_VENT,
		/area/cynosure/maintenance/substation/d2     = NO_SCRUBBER|NO_VENT,
		/area/cynosure/maintenance/d2                = NO_SCRUBBER|NO_VENT,
		/area/cynosure/science/d2/exploration_garage = NO_SCRUBBER|NO_VENT,
		/area/cynosure/maintenance/d3                = NO_SCRUBBER|NO_VENT,
		/area/cynosure/security/d3/riot_control      = NO_SCRUBBER|NO_VENT,
		/area/cynosure/maintenance/substation/d3     = NO_SCRUBBER|NO_VENT,
		/area/shuttle/escape_pod_cynosure_b          = NO_APC|NO_SCRUBBER,
		/area/cynosure/maintenance/construction/d1   = SKIP_ALL_TESTS,
		/area/space                                  = SKIP_ALL_TESTS,
		/area/cynosure/maintenance/d1/incinerator    = 0
	)
	area_coherency_test_exempted_root_areas = list(
		/area/exoplanet,
		// Admin area, don't care.
		/area/centcom,
		// Submap area
		/area/cynosure_submap
	)
	area_coherency_test_exempt_areas = list(
		/area/space,
		// used for surface power transmission to lights
		/area/cynosure/outpost/xenoarch/surface,
		/area/cynosure/hallway/d2/arrivals,
		// used for many outside areas
		/area/surface/cave/unexplored/deep,
		/area/surface/cave/explored/normal,
		/area/surface/outside/station/roof,
		/area/surface/outside/plains/station,
		/area/surface/outside/plains/station/snd,
		/area/surface/outside/plains/normal,
		/area/surface/outside/plains/plateau,
		/area/surface/outside/wilderness/mountains,
		/area/surface/outside/wilderness/normal,
		/area/surface/outside/wilderness/deep,
		/area/surface/outside/path/plains
	)

/datum/map/cynosure/New()
	// Wilderness POI area.
	area_usage_test_exempted_areas |= typesof(/area/cynosure_submap)
	..()
