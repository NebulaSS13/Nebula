/datum/unit_test/station_wires_shall_be_connected
	exceptions = list(list(48, 54, 2, EAST))

/datum/map/bearcat
	// Unit test exemptions

	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/bearcat/maintenance/engine/port = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/maintenance/engine/starboard = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/crew/hallway/port = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/crew/hallway/starboard = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/maintenance/hallway = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/maintenance/lower = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/shuttle/lift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/bearcat/command/hallway = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/escape_port = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/escape_star = NO_SCRUBBER|NO_VENT,
		/area/ship/bearcat/shuttle/outgoing = NO_SCRUBBER,
		/area/ship/bearcat/maintenance/atmos = NO_SCRUBBER
	)
