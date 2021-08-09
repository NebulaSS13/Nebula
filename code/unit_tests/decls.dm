/datum/unit_test/currency_validation
	name = "DECL: UIDs shall be unique and valid"
	var/static/list/mandatory_uid_types = list(
		/decl/material
	)

/datum/unit_test/currency_validation/start_test()

	var/list/failures = list()

	// Check text uid values for mandatory types
	for(var/mandatory_type in mandatory_uid_types)
		for(var/decl_type in typesof(mandatory_type))
			var/decl/decl = decl_type
			var/decl_uid = initial(decl.uid)
			if(!istext(decl_uid) && initial(decl.abstract_type) != decl_type)
				failures += "[decl_type] - non-text UID '[decl_uid || "NULL"]' on mandatory type"

	// Check uid uniqueness.
	var/list/seen_uids = list()
	for(var/decl_type in typesof(/decl))
		var/decl/decl = decl_type
		if(initial(decl.abstract_type) == decl_type)
			continue
		var/decl_uid = initial(decl.uid)
		if(decl_uid && seen_uids[decl_uid])
			failures += "[decl_type] - non-unique UID '[decl_uid || "NULL"]' (first seen on [seen_uids[decl_uid]])"
		else
			seen_uids[decl_uid] = decl_type

	// Report failures.
	if(length(failures))
		fail("[length(failures)] /decl\s failed UID validation:\n[jointext(failures, "\n")]")
	else
		pass("All /decl UIDs were validated successfully.")
	return 1