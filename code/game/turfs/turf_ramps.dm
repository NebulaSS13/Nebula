/turf/proc/handle_ramp_dug_below(turf/wall/natural/ramp)
	if(simulated && !is_open())
		ChangeTurf(get_base_turf(z))
