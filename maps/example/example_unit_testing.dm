/datum/map/example
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shuttle/ferry = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/abstract/map_data/example
	height = 3

// Enforce that this map must not have any modpacks, to ensure core code compiles on its own.
// I'd do this in setup_map on the example map datum but that happens before modpack init.
// This catches any modpacks accidentally included by core code, default away sites, space/planet ruin maps, etc.
/datum/controller/subsystem/modpacks/Initialize()
	. = ..()
	if(length(loaded_modpacks))
		CRASH("Example map had the following modpacks loaded: [json_encode(loaded_modpacks)]")