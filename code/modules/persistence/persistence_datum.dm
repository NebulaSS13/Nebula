// This is a set of datums instantiated by SSpersistence.
// They basically just handle loading, processing and saving specific forms
// of persistent data like graffiti and round to round filth.

/decl/persistence_handler
	var/name                       // Unique descriptive name. Used for generating filename.
	var/filename                   // Set at runtime. Full path and .json extension for loading saved data.
	var/entries_expire_at          // Entries are removed if they are older than this number of rounds.
	var/entries_decay_at           // Entries begin to decay if they are older than this number of rounds (if applicable).
	var/entry_decay_weight = 0.5   // A modifier for the rapidity of decay.
	var/has_admin_data             // If set, shows up on the admin persistence panel.
	var/ignore_area_flags = FALSE  // Set to TRUE to skip area flag checks such as nonpersistent areas.
	var/ignore_invalid_loc = FALSE // Set to TRUE to skip checking for a non-null station turf for the entry.
	var/list/legacy_map_values     // A list of legacy keys to new keys.
	var/legacy_type
	var/serialization_handler = /decl/serialization_handler/json // Which serialization handler to use for load/save
	var/area_restricted = TRUE     // Can this item persist outside of a flagged area?
	var/station_restricted = TRUE  // Can this item persist outside of a station level?

/decl/persistence_handler/proc/SetFilename()
	if(name)
		filename = "data/persistent/[ckey(global.using_map.name)]-[ckey(name)].json"
	if(!isnull(entries_decay_at) && !isnull(entries_expire_at))
		entries_decay_at = floor(entries_expire_at * entries_decay_at)

/decl/persistence_handler/proc/IsValidEntry(var/atom/entry)
	if(!istype(entry))
		return FALSE
	if(!entry.ShouldSerialize(entries_expire_at))
		return FALSE
	var/turf/T = get_turf(entry)
	if(!ignore_invalid_loc && (!T || !isStationLevel(T.z)))
		return FALSE
	var/area/A = get_area(T)
	if(!ignore_area_flags && (!A || (A.area_flags & AREA_FLAG_NO_LEGACY_PERSISTENCE)))
		return FALSE
	return TRUE

/decl/persistence_handler/proc/GetEntryAge(var/atom/entry)
	return 0

/decl/persistence_handler/Initialize()

	SetFilename()

	. = ..()

	if(!fexists(filename))
		return

	var/decl/serialization_handler/handler = GET_DECL(serialization_handler)
	var/list/entries = handler.load_data_from_file(filename)

	if(!length(entries))
		return

	// Check for old-style persistence data and generate a key.
	if(length(entries) && !istext(entries[1]))
		try
		// Save a backup of the old file just in case we cook it.
			fcopy(filename, "[filename]-legacy.[time2text(REALTIMEOFDAY, "YY-MM-DD_hh-mm")].backup")
		catch(var/exception/e)
			log_error("Exception during saving backup of legacy file [filename]: [EXCEPTION_TEXT(e)]")

		// Update the data to match the expected format of the new system.
		var/list/entries_with_key = list()
		var/i = 1
		for(var/entry in entries)
			entries_with_key[num2text(i)] = UpdateFromLegacyFormat(entry)
		entries = entries_with_key

	instantiate_serialized_data(null, name, entries, entries_decay_at, entry_decay_weight)

/decl/persistence_handler/proc/Shutdown()
	var/list/entries = list()
	for(var/atom/thing in SSpersistence.tracking_values[type])
		if(IsValidEntry(thing))
			var/list/things_to_serialize = thing.GetPossiblySerializableInstances()
			for(var/datum/subthing in things_to_serialize)
				entries[subthing.get_run_uid()] = subthing.Serialize()
	var/decl/serialization_handler/handler = GET_DECL(serialization_handler)
	handler.save_data_to_file(filename, entries, name)

/decl/persistence_handler/proc/RemoveValue(var/atom/value)
	qdel(value)

/decl/persistence_handler/proc/UpdateFromLegacyFormat(list/_entry)

	// Convert any old values to the new indices.
	for(var/map_key in legacy_map_values)
		if(map_key in _entry)
			var/value = _entry[map_key]
			_entry -= map_key
			_entry[legacy_map_values[map_key]] = value

	// Convert entry coords into new format.
	if(("x" in _entry) || ("y" in _entry) || ("z" in _entry))
		_entry["loc"] = list(
			_entry["x"] || 1,
			_entry["y"] || 1,
			_entry["z"] || 1
		)
		_entry -= "x"
		_entry -= "y"
		_entry -= "z"

	if(legacy_type && !(nameof(/datum::type) in _entry))
		_entry[nameof(/datum::type)] = legacy_type

	return _entry

/decl/persistence_handler/proc/GetAdminSummary(var/mob/user, var/can_modify)
	. = list("<tr><td colspan = 4><b>[capitalize(name)]</b></td></tr>")
	. += "<tr><td colspan = 4><hr></td></tr>"
	for(var/thing in SSpersistence.tracking_values[type])
		if(IsValidEntry(thing))
			. += "<tr>[GetAdminDataStringFor(thing, can_modify, user)]</tr>"
	. += "<tr><td colspan = 4><hr></td></tr>"

/decl/persistence_handler/proc/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	if(can_modify)
		. = "<td colspan = 3>[thing]</td><td><a href='byond://?src=\ref[src];user=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 4>[thing]</td>"

/decl/persistence_handler/Topic(var/href, var/href_list)
	. = ..()
	if(!.)
		if(href_list["remove_entry"])
			var/datum/value = locate(href_list["remove_entry"])
			if(istype(value))
				RemoveValue(value)
				. = TRUE
		if(.)
			var/mob/user = locate(href_list["user"])
			if(user)
				SSpersistence.show_info(user)
