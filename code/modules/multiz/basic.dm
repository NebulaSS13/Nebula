// If you add a more comprehensive system, just untick this file.
var/global/list/z_levels = list() // Each Z-level is associated with the relevant map data landmark

/proc/get_map_data(z)
	return z > 0 && z_levels.len >= z ? z_levels[z] : null

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	RETURN_TYPE(/turf)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(var/atom/atom)
	RETURN_TYPE(/turf)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)

/proc/get_zstep_resolving_mimic(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)?.resolve_to_actual_turf()
	else if (dir == DOWN)
		. = GetBelow(ref)?.resolve_to_actual_turf()
	else
		. = get_step_resolving_mimic(ref, dir)

/proc/get_dir_multiz(turf/us, turf/them)
	if(!us || !them)
		return 0
	if(us.z == them.z)
		return get_dir(us, them)
	else
		var/dir = 0
		if(them.z > us.z)
			var/turf/T = GET_ABOVE(us)
			if(T && (T.z == them.z))
				dir = UP
			else
				return get_dir(us, them)
		else
			var/turf/T = GET_BELOW(us)
			if(T && (T.z == them.z))
				dir = DOWN
			else
				return get_dir(us, them)

		return (dir | get_dir(us, them))