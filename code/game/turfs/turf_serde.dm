/turf
	var/_earliest_type
	var/_state_was_modified
	var/_contents_were_modified

/turf/ShouldSerialize(_age)
	if(type == _earliest_type && !_state_was_modified && !_contents_were_modified)
		return FALSE
	var/area/area = get_area(src)
	if(!(area?.area_flags & AREA_FLAG_ALLOW_LEVEL_PERSISTENCE))
		return FALSE
	return ..(_age)

/turf/Serialize()
	. = ..()
	SERIALIZE_VALUE(loc, /atom/movable, list(x, y, z))
	SERIALIZE_IF_MODIFIED(is_outside, /turf)

/turf/Deserialize(list/instance_map)
	. = ..()
	state_was_modified()

/turf/proc/state_was_modified()
	if(!simulated || _state_was_modified)
		return
	_state_was_modified = TRUE
	update_level_persistence_tracking()

/atom/proc/contents_were_modified()
	var/turf/turf = get_turf(src)
	turf?.contents_were_modified()

/turf/contents_were_modified()
	if(!simulated || _contents_were_modified)
		return
	_contents_were_modified = TRUE
	update_level_persistence_tracking()

/turf/proc/update_level_persistence_tracking()
	var/area/area = get_area(src)
	if(!(area?.area_flags & AREA_FLAG_ALLOW_LEVEL_PERSISTENCE))
		return
	var/datum/level_data/level = SSmapping.levels_by_z[z]
	if(!istype(level) || !level.is_persistent())
		return
	var/list/coord = json_encode(list(x, y))
	LAZYSET(level.changed_turfs, coord, TRUE)

/turf/proc/UnpackSerializableInstances()
	// Get all recursively nested instances on this turf.
	var/list/instances_to_unpack = list(src)
	while(length(instances_to_unpack))
		var/datum/instance = instances_to_unpack[1]
		instances_to_unpack.Cut(1, 2)
		if(instance in .)
			continue
		LAZYADD(., instance)
		var/list/packed_instances = instance.GetPossiblySerializableInstances()
		if(length(packed_instances))
			instances_to_unpack |= packed_instances
