/atom
	/// Var for holding serde information when this atom was loaded from a persistent source.
	var/__deserialization_payload

/atom/Serialize()
	. = ..()
	if(current_health != get_max_health())
		SERIALIZE(current_health, /atom)
	SERIALIZE_IF_MODIFIED(max_health, /atom)
	SERIALIZE_IF_MODIFIED(dir, /atom)
	if(ATOM_IS_TEMPERATURE_SENSITIVE(src))
		SERIALIZE_IF_MODIFIED(temperature, /atom)
	if(istype(reagents))
		SERIALIZE_REAGENTS(reagents, /atom, "atom")
	SERIALIZE_DECL_IF_MODIFIED(material, /atom)
	SERIALIZE_DECL_IF_MODIFIED(reinf_material, /atom)
	SERIALIZE_IF_MODIFIED(paint_color, /atom)
	SERIALIZE_IF_MODIFIED(pixel_x, /atom)
	SERIALIZE_IF_MODIFIED(pixel_y, /atom)
	SERIALIZE_IF_MODIFIED(default_pixel_x, /atom)
	SERIALIZE_IF_MODIFIED(default_pixel_y, /atom)

// Keeping this in code for reference, but a large number of atoms generate
// name and desc at runtime, so not storing this in serde by default.
/*
	SERIALIZE_IF_MODIFIED(name, /atom)
	SERIALIZE_IF_MODIFIED(desc, /atom)
*/
	// TODO: serialize forensics

/atom/proc/Deserialize(list/instance_map)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	for(var/data_key in __deserialization_payload)
		if(data_key in vars)
			try
				if(!global._forbid_field_load[data_key] && (data_key in vars))
					vars[data_key] = __deserialization_payload[data_key]
				else
					PreloadKey(data_key, __deserialization_payload[data_key])
			catch(var/exception/E)
				error("Failed to write [data_key] to [type] vars: [E]")
	DESERIALIZE_REAGENTS(reagents, "atom") // Handled in initialize_reagents()
	DESERIALIZE_DECL_TO_TYPE(material)
	DESERIALIZE_DECL_TO_TYPE(reinf_material)
	return SERDE_HINT_FINISHED

/atom/ShouldSerialize(_age)
	return ..() && simulated

/atom/GetPossiblySerializableInstances()
	. = ..()
	var/list/contained = get_contained_external_atoms()
	if(length(contained))
		. |= contained

/atom/Exited(atom/movable/atom, atom/newloc)
	. = ..()
	if(simulated && atom.ShouldSerialize())
		contents_were_modified()

/atom/Entered(atom/movable/atom, atom/old_loc)
	. = ..()
	if(simulated && atom.ShouldSerialize())
		contents_were_modified()

// Called when an instance is being preloaded with information from deserialization.
/atom/proc/Preload(list/instance_map)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/turf/turf = get_turf(src)
	if(__deserialization_payload)
		try
			. = Deserialize(instance_map)
		catch(var/exception/E)
			PRINT_STACK_TRACE("Exception when deserializing [type] at ([turf?.x || "NULL"],[turf?.y || "NULL"],[turf?.z || "NULL"]): [E]")
	else
		PRINT_STACK_TRACE("[type] at ([turf?.x || "NULL"],[turf?.y || "NULL"],[turf?.z || "NULL"]) tried to preload with no deserialization payload.")

/atom/proc/PreloadKey(data_key, payload)
	return
