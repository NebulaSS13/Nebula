/turf/floor/Serialize()
	. = ..()

	SERIALIZE_IF_MODIFIED(_floor_broken, /turf/floor)
	SERIALIZE_IF_MODIFIED(_floor_burned, /turf/floor)
	SERIALIZE_IF_MODIFIED(height, /turf/floor)
	SERIALIZE_DECL_IF_MODIFIED(_base_flooring, /turf/floor)

	var/initial_flooring = initial(_flooring)
	if(isnull(_flooring) && !isnull(initial_flooring))
		.[nameof(/turf/floor::_flooring)] = json_encode(list())
	else if((ispath(_flooring) || istype(_flooring, /decl)) && (!ispath(initial_flooring) || !DECLS_ARE_EQUIVALENT(_flooring, initial_flooring)))
		var/decl/flooring/flooring = RESOLVE_TO_DECL(_flooring)
		if(istype(flooring))
			.[nameof(/turf/floor::_flooring)] = json_encode(list(flooring.uid))
	else if(islist(_flooring))
		var/list/flooring_uids
		for(var/floor in _flooring)
			var/decl/flooring/floor_decl = RESOLVE_TO_DECL(floor)
			if(istype(floor_decl))
				LAZYADD(flooring_uids, floor_decl.uid)
		if(!istext(initial_flooring) || !(flooring_uids ~= cached_json_decode(initial_flooring)))
			.[nameof(/turf/floor::_flooring)] = json_encode(flooring_uids)

/turf/floor/Deserialize(list/instance_map)
	. = ..()
	fill_reagent_type = null // Assume any fluids on this turf were serialized and will be deserialized on /turf/Deserialize()
	DESERIALIZE_DECL_TO_TYPE(_base_flooring)
	// _flooring is expected as a JSON list in base floor
	// Initialize(), so no additional deserializing needed here.
