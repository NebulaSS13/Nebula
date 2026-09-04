/decl/serialization_handler/json/get_data_path(location, map, level)
	return "[..()].json"

/decl/serialization_handler/json/save_level_data(datum/level_data/level_data, location, map, level)
	return save_data_to_file(get_data_path(location, map, level), level_data.get_persistent_data(), level_data.level_id)

/decl/serialization_handler/json/save_data_to_file(filepath, save_data, report_id)
	try
		if(!length(save_data))
			return 1

		var/write_data = json_encode(save_data)
		var/write_file = file(filepath)

		// Do a backup (at the end to avoid overwriting then throwing an exception)
		if(fexists(filepath))
			var/backup_contents = file2text(filepath)
			var/backup_file = file("[filepath].[time2text(REALTIMEOFDAY, "YY-MM-DD_hh-mm")].backup")
			to_file(backup_file, backup_contents)
			// Clear old file to avoid appending data.
			// TODO: remove old backups? Leave as an exercise for the admin?
			fdel(filepath)

		// Finally, write out our new json.
		to_file(write_file, write_data)
		report_progress("Saved [length(save_data)] record\s for [report_id].")

	catch(var/exception/E)
		error("Exception when saving persistent level data to [filepath]: [EXCEPTION_TEXT(E)]")
		return null

	return 1 // Return a non-null value just to show we didn't throw an exception.

/decl/serialization_handler/json/load_level_data(location, map, level)
	return load_data_from_file(get_data_path(location, map, level))

/decl/serialization_handler/json/load_data_from_file(filepath)
	try
		if(fexists(filepath)) // done separately to avoid generating an error for levels with no saved data
			var/loaded_json = safe_file2text(filepath)
			if(loaded_json)
				return json_decode(loaded_json) // do not cache this giant blob pls
	catch(var/exception/E)
		error("Exception when loading persistent level data from [filepath]: [EXCEPTION_TEXT(E)]")
		return null
	return 1 // Return a non-null value just to show we didn't throw an exception.