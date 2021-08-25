/datum/unit_test/aspects_shall_have_unique_names
	name = "ASPECTS: All Aspects Shall Have Unique Names"

/datum/unit_test/aspects_shall_have_unique_names/start_test()

	var/list/seen_names = list()
	var/list/failures = list()
	var/list/all_aspects = decls_repository.get_decls_of_subtype(/decl/aspect)

	for(var/atype in all_aspects)
		var/decl/aspect/aspect = all_aspects[atype]
		var/check_name = lowertext(aspect.name)
		if(check_name)
			if(check_name in seen_names)
				failures += "[aspect.type] - [aspect.name]"
			else
				seen_names |= check_name

	if(length(failures))
		fail("Found [length(failures)] aspect\s with duplicate names:\n[jointext(failures, "\n")]")
	else
		pass("All aspects have unique names.")
	return 1

/datum/unit_test/aspects_shall_have_valid_parents_and_children
	name = "ASPECTS: All Aspects Shall Have Valid Parents And Children"

/datum/unit_test/aspects_shall_have_valid_parents_and_children/start_test()
	var/list/failures = list()
	var/list/all_aspects = decls_repository.get_decls_of_subtype(/decl/aspect)
	for(var/atype in all_aspects)
		var/decl/aspect/aspect = all_aspects[atype]
		if(initial(aspect.parent) && !istype(aspect.parent))
			failures += "[atype] - invalid parent - [aspect.parent || "NULL"]"
		for(var/decl/aspect/A AS_ANYTHING in aspect.children)
			if(!istype(A))
				failures += "[atype] - invalid child - [A || "NULL"]"
			else if(A.parent != aspect)
				failures += "[atype] - child does not have correct parent - [A || "NULL"], [A.parent || "NULL"]"
	if(length(failures))
		fail("Found [length(failures)] aspect\s with invalid parents or children:\n[jointext(failures, "\n")]")
	else
		pass("All aspects have valid parents and children.")
	return 1

/datum/unit_test/aspects_shall_not_have_circular_references
	name = "ASPECTS: Aspects Shall Not Have Circular References"

/datum/unit_test/aspects_shall_not_have_circular_references/start_test()

	var/list/failures = list()
	var/list/all_aspects = decls_repository.get_decls_of_subtype(/decl/aspect)
	for(var/atype in all_aspects)

		var/list/seen_aspects = list()
		var/list/checking_aspects = list(all_aspects[atype])
		while(checking_aspects.len)
			var/decl/aspect/aspect = checking_aspects[1]
			checking_aspects -= aspect
			if(aspect in seen_aspects)
				failures += "[atype] - [aspect.type]"
				break
			else
				seen_aspects += aspect
				if(aspect.children)
					checking_aspects |= aspect.children

	if(length(failures))
		fail("Found [length(failures)] circular reference\s:\n[jointext(failures, "\n")]")
	else
		pass("Aspect tree has no circular references.")
	return 1
