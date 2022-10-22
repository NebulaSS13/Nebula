// If you add a more comprehensive system, just untick this file.
var/global/list/z_levels = list() // Each Z-level is associated with the relevant map data landmark

/proc/get_map_data(z)
	return z > 0 && z_levels.len >= z ? z_levels[z] : null

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/proc/GetConnectedZlevels(z)
	. = list(z)
	// Traverse up and down to get the multiz stack.
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

	// Check stack for any laterally connected neighbors.
	for(var/tz in .)
		var/obj/abstract/level_data/level = global.levels_by_z["[tz]"]
		if(level)
			level.find_connected_levels(.)

var/global/list/connected_z_cache = list()
/proc/AreConnectedZLevels(var/zA, var/zB)
	if (zA <= 0 || zB <= 0 || zA > world.maxz || zB > world.maxz)
		return FALSE
	if (zA == zB)
		return TRUE
	if (length(global.connected_z_cache) >= zA && length(global.connected_z_cache[zA]) >= zB)
		return global.connected_z_cache[zA][zB]
	var/list/levels = GetConnectedZlevels(zA)
	var/list/new_entry = new(world.maxz)
	for (var/entry in levels)
		new_entry[entry] = TRUE
	if (global.connected_z_cache.len < zA)
		global.connected_z_cache.len = zA
	global.connected_z_cache[zA] = new_entry
	return new_entry[zB]

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)