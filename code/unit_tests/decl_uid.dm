/datum/unit_test/decl_uid
	name = "DECLS - Shall Have Unique UID"

/datum/unit_test/decl_uid/start_test()
	var/list/decls_to_test = decls_repository.get_decls_of_subtype(/decl)
	var/list/failures = list()
	for(var/D in decls_to_test)
		var/decl/test_decl = decls_to_test[D]
		var/decl/sample_decl = decls_repository.get_decl_by_id(test_decl.uid)
		if(sample_decl != test_decl) //Add both to the failure list because neither of them are unique.
			log_unit_test("[test_decl.type] UID returned non-same type [sample_decl.type]")
			failures |= test_decl
			failures |= sample_decl
	if(length(failures))
		fail("[length(failures)] decl UIDs were not unique!")
	else
		pass("All decl UIDs were unique.")
