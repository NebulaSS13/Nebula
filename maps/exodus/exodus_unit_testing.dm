/datum/map/exodus
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exodus/construction = NO_SCRUBBER|NO_VENT,
		/area/exodus/engineering/atmos/storage = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/disused = 0,
		/area/exodus/maintenance/arrivals = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/atmos_control = 0,
		/area/exodus/maintenance/auxsolarport = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/auxsolarstarboard = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/dormitory = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/engi_shuttle = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/evahallway = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/exterior = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exodus/maintenance/medbay = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/incinerator = NO_SCRUBBER,
		/area/exodus/maintenance/foresolar = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/portsolar = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/research_port = 0,
		/area/exodus/maintenance/research_starboard = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/starboardsolar = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/sub/aft = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/sub/fore = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/sub/port = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/sub/starboard = NO_SCRUBBER|NO_VENT,
		/area/exodus/maintenance/sub/relay_station = 0,
		/area/exodus/maintenance/sub/command = 0,
		/area/exodus/maintenance/substation/command = 0,
		/area/exodus/maintenance/telecomms = 0,
		/area/exodus/medical/genetics = NO_APC,
		/area/exodus/medical/genetics/cloning = NO_APC,
		/area/exodus/research/test_area = NO_SCRUBBER|NO_VENT,
		/area/exodus/research/server = 0,
		/area/shuttle = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exodus/solar = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exodus/storage/emergency = NO_SCRUBBER|NO_VENT,
		/area/exodus/storage/emergency2 = NO_SCRUBBER|NO_VENT,
		/area/ship/exodus_pod_engineering = NO_SCRUBBER|NO_VENT
	)

	area_coherency_test_exempt_areas = list(
		/area/space,
		/area/exodus/maintenance/exterior)

	area_coherency_test_subarea_count = list(
		/area/exodus/engineering/atmos = 4,
		/area/exodus/maintenance/incinerator = 2)

/obj/abstract/map_data/exodus
	height = 2
