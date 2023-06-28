SUBSYSTEM_DEF(configuration)
	name = "Configuration"
	flags = SS_NO_FIRE | SS_NO_INIT
	var/list/configuration_file_locations = list()
	var/load_sql_from = "config/dbconfig.txt"
	var/load_event_from = "config/custom_event.txt"

/datum/controller/subsystem/configuration/proc/load_all_configuration()

	// Assemble a list of all the files we are expected to load this run.
	var/list/all_config = decls_repository.get_decls_of_subtype(/decl/configuration_category)
	for(var/config_cat_type in all_config)
		var/decl/configuration_category/config_cat = all_config[config_cat_type]
		configuration_file_locations |= config_cat.configuration_file_location

	load_files()
	load_sql()
	load_event()

	for(var/client/C)
		C.update_post_config_load()

/client/proc/update_post_config_load()
	if(get_config_value(/decl/config/toggle/allow_character_comments))
		verbs |= /client/proc/view_character_information
	else
		verbs -= /client/proc/view_character_information

/datum/controller/subsystem/configuration/proc/write_default_configuration(var/list/specific_files, var/modify_write_prefix)

	if(!specific_files)
		specific_files = configuration_file_locations
	else if(!islist(specific_files))
		specific_files = list(specific_files)

	if(!length(specific_files))
		return

	var/list/config_lines = list()
	var/list/all_config = decls_repository.get_decls_of_subtype(/decl/configuration_category)
	var/list/sorted_config = list()
	for(var/config_type in all_config)
		sorted_config += all_config[config_type]
	for(var/decl/configuration_category/config_cat as anything in sortTim(sorted_config, /proc/cmp_name_asc))
		if(!(config_cat.configuration_file_location in specific_files))
			continue
		LAZYADD(config_lines["[modify_write_prefix][config_cat.configuration_file_location]"], config_cat.get_config_category_text())

	for(var/filename in config_lines)
		if(fexists(filename))
			fdel(filename)
		var/write_file = file(filename)
		to_file(write_file, jointext(config_lines[filename], "\n\n"))

/datum/controller/subsystem/configuration/proc/load_files()

	// Load values from file into an assoc list.
	var/list/loaded_values = list()
	var/list/write_defaults = list()
	for(var/filename in configuration_file_locations)

		if(!fexists(filename))
			write_defaults += filename
			continue

		var/list/lines = file2list(filename)
		for(var/line in lines)
			line = trim(line)
			if(!line || length(line) == 0 || copytext(line, 1, 2) == "#")
				continue
			var/pos = findtext(line, " ")
			var/config_key
			var/config_value
			if(pos)
				config_key   = copytext(line, 1, pos)
				config_value = copytext(line, pos + 1)
			else
				config_key =   line
				config_value = TRUE
			if(config_key)
				config_key = lowertext(trim(config_key))
				if(config_key in loaded_values)
					PRINT_STACK_TRACE("Duplicate config value loaded for key '[config_key]' from file '[filename]'.")
				loaded_values[config_key] = config_value

	// Write any defaults that aren't already populated.
	if(length(write_defaults))
		write_default_configuration(write_defaults)

	// Set our config values on the decls.
	var/list/config_to_refresh = list()
	var/list/all_config_decls = decls_repository.get_decls_of_subtype(/decl/config)
	for(var/config_type in all_config_decls)
		var/decl/config/config_option = all_config_decls[config_type]
		if(config_option.uid in loaded_values)
			if(set_config_value(config_type, loaded_values[config_option.uid], defer_config_refresh = TRUE))
				config_to_refresh += config_option
			loaded_values -= config_option.uid

	// Do a refresh now that all values are populated.
	for(var/decl/config/config_option as anything in config_to_refresh)
		config_option.update_post_value_set()

/datum/controller/subsystem/configuration/proc/load_event(filename)
	var/event_info = safe_file2text(filename, FALSE)
	if(event_info)
		global.custom_event_msg = event_info

/datum/controller/subsystem/configuration/proc/load_sql()
	var/list/lines = file2list(load_sql_from)
	for(var/line in lines)
		if(!line)
			continue
		line = trim(line)
		if (length(line) == 0 || copytext(line, 1, 2) == "#")
			continue

		var/pos = findtext(line, " ")
		var/name = null
		var/value = null
		if (pos)
			name = lowertext(copytext(line, 1, pos))
			value = copytext(line, pos + 1)
		else
			name = lowertext(line)
		if (!name)
			continue

		switch (name)
			if ("enabled")
				sqlenabled = TRUE
			if ("address")
				sqladdress = value
			if ("port")
				sqlport = value
			if ("database")
				sqldb = value
			if ("login")
				sqllogin = value
			if ("password")
				sqlpass = value
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/admins/proc/dump_configuration()
	set category = "Admin"
	set name = "Dump Configuration"
	set desc = "Writes out the current configuration to file."
	if(!ishost(usr?.client))
		to_chat(usr, SPAN_WARNING("This verb can only be used by the host."))
		return
	SSconfiguration.write_default_configuration(modify_write_prefix = "temp/")
	to_chat(usr, SPAN_NOTICE("All done!"))
