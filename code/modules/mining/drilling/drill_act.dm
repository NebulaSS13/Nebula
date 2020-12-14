/turf/proc/drill_act()
	SHOULD_CALL_PARENT(TRUE)
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

/turf/simulated/open/drill_act()
	SHOULD_CALL_PARENT(FALSE)
	var/turf/T = GetBelow(src)
	if(istype(T))
		T.drill_act()

/turf/exterior/open/drill_act()
	SHOULD_CALL_PARENT(FALSE)
	var/turf/T = GetBelow(src)
	if(istype(T))
		T.drill_act()

/turf/exterior/drill_act()
	var/turf/exterior/digging = ..()
	if(istype(digging) && digging.diggable)
		new /obj/structure/pit(digging)
		digging.diggable = FALSE
	return digging

/turf/simulated/floor/asteroid/drill_act()
	var/turf/simulated/floor/asteroid/digging = ..()
	if(istype(digging) && !digging.dug)
		digging.gets_dug()
	return digging