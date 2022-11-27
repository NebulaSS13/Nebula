/datum/unit_test/decl_validation
	name = "DECL: Decls shall pass validation"

/datum/unit_test/decl_validation/start_test()
	var/list/failures = list()

	// Check decl validation.
	for(var/decl_type in typesof(/decl))
		var/decl/decl = decl_type
		if(TYPE_IS_ABSTRACT(decl))
			continue
		decl = GET_DECL(decl_type)
		var/list/validation_results = decl.validate()
		if(length(validation_results))
			failures[decl_type] = validation_results

	// Report failures.
	if(length(failures))
		var/fail_msg ="[length(failures)] /decl\s failed validation:"
		for(var/failed_type in failures)
			fail_msg += "\n- [failed_type]\n\t- [jointext(failures[failed_type], "\n\t-")]"
		fail(fail_msg)
	else
		pass("All /decl/s were validated successfully.")
	return TRUE
