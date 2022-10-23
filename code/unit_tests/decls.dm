/datum/unit_test/decl_validation
	name = "DECL: UIDs shall be unique and valid"
	var/static/list/mandatory_uid_types = list(
		/decl/material
	)

/datum/unit_test/decl_validation/start_test()

	var/list/failures = list()

	// Check text uid values for mandatory types
	for(var/mandatory_type in mandatory_uid_types)
		for(var/decl_type in typesof(mandatory_type))
			var/decl/decl = decl_type
			if(TYPE_IS_ABSTRACT(decl))
				continue
			decl = GET_DECL(decl_type)
			if(!istext(decl.uid))
				failures += "[decl_type] - non-text UID '[decl.uid || "NULL"]' on mandatory type"

	// Check uid uniqueness.
	var/list/seen_uids = list()
	for(var/decl_type in typesof(/decl))
		var/decl/decl = decl_type
		if(TYPE_IS_ABSTRACT(decl))
			continue
		decl = GET_DECL(decl_type)
		if(isnull(decl.uid))
			continue
		if(!istext(decl.uid))
			failures += "[decl_type] - non-null non-text UID '[decl.uid]'"
		else if(seen_uids[decl.uid])
			failures += "[decl_type] - non-unique UID '[decl.uid || "NULL"]' (first seen on [seen_uids[decl.uid]])"
		else
			seen_uids[decl.uid] = decl_type

	// Report failures.
	if(length(failures))
		fail("[length(failures)] /decl\s failed UID validation:\n[jointext(failures, "\n")]")
	else
		pass("All /decl UIDs were validated successfully.")
	return 1
