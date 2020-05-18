GLOBAL_LIST_EMPTY(flatten_types)
GLOBAL_LIST_INIT(saved_vars, initialize_saved_vars())
GLOBAL_LIST_INIT(blacklisted_vars, list("is_processing", "vars", "active_timers", "weakref", "type", "parent_type"))

/proc/initialize_saved_vars()
	. = list()

	// Stats
	var/loaded_types = 0
	var/loaded_vars = 0

	// Actual serialization
	for(var/saved_var in json_decode(file2text('./mods/persistence/saved_vars.json')))
		if(!saved_var["path"])
			continue
		if(!saved_var["vars"] || !length(saved_var["vars"]))
			continue
		var/path
		try
			path = text2path(saved_var["path"])
		catch
			to_world_log("[saved_var["path"]] does not exist.")
			continue
		var/subtypes = subtypesof(path)
		loaded_types += length(subtypes) + 1
		if(saved_var["flatten"])
			// We're flattening this obj too.
			LAZYDISTINCTADD(GLOB.flatten_types, path)

		for(var/v in saved_var["vars"])
			LAZYDISTINCTADD(.[path], v)
			loaded_vars++
			for(var/subtype in subtypes)
				LAZYDISTINCTADD(.[subtype], v)

	to_world_log("Successfully loaded [loaded_types] serialized types, and [loaded_vars] variables.")

