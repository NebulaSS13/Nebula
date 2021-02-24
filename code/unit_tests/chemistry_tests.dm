/datum/unit_test/chemistry
	name = "CHEMISTRY: Reagent Template"
	template = /datum/unit_test/chemistry
	
	var/container_volume = 45
	var/donor_type = /obj/item
	var/recipient_type = /obj/item

/datum/unit_test/chemistry/start_test()

	var/turf/test_loc = get_safe_turf()

	var/atom/from = new donor_type(test_loc)
	from.create_reagents(container_volume)
	from.reagents.add_reagent(/decl/material/liquid/water, container_volume)

	var/atom/target
	if(ispath(recipient_type, /turf) && istype(test_loc, recipient_type))
		target = test_loc
		if(target.reagents)
			target.reagents.clear_reagents()
	else
		target = new recipient_type(test_loc)
	if(!target.reagents)
		target.create_reagents(container_volume)
	if(istype(target, /mob))
		var/mob/victim = target
		victim.death() // to prevent reagent processing

	from.atom_flags   |= ATOM_FLAG_OPEN_CONTAINER
	target.atom_flags |= ATOM_FLAG_OPEN_CONTAINER

	var/error = perform_transfer(from, target)
	if(error)
		fail("Error during transfer: [error]")
	else
		error = validate_transfer(from, target)
		if(error)
			fail("Error after transfer: [error]")
		else
			pass("Final reagent holders had correct values.")
	return TRUE

/datum/unit_test/chemistry/proc/perform_transfer(var/atom/from, var/atom/target)
	return validate_holders(from, target)

/datum/unit_test/chemistry/proc/get_first_reagent_holder(var/atom/from)
	. = from.reagents

/datum/unit_test/chemistry/proc/get_second_reagent_holder(var/atom/from)
	. = from.reagents

/datum/unit_test/chemistry/proc/validate_transfer(var/atom/from, var/atom/target)
	. = validate_holders(from, target)
	if(!.)
		var/to_holding_target = container_volume * 0.5
		var/from_remaining_target = container_volume - to_holding_target
		var/datum/reagents/checking = get_first_reagent_holder(from)
		if(!checking)
			return "first holder is null."
		if(checking?.total_volume != from_remaining_target)
			return "first holder should have [from_remaining_target]u remaining but has [checking.total_volume]u."
		checking = get_second_reagent_holder(target)
		if(!checking)
			return "second holder is null."
		if(checking?.total_volume != to_holding_target)
			return "second holder should hold [to_holding_target]u but has [checking.total_volume]u."

/datum/unit_test/chemistry/proc/validate_holders(var/atom/from, var/atom/target)
	if(QDELETED(from))
		return "null or qdeleted first holder"
	if(!istype(from, donor_type))
		return "invalid type for first holder"
	if(!from.reagents)
		return "no reagents datum created for first holder"
	if(QDELETED(target))
		return "null or qdeleted second holder"
	if(!istype(target, recipient_type))
		return "invalid type for second holder"
	if(!target.reagents)
		return "no reagents datum created for second holder"

/datum/unit_test/chemistry/test_trans_to
	name = "CHEMISTRY: trans_to() Test (obj)"

/datum/unit_test/chemistry/test_trans_to/perform_transfer(var/atom/from, var/atom/target)
	. = ..()
	if(!.)
		from.reagents.trans_to(target, container_volume * 0.5)

/datum/unit_test/chemistry/test_trans_to/to_mob
	name = "CHEMISTRY: trans_to() Test (mob)"
	recipient_type = /mob/living

/datum/unit_test/chemistry/test_trans_to/to_mob/get_second_reagent_holder(var/atom/from)
	var/mob/living/testmob = from
	. = testmob.get_contact_reagents()

/datum/unit_test/chemistry/test_trans_to_holder
	name = "CHEMISTRY: trans_to_holder() Test"

/datum/unit_test/chemistry/test_trans_to_holder/perform_transfer(var/atom/from, var/atom/target)
	. = ..()
	if(!.)
		from.reagents.trans_to_holder(target.reagents, container_volume * 0.5)

/datum/unit_test/chemistry/test_trans_to_obj
	name = "CHEMISTRY: trans_to_obj() Test"

/datum/unit_test/chemistry/test_trans_to_obj/perform_transfer(var/atom/from, var/atom/target)
	. = ..()
	if(!.)
		from.reagents.trans_to_obj(target, container_volume * 0.5)

/datum/unit_test/chemistry/test_trans_to_mob
	name = "CHEMISTRY: trans_to_mob() Test"
	recipient_type = /mob/living

/datum/unit_test/chemistry/test_trans_to_mob/perform_transfer(var/atom/from, var/atom/target)
	. = ..()
	if(!.)
		from.reagents.trans_to_mob(target, container_volume * 0.5)

/datum/unit_test/reagent_colors_test
	name = "CHEMISTRY: Reagents must have valid colors without alpha in color value"

/datum/unit_test/reagent_colors_test/start_test()
	var/list/bad_reagents = list()

	for(var/T in typesof(/decl/material))
		var/decl/material/R = T
		if(length(initial(R.color)) != 7)
			bad_reagents += "[T] ([initial(R.color)])"

	if(length(bad_reagents))
		fail("Reagents with invalid colors found: [english_list(bad_reagents)]")
	else
		pass("All reagents have valid colors.")

	return 1

/datum/unit_test/chem_recipes_shall_not_overlap
	name = "CHEMISTRY: Chem recipes shall not be subsets of other chem recipes for other reagents"

/datum/unit_test/chem_recipes_shall_not_overlap/start_test()
	var/list/bad_recipes = list()

	for(var/path in SSmaterials.chemical_reactions)
		var/datum/chemical_reaction/reaction = SSmaterials.chemical_reactions[path]
		for(var/reagent in reaction.required_reagents)
			for(var/datum/chemical_reaction/other_reaction in SSmaterials.chemical_reactions_by_id[reagent])
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