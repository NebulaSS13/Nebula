/datum/unit_test/decl_uid
	name = "DECLS - Shall Have Unique UID"
	var/list/whitelisted_decls = list(
		/decl/security_state,
		/decl/trait/,
		/decl/special_role
	)

/datum/unit_test/decl_uid/start_test()
	var/list/decls_to_test = typesof(/decl)
	var/list/failures = list()
	for(var/D in decls_to_test)
		if(D in whitelisted_decls)
			skip("decl [D] not checked for UID uniqueness - whitelisted")
			continue
		var/decl/test_decl = GET_DECL(D)
		var/decl/sample_decl = decls_repository.get_decl_by_id(test_decl.uid)
		if(sample_decl != test_decl) //Add both to the failure list because neither of them are unique.
			log_unit_test("UID of [test_decl.type] collided with preexisting entry [sample_decl.type]!")
			failures |= test_decl
			failures |= sample_decl
	if(length(failures))
		fail("[length(failures)] decl UIDs were not unique!")
	else
		pass("All decl UIDs were unique.")
