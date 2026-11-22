SUBSYSTEM_DEF(ambient_lights)
	name = "Lighting: Ambient"
	flags = SS_NO_FIRE | SS_NO_INIT
	/// A bitmap of free ambience group indexes.
	var/ambience_group_free_bitmap = ~0
	/// A mapping of ambience slot to ambience group datums.
	var/ambience_group_map[BITWISE_MAX_BITS]
	/// Raw count of active ambience groups to make stat_entry cheap.
	var/ambience_active_members = 0

/datum/controller/subsystem/ambient_lights/stat_entry(msg)
	var/list/lines = list(
		"Dynamic: [ambience_active_members]"	// header
	)
	if (ambience_active_members > 0)
		for (var/datum/ambience_group/grp in ambience_group_map)
			var/list/zlev_entries = new/list(length(grp.member_turfs_by_z))
			for (var/i in 1 to length(grp.member_turfs_by_z))
				zlev_entries[i] = length(grp.member_turfs_by_z[i])
			// lines += "Group [grp.global_index]: [grp.apparent_r]/[grp.apparent_g]/[grp.apparent_b] -> [json_encode(zlev_entries)]"
			lines += "Group [grp.global_index]: approx. [rgb(grp.apparent_r * 255, grp.apparent_g * 255, grp.apparent_b * 255)] -> [json_encode(zlev_entries)]"
	..(lines.Join("\n\t"))

/datum/controller/subsystem/ambient_lights/proc/allocate_index()
	if (ambience_group_free_bitmap == 0)
		CRASH("Failed to allocate ambience_group: index bitmap is exhausted")

	// Find the first free index in the bitmap.
	var/index = 1
	while (!(ambience_group_free_bitmap & (1 << index)) && index < BITWISE_MAX_BITS)
		index += 1

	ambience_group_free_bitmap &= ~(1 << index)
	ambience_active_members += 1

	log_ss(name, "allocating slot [index]")

	return index

/datum/controller/subsystem/ambient_lights/proc/free_index(index)
	if (!ambience_group_map[index])
		CRASH("Attempt to free unused ambience slot?")

	ambience_group_map[index] = null
	ambience_group_free_bitmap |= (1 << index)
	ambience_active_members -= 1

	log_ss(name, "deallocated slot [index]")
