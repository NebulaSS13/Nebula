#define BITWISE_MAX_BITS 24

/// A bitmap of free ambience group indexes.
var/global/ambience_group_free_bitmap = ~0
var/global/ambience_group_map[BITWISE_MAX_BITS]

/datum/ambience_group
	var/global_index
	var/list/member_turfs_by_z = list()
	var/apparent_r
	var/apparent_g
	var/apparent_b
	var/invalid = FALSE
	var/busy = FALSE

/datum/ambience_group/New()
	global_index = allocate_index()
	if (!global_index)
		invalid = TRUE
		return

	global.ambience_group_map[global_index] = src

/datum/ambience_group/Destroy()
	if (!invalid)
		global.ambience_group_map[global_index] = null
		global.ambience_group_free_bitmap |= (1 << global_index)
	return ..()

/datum/ambience_group/proc/allocate_index()
	if (global.ambience_group_free_bitmap == 0)
		CRASH("Failed to allocate ambience_group: index bitmap is exhausted")

	// Find the first free index in the bitmap.
	var/index = 1
	while (!(global.ambience_group_free_bitmap & (1 << index)) && index < BITWISE_MAX_BITS)
		index += 1

	global.ambience_group_free_bitmap &= ~(1 << index)

	return index

/datum/ambience_group/proc/add_turf(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	if (T.z > member_turfs_by_z)
		member_turfs_by_z.len = T.z

	LAZYADD(member_turfs_by_z[T.z], T)
	T.add_ambient_light_raw(apparent_r, apparent_g, apparent_b)
	T.ambience_active_groups += 1

/datum/ambience_group/proc/remove_turf(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	if (T.z > member_turfs_by_z.len)
		CRASH("Attempt to remove member turf with Z greater than local max -- this turf is not a member")
	T.add_ambient_light_raw(-apparent_r, -apparent_g, -apparent_b)
	member_turfs_by_z[T.z] -= T
	T.ambience_active_groups -= 1

/datum/ambience_group/proc/set_ambient_light(color, multiplier)
	var/list/new_parts = rgb2num(color)

	var/dr = (new_parts[1] / 255) * multiplier - apparent_r
	var/dg = (new_parts[2] / 255) * multiplier - apparent_g
	var/db = (new_parts[3] / 255) * multiplier - apparent_b

	if (round(dr/4, LIGHTING_ROUND_VALUE) == 0 && round(dg/4, LIGHTING_ROUND_VALUE) == 0 && round(db/4, LIGHTING_ROUND_VALUE) == 0)
		// no-op
		return

	busy = TRUE

	// Doing it ordered by zlev should ensure that it looks vaguely coherent mid-update regardless of turf insertion order.
	for (var/zlev in 1 to member_turfs_by_z.len)
		for (var/turf/T as anything in member_turfs_by_z[zlev])
			T.add_ambient_light_raw(dr, dg, db)
			CHECK_TICK

	apparent_r += dr
	apparent_g += dg
	apparent_b += db

	busy = FALSE

/turf
	/// A bitfield of which global ambience groups are affecting this turf.
	var/tmp/ambience_affecting_bitmap = 0
	/// A counter of how many ambience groups are affecting this turf, used to avoid pointlessly iterating the entire 24-bit bitfield.
	var/tmp/ambience_active_groups = 0

/turf/Destroy()
	if (ambience_affecting_bitmap)
		var/remaining_groups = ambience_active_groups
		for (var/i in 1 to BITWISE_MAX_BITS)
			if (ambience_affecting_bitmap & (1 << i))
				var/datum/ambience_group/group = global.ambience_group_map[i]
				add_ambient_light_raw(-group.apparent_r, -group.apparent_g, -group.apparent_b)

				remaining_groups -= 1

				if (!remaining_groups)
					break

	return ..()

/turf/Initialize()
	. = ..()
	if (ambience_affecting_bitmap)
		var/remaining_groups = ambience_active_groups
		for (var/i in 1 to BITWISE_MAX_BITS)
			if (ambience_affecting_bitmap & (1 << i))
				var/datum/ambience_group/group = global.ambience_group_map[i]
				add_ambient_light_raw(group.apparent_r, group.apparent_g, group.apparent_b)
				remaining_groups -= 1

				if (!remaining_groups)
					break
