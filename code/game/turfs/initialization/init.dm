/decl/turf_initializer/proc/InitializeTurf(var/turf/T)
	return

/area
	var/turf_initializer = null

/area/Initialize(mapload)
	. = ..()
	if(ispath(turf_initializer))
		var/decl/turf_initializer/ti = GET_DECL(turf_initializer)
		for(var/turf/T in src)
			ti.InitializeTurf(T)
