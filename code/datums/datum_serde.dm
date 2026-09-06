// Used for saving instances via the level persistence system.
// Returns an assoc list of var name to var value.
// Expected format is:
// list("field" = "value", "so on" = "so forth"))
// Using a var name (via nameof() or manually) will automatically load the var to the field in Deserialize.
// If serializing an instance reference, use get_run_uid() to get a UID.
/datum/proc/Serialize()
	SHOULD_CALL_PARENT(TRUE)
	. = list((nameof(/datum::type)) = GetSerializedType())

/datum/proc/GetSerializedType()
	return type

/datum/proc/GetPossiblySerializableInstances()
	return list(src)

// A proc for checking preconditions on an instance to determine if it should bother serializing at all.
/datum/proc/ShouldSerialize(_age)
	SHOULD_CALL_PARENT(TRUE)
	return TRUE

// Returns a UID for this instance, used for serde across rounds.
// Probably-kind-of a GUID but only for this run.
/datum/proc/get_run_uid()
	if(isnull(__run_uid))
		__run_uid = "\ref[src]-[sequential_id(type)]" // Staple seq_id on there in case of \ref reuse.
	return __run_uid

// Called after Initialize()/LateInitialize() on all non-atom datums, and if an atom returns SERDE_HINT_POSTINIT to Deserialize().
/datum/proc/DeserializePostInit(list/instance_map)
	return

// Apply cross-round degradation (graffiti decaying, etc) prior to Deserialize() and Initialize()
// Typically this means modifying __deserialization_payload
/datum/proc/HandlePersistentDecay(entries_decay_at, entry_decay_weight)
	return
