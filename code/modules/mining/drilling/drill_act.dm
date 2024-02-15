/turf/proc/drill_act()
	SHOULD_CALL_PARENT(TRUE)
	drop_diggable_resources()
	dig_pit()
	var/base_turf = get_base_turf_by_area(src)
	if(!istype(src, base_turf))
		return ChangeTurf(base_turf)
	return src
	// This could have some kind of 'drill everything on the turf' block as well
	// but there is no visual indicator for a drill above you currently and that
	// seems like it would be a bit unfair on people wandering into the beam.

/turf/simulated/wall/drill_act()
	SHOULD_CALL_PARENT(FALSE)
	dismantle_wall(TRUE)

/turf/unsimulated/drill_act()
	SHOULD_CALL_PARENT(FALSE)

/turf/space/drill_act()
	SHOULD_CALL_PARENT(FALSE)
