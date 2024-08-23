/turf/unsimulated
	name = "command"
	initial_gas = GAS_STANDARD_AIRMIX
	abstract_type = /turf/unsimulated
	simulated = FALSE

// Shortcut a bunch of simulation stuff since this turf just needs to sit there.
// We don't even call Initialize(), how cool is that???
/turf/unsimulated/New()
	// Preloader stuff copied from /atom/New() for speed.
	//atom creation method that preloads variables at creation
	if(global.use_preloader && (src.type == global._preloader.target_path))//in case the instanciated atom is creating other atoms in New()
		global._preloader.load(src)
	atom_flags |= ATOM_FLAG_INITIALIZED

/turf/unsimulated/ChangeTurf(turf/N, tell_universe, force_lighting_update, keep_air, update_open_turfs_above, keep_height)
	if(!SSmapping.initialized)
		atom_flags = 0 // We want ChangeTurf to treat us as if we aren't initialized if SSmapping isn't done.
	return ..()

/turf/unsimulated/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	return INITIALIZE_HINT_NORMAL

/turf/unsimulated/get_lumcount(var/minlum = 0, var/maxlum = 1)
	return 0.8
