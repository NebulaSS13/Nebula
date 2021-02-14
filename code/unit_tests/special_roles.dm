/datum/unit_test/special_roles_with_maps_shall_load_without_errors
	name = "SPECIAL ROLES: special role maps will load without errors."

/datum/unit_test/special_roles_with_maps_shall_load_without_errors/start_test()

	var/success_count = 0
	var/list/failures = list()
	var/list/all_special_roles = decls_repository.get_decls_of_subtype(/decl/special_role)
	for(var/rtype in all_special_roles)
		var/decl/special_role/role = all_special_roles[rtype]
		if(!role.base_to_load)
			continue
		var/loaded_map = FALSE
		var/failure_message = "[role.name] ([rtype]) failed to load map '[role.base_to_load]'"
		try
			loaded_map = role.load_required_map()
		catch(var/exception/e)
			failure_message += ": [e] on [e.file]:[e.line]"
		if(!loaded_map)
			failures += failure_message
		else
			success_count++

	if(length(failures))
		fail("Some special role maps did not load without errors:\n[jointext(failures, "\n")]")
	else if(success_count)
		pass("All [success_count] special role map\s loaded without errors.")
	else
		skip("There are no special roles with maps to load.")
	return 1