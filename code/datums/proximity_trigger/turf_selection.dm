/decl/turf_selection/proc/get_turfs(var/atom/origin, var/range, var/l_angle, var/r_angle)
	return list()

/decl/turf_selection/line/get_turfs(var/atom/origin, var/range, var/l_angle, var/r_angle)
	. = list()
	var/center = get_turf(origin)
	if(!center)
		return
	. += center
	for(var/i = 1 to range)
		center = get_step(center, origin.dir)
		if(!center) // Reached the end of the world most likely
			return
		. += center

/decl/turf_selection/square/get_turfs(var/atom/origin, var/range, var/l_angle, var/r_angle)
	. = list()
	var/turf/center = get_turf(origin)
	if(!center)
		return
	for(var/turf/T in RANGE_TURFS(center, range))
		. += T

/decl/turf_selection/angle/get_turfs(var/atom/origin, var/range, var/l_angle, var/r_angle)
	. = list()
	var/turf/center = get_turf(origin)
	if(!center)
		return
	for(var/turf/T in RANGE_TURFS(center, range))
		if((l_angle == 0 && r_angle == 0) || angle_between_two_angles(l_angle, Atan2(T.x - center.x, T.y - center.y) - 90, r_angle))
			. += T