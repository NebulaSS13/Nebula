/turf/proc/handle_ramp_dug_below(turf/wall/natural/ramp)
	if(simulated && !is_open())
		ChangeTurf(get_open_turf_type(z))
		return TRUE
	return FALSE

/turf/floor/handle_ramp_dug_below(turf/wall/natural/ramp)
	var/decl/flooring/floor = get_topmost_flooring()
	return !floor.constructed && ..()
