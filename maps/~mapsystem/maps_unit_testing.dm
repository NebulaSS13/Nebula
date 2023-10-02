/datum/map
	var/const/NO_APC = 1
	var/const/NO_VENT = 2
	var/const/NO_SCRUBBER = 4

	/// Defines the expected result of the atmospherics shuttle unit test for atmosphere.
	var/shuttle_atmos_expectation = UT_NORMAL

	// Unit test vars
	var/list/apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC
	)

	var/list/area_coherency_test_exempt_areas = list(
		/area/space
	)
	var/list/area_coherency_test_exempted_root_areas = list(
		/area/exoplanet
	)
	var/list/area_coherency_test_subarea_count = list()

	// These areas are used specifically by code and need to be broken out somehow
	var/list/area_usage_test_exempted_areas = list(
		/area/ship,
		/area/hallway,
		/area/maintenance,
		/area/overmap,
		/area/shuttle,
		/area/turbolift,
		/area/template_noop
	)

	var/list/area_usage_test_exempted_root_areas = list(
		/area/map_template,
		/area/exoplanet
	)

	var/list/area_purity_test_exempt_areas = list()

	/// A list of disposals tags (sort_type var) that aren't expected to have outputs.
	var/list/disconnected_disposals_tags = list()

	/// A list of lists, of the format ((x, y, z, dir),).
	var/list/disconnected_wires_test_exempt_turfs = list()

