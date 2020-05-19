/datum/controller/subsystem/mapping


/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()

	// Load our maps dynamically.
	for(var/z in GLOB.using_map.default_levels)
		var/map_file = GLOB.using_map.default_levels[z]
		if(SSpersistence.SaveExists() && (text2num(z) in SSpersistence.saved_levels))
			// Load a default map instead.
			INCREMENT_WORLD_Z_SIZE
			var/turf_type = get_base_turf(z)
			for(var/turf/T in block(locate(1, 1, text2num(z)), locate(world.maxx, world.maxy, text2num(z))))
				T.ChangeTurf(turf_type)
			continue
		maploader.load_map(map_file, 1, 1, text2num(z), no_changeturf = TRUE)
		CHECK_TICK

	// Build the list of static persisted levels from our map.
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading saved map")
#else
	report_progress("Loading world save.")
	SSpersistence.LoadWorld()
#endif

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()

/datum/map
	var/list/default_levels