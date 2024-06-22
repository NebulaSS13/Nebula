/datum/unit_test/traits_shall_not_have_circular_references
	name = "TRAITS: Traits Shall Not Have Circular References"

/datum/unit_test/traits_shall_not_have_circular_references/start_test()

	var/list/failures = list()
	var/list/all_traits = decls_repository.get_decls_of_type(/decl/trait)
	for(var/atype in all_traits)

		var/list/seen_traits = list()
		var/list/checking_traits = list(all_traits[atype])
		while(checking_traits.len)
			var/decl/trait/trait = checking_traits[1]
			checking_traits -= trait
			if(trait in seen_traits)
				failures += "[atype] - [trait.type]"
				break
			else
				seen_traits += trait
				if(trait.children)
					checking_traits |= trait.children

	if(length(failures))
		fail("Found [length(failures)] circular reference\s:\n[jointext(failures, "\n")]")
	else
		pass("trait tree has no circular references.")
	return 1
