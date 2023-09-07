/datum/map/tradeship
	disconnected_wires_test_exempt_turfs = list(list(48, 54, 3, EAST))
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/turbolift =                               NO_SCRUBBER|NO_VENT|NO_APC,
		/area/space =                                   NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet =                               NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/trade/maintenance/engine/port =      NO_SCRUBBER|NO_VENT,
		/area/ship/trade/maintenance/engine/starboard = NO_SCRUBBER|NO_VENT,
		/area/ship/trade/crew/hallway/port =            NO_SCRUBBER|NO_VENT,
		/area/ship/trade/crew/hallway/starboard =       NO_SCRUBBER|NO_VENT,
		/area/ship/trade/maintenance/hallway =          NO_SCRUBBER|NO_VENT,
		/area/ship/trade/maintenance/lower =            NO_SCRUBBER|NO_VENT,
		/area/ship/trade/escape_port =                  NO_SCRUBBER|NO_VENT,
		/area/ship/trade/escape_star =                  NO_SCRUBBER|NO_VENT,
		/area/ship/trade/shuttle/rescue =               NO_SCRUBBER|NO_VENT,
		/area/ship/trade/shuttle/outgoing/general =     NO_SCRUBBER,
		/area/ship/trade/shuttle/outgoing/engineering = NO_SCRUBBER,
		/area/ship/trade/maintenance/atmos =            NO_SCRUBBER
	)

