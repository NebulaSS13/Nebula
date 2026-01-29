/atom/movable/Serialize()
	. = ..()
	if(isturf(loc))
		SERIALIZE_VALUE(loc, /atom/movable, list(loc.x, loc.y, loc.z))
	// The below does not handle cases where the nested instance is not itself persistent.
	// In this case, if the instance tried to serialize while inside a non-persistent instance, it would
	// throw a runtime on subsequent loads due to having a UID as a loc that does not map to a loaded instance.
	else if(isatom(loc))
		SERIALIZE_VALUE(loc, /atom/movable, loc.get_run_uid())

/atom/movable/Deserialize(list/instance_map)
	. = ..()
	contents_were_modified()
