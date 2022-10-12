/datum/unit_test/trait
	name = "TRAIT - Template"
	template = /datum/unit_test/trait

/datum/unit_test/trait/New()
	name = "TRAIT: " + name


/datum/unit_test/trait/all_traits_shall_have_valid_names
	name = "All traits shall have valid names"

/datum/unit_test/trait/all_traits_shall_have_valid_names/start_test()
	var/list/invalid_traits = list()
	var/list/all_traits = decls_repository.get_decls_of_type(/decl/trait)
	for(var/trait in all_traits)
		var/decl/trait/T = all_traits[trait]
		if(!T.name || !istext(T.name)) // Empty strings are valid texts
			invalid_traits += T.type

	if(invalid_traits.len)
		fail("Following trait types have invalid names: " + english_list(invalid_traits))
	else
		pass("All traits have valid names")

	return TRUE


/datum/unit_test/trait/all_traits_shall_have_unique_name
	name = "All traits shall have unique names"

/datum/unit_test/trait/all_traits_shall_have_unique_name/start_test()
	var/list/trait_names = list()
	var/list/all_traits = decls_repository.get_decls_of_type(/decl/trait)
	for(var/trait in all_traits)
		var/decl/trait/T = all_traits[trait]
		group_by(trait_names, T.name, T.type)

	var/number_of_issues = number_of_issues(trait_names, "Names")
	if(number_of_issues)
		fail("[number_of_issues] duplicate trait name\s found")
	else
		pass("All traits have unique names")
	return 1


/datum/unit_test/trait/all_traits_shall_have_valid_levels
	name = "All traits shall have valid levels"

/datum/unit_test/trait/all_traits_shall_have_valid_levels/start_test()
	var/list/invalid_traits = list()
	var/list/all_traits = decls_repository.get_decls_of_type(/decl/trait)
	for(var/trait in all_traits)
		var/decl/trait/T = all_traits[trait]
		if(!length(T.levels) || (T.levels.len > 1 && (TRAIT_LEVEL_EXISTS in T.levels)))
			invalid_traits += T.type

	if(invalid_traits.len)
		fail("Following trait types have invalid ranges: " + english_list(invalid_traits))
	else
		pass("All traits have valid ranges")

	return TRUE


/datum/unit_test/trait/all_species_shall_have_valid_trait_levels
	name = "All species shall have valid trait levels"

/datum/unit_test/trait/all_species_shall_have_valid_trait_levels/start_test()
	var/list/invalid_species = list()
	var/species_by_name = get_all_species()
	for(var/species_name in species_by_name)
		var/decl/species/S = species_by_name[species_name]
		for(var/trait_type in S.traits)
			var/trait_level = S.traits[trait_type]
			var/decl/trait/T = GET_DECL(trait_type)
			if(!T.Validate(trait_level))
				invalid_species += S.type
				break

	if(invalid_species.len)
		fail("Following species have invalid ranges: " + english_list(invalid_species))
	else
		pass("All species have valid trait levels")

	return TRUE
