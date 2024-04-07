/datum/unit_test/decl_validation
	name = "DECL: Decls shall pass validation"

/datum/unit_test/decl_validation/start_test()
	var/list/failures = list()

	// Check decl validation.
	var/list/decls_to_validate = decls_repository.get_decls_of_type(/decl)
	for(var/decl_type in decls_to_validate)
		var/decl/decl = decls_to_validate[decl_type]
		var/list/validation_results = decl.validate()
		if(length(validation_results))
			failures[decl_type] = validation_results

	// Report failures.
	if(length(failures))
		var/fail_msg ="[length(failures)] /decl\s failed validation:"
		for(var/failed_type in failures)
			fail_msg += "\n- [failed_type]\n\t- [jointext(failures[failed_type], "\n\t- ")]"
		fail(fail_msg)
	else
		pass("All /decl/s were validated successfully.")
	return TRUE
