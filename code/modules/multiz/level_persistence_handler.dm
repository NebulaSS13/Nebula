/decl/serialization_handler/proc/get_data_path(location, map, level)
	return "[location]/[map]/[level]"

/decl/serialization_handler/proc/save_level_data(datum/level_data/level_data, location, map, level)
	return // Unimplemented, so return null to indicate a failure

/decl/serialization_handler/proc/save_data_to_file(filepath, save_data, report_id)
	return // Unimplemented, so return null to indicate a failure

/decl/serialization_handler/proc/load_level_data(location, map, level)
	return // Unimplemented, so return null to indicate a failure

/decl/serialization_handler/proc/load_data_from_file(filepath)
	return // Unimplemented, so return null to indicate a failure
