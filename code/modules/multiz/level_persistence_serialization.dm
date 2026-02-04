// General flow of level persistence:
// Saving:
// - SSpersistence periodically iterates the z-level list, finds levels that want to serde, and calls save_persistent_data()
// - Levels return a list of instances to get_persistent_instances(), instances have Serialize() called and return a list of modified fields.
// - Fields are serialized (to JSON with the default handler) and written to disk.
// Loading:
// - SSmapping initializes and calls preload_persistent_data() and load_persistent_data() on relevant /datum/level_data z-level objects.
// - load_persistent_data() creates the base instances and (for atoms) sets __init_deserialisation_payload with the data loaded from tile.
// - SSatoms flush calls Preload() on all deserialized atoms which pre-populates vars on the atom.
// - Ssatoms proceeds to Initialize() atoms as normal.

var/global/list/level_persistence_ref_map = list()
/datum/level_data
	/// String indicating a location for use in serde. Typically a filepath,
	/// but not strictly required to be. Implementation is on the handler.
	/// If set, will automatically suffix map path and level name.
	/// Leave null to opt out of any persistence for this level.
	// Example setting would be:
	//   persistent_data_location = "data/level_data"
	VAR_PROTECTED/persistent_data_location
	/// Decl handler, mostly forcing myself to keep this general so it can be optimized with a DB or something down the track.
	VAR_PRIVATE/persistence_handler = /decl/serialization_handler/json
	/// 2D list of coordinates for turfs to serialize.
	var/list/changed_turfs
	/// Legacy bool. Whether or not this level permits things like graffiti and filth to persist across rounds.
	var/permit_legacy_persistence = FALSE

/datum/level_data/proc/is_persistent()
	return !isnull(persistent_data_location) && !isnull(persistence_handler) && !isnull(level_id)

/datum/level_data/proc/get_persistent_data()
	. = list()
	var/list/instances_to_save = get_persistent_instances()
	if(!length(instances_to_save))
		return
	for(var/datum/thing as anything in get_persistent_instances())
		var/serialized_instance = thing.Serialize()
		if(length(serialized_instance))
			.[thing.get_run_uid()] = serialized_instance

// Returns a linear list of instances that we are interested in saving.
/datum/level_data/proc/get_persistent_instances()
	for(var/coord in changed_turfs)

		var/list/coord_list = cached_json_decode(coord)
		if(!islist(coord_list) || length(coord_list) < 2)
			changed_turfs -= coord
			continue

		var/turf/turf = locate(coord_list[1], coord_list[2], level_z)
		if(!istype(turf) || !turf.ShouldSerialize())
			continue

		for(var/datum/instance in turf.UnpackSerializableInstances())
			if(instance.ShouldSerialize())
				LAZYDISTINCTADD(., instance)

// First load all the raw data into memory so every reference is populated.
/datum/level_data/proc/preload_persistent_data()

	// Basic sanity check.
	if(persistent_data_location && !level_id)
		persistent_data_location = null
		PRINT_STACK_TRACE("Level data [type] tried to initialize persistent data but had no level_id.")
		return FALSE

	// Don't bother if we aren't configured for it at all.
	if(!is_persistent())
		return FALSE

	// Atoms on a map are expected to be returned as an associative list with some specific text keys.
	try
		var/decl/serialization_handler/load_handler = GET_DECL(persistence_handler)
		var/list/loaded_data = load_handler?.load_level_data(persistent_data_location, global.using_map.path, ckey(level_id))
		if(islist(loaded_data) && length(loaded_data))
			var/list/instance_map = list()
			global.level_persistence_ref_map[level_id] = instance_map
			for(var/uid in loaded_data)
				instance_map[uid] = loaded_data[uid]
			return TRUE
	catch(var/exception/E)
		PRINT_STACK_TRACE("Exception during '[level_id]' preload: [EXCEPTION_TEXT(E)]")

	return FALSE

// Now create the instances and register them in the global map. Note that levels
// with no level_id or no persistence handling set will not reach this proc.
// Returns TRUE if it loaded anything; this may imply not needing to run level
// generation for this level (random maps, etc)
/datum/level_data/proc/load_persistent_data()
	_has_serde_data = length(instantiate_serialized_data(level_z, "[level_id]/[name]", global.level_persistence_ref_map[level_id])) > 0
	return _has_serde_data

// Write any data out if we need to.
/datum/level_data/proc/save_persistent_data()
	// TODO: block any changes to persistent data structures while save is running?
	if(is_persistent())
		var/decl/serialization_handler/save_handler = GET_DECL(persistence_handler)
		save_handler?.save_level_data(src, persistent_data_location, global.using_map.path, ckey(level_id))
