/decl/turf_initializer/proc/InitializeTurf(var/turf/T)
	return

/area
	var/turf_initializer = null

/area/Initialize(mapload)
	. = ..()
	if(ispath(turf_initializer))
		var/decl/turf_initializer/initializer = GET_DECL(turf_initializer)
		// TODO: It may be worth doing a post-mapload loop over turfs instead, to limit the number of in-area (in-world) loops?
		for(var/turf/initialized_turf in src)
			initializer.InitializeTurf(initialized_turf)
