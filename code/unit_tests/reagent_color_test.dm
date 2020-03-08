
/datum/unit_test/reagent_colors_test
	name = "REAGENTS: Reagents must have valid colors without alpha in color value"

/datum/unit_test/reagent_colors_test/start_test()
	var/list/bad_reagents = list()

	for(var/T in typesof(/datum/reagent))
		var/datum/reagent/R = T
		if(length(initial(R.color)) != 7)
			bad_reagents += "[T] ([initial(R.color)])"

	if(length(bad_reagents))
		fail("Reagents with invalid colors found: [english_list(bad_reagents)]")
	else
		pass("All reagents have valid colors.")

	return 1

/datum/unit_test/chem_recipes_shall_not_overlap
	name = "REAGENTS: Chem recipes shall not be subsets of other chem recipes for other reagents"

/datum/unit_test/chem_recipes_shall_not_overlap/start_test()
	var/list/bad_recipes = list()

	for(var/path in SSchemistry.chemical_reactions)
		var/datum/chemical_reaction/reaction = SSchemistry.chemical_reactions[path]
		for(var/reagent in reaction.required_reagents)
			for(var/datum/chemical_reaction/other_reaction in SSchemistry.chemical_reactions_by_id[reagent])
				// We check if their requirements to react are a subset of our reaction's requirements, i.e. (we can react) implies (they can react)
				if(other_reaction == reaction)
					continue
				// Are there temperatures when we can react but they can't?
				if(reaction.minimum_temperature < other_reaction.minimum_temperature)
					continue
				if(reaction.maximum_temperature > other_reaction.maximum_temperature)
					continue
				// Do they need a catalyst that we need less of? Similar for inhibitors.
				var/safe = FALSE
				for(var/reagent_path in other_reaction.catalysts)
					if(reaction.catalysts[reagent_path] < other_reaction.catalysts[reagent_path])
						safe = TRUE
						break
				if(safe)
					continue
				for(var/reagent_path in other_reaction.inhibitors)
					if(!reaction.inhibitors[reagent_path] || (reaction.inhibitors[reagent_path] > other_reaction.inhibitors[reagent_path]))
						safe = TRUE
						break
				if(safe)
					continue
				// Slime reactions have extra requirements
				if(istype(other_reaction, /datum/chemical_reaction/slime))
					var/datum/chemical_reaction/slime/other_slime = other_reaction
					if(other_slime.required)
						if(!istype(reaction, /datum/chemical_reaction/slime))
							continue
						var/datum/chemical_reaction/slime/our_slime = reaction
						if(!ispath(our_slime.required, other_slime.required)) // This would mean our requirement is stronger than theirs
							continue

				// Now check for reagents
				for(var/reagent_path in other_reaction.required_reagents)
					if(!reaction.required_reagents[reagent_path])
						safe = TRUE
						break
				if(!safe)
					LAZYADD(bad_recipes[reaction], other_reaction)

	if(length(bad_recipes))
		for(var/recipe in bad_recipes)
			log_bad("[recipe] conflicted with [english_list(bad_recipes[recipe])]")
		fail("At least one reaction had a conflict.")
	else
		pass("No reactions had conflicts.")

	return 1