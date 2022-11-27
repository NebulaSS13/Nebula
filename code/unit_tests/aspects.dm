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
