/datum/map/shaded_hills/New()
	LAZYDISTINCTADD(area_coherency_test_exempted_root_areas, /area/shaded_hills/outside)
	LAZYSET(apc_test_exempt_areas, /area/shaded_hills, (NO_SCRUBBER|NO_VENT|NO_APC))
	..()
