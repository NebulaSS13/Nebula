datum/map/exodus
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/construction = NO_SCRUBBER|NO_VENT,
		/area/engineering/atmos/storage = NO_SCRUBBER|NO_VENT,
		/area/maintenance = NO_SCRUBBER|NO_VENT,
		/area/maintenance/arrivals = NO_SCRUBBER|NO_VENT,
		/area/maintenance/atmos_control = 0,
		/area/maintenance/auxsolarport = NO_SCRUBBER|NO_VENT,
		/area/maintenance/auxsolarstarboard = NO_SCRUBBER|NO_VENT,
		/area/maintenance/dormitory = NO_SCRUBBER|NO_VENT,
		/area/maintenance/engi_shuttle = NO_SCRUBBER|NO_VENT,
		/area/maintenance/evahallway = NO_SCRUBBER|NO_VENT,
		/area/maintenance/exterior = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/maintenance/medbay = NO_SCRUBBER|NO_VENT,
		/area/maintenance/incinerator = NO_SCRUBBER,
		/area/maintenance/foresolar = NO_SCRUBBER|NO_VENT,
		/area/maintenance/portsolar = NO_SCRUBBER|NO_VENT,
		/area/maintenance/research_port = 0,
		/area/maintenance/research_starboard = NO_SCRUBBER|NO_VENT,
		/area/maintenance/starboardsolar = NO_SCRUBBER|NO_VENT,
		/area/maintenance/sub/aft = NO_SCRUBBER|NO_VENT,
		/area/maintenance/sub/fore = NO_SCRUBBER|NO_VENT,
		/area/maintenance/sub/port = NO_SCRUBBER|NO_VENT,
		/area/maintenance/sub/starboard = NO_SCRUBBER|NO_VENT,
		/area/maintenance/sub/relay_station = 0,
		/area/maintenance/sub/command = 0,
		/area/maintenance/substation/command = 0,
		/area/maintenance/telecomms = 0,
		/area/medical/genetics = NO_APC,
		/area/medical/genetics_cloning = NO_APC,
		/area/rnd/test_area = NO_SCRUBBER|NO_VENT,
		/area/server = 0,
		/area/shuttle = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/solar = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/storage/emergency = NO_SCRUBBER|NO_VENT,
		/area/storage/emergency2 = NO_SCRUBBER|NO_VENT,
		/area/supply = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/exodus_pod_engineering = NO_SCRUBBER|NO_VENT,
		/area/ship/exodus_pod_mining = NO_SCRUBBER|NO_VENT,
		/area/ship/exodus_pod_research = NO_SCRUBBER|NO_VENT
	)

	area_coherency_test_exempt_areas = list(
			/area/space,
			/area/maintenance/exterior)

	area_coherency_test_subarea_count = list(
			/area/engineering/atmos = 4,
			/area/maintenance/incinerator = 2)