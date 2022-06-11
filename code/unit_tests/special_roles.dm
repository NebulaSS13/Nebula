/datum/unit_test/special_roles_will_have_valid_base_templates
	name = "ROLES: All special roles with base maps will have valid templates"

/datum/unit_test/special_roles_will_have_valid_base_templates/start_test()
	var/list/failures = list()

	var/list/all_roles = decls_repository.get_decls_of_subtype(/decl/special_role)
	for(var/role_type in all_roles)
		var/decl/special_role/role = all_roles[role_type]
		// Grab initial in case it was already successfully loaded.
		var/initial_base_to_load = initial(role.base_to_load)
		if(isnull(initial_base_to_load))
			continue
		if(!istext(initial_base_to_load))
			failures += "[role_type] had non-text base_to_load value '[initial_base_to_load]'."
			continue
		var/datum/map_template/base = SSmapping.get_template(initial_base_to_load)
		if(!istype(base))
			failures += "[role_type] failed to retrieve base_to_load template '[initial_base_to_load]'."
			continue
		if(!base.loaded && !role.load_required_map())
			failures += "[role_type] failed to load base_to_load template '[base.name]'."

	if(length(failures))
		fail("[length(failures)] special role\s had invalid base_to_load templates:\n[jointext(failures, "\n")].")
	else
		pass("All special role base_to_load values were null or valid.")
	return 1
