// If you add a more comprehensive system, just untick this file.
var/global/list/z_levels = list() // Each Z-level is associated with the relevant map data landmark

/proc/get_map_data(z)
	return z > 0 && z_levels.len >= z ? z_levels[z] : null

// If the height is more than 1, we mark all contained levels as connected.
// This is in New because it is an auxiliary effect specifically needed pre-init.
/obj/effect/landmark/map_data/New(turf/loc, _height)
	..()
	if(!istype(loc)) // Using loc.z is safer when using the maploader and New.
		return
	if(_height)
		height = _height
	for(var/i = (loc.z - height + 1) to (loc.z-1))
		if (z_levels.len <i)
			z_levels.len = i
		z_levels[i] = src

	if (length(SSzcopy.zlev_maximums))
		SSzcopy.calculate_zstack_limits()

/obj/effect/landmark/map_data/Destroy(forced)
	if(forced)
		new type(loc, height) // Will replace our references in z_levels
		return ..()
	return QDEL_HINT_LETMELIVE

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
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

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