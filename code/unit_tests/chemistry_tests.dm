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
	from.add_to_reagents(/decl/material/liquid/water, container_volume)

	var/atom/target
	if(ispath(recipient_type, /turf) && istype(test_loc, recipient_type))
		target = test_loc
		if(target.reagents)
			target.reagents.clear_reagents()
	else
		target = new recipient_type(test_loc)
	if(!target.reagents)
		target.create_reagents(container_volume)
	if(ismob(target))
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

	qdel(from)
	if(!isturf(target))
		qdel(target)
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

/datum/unit_test/chem_recipes_shall_not_overlap
	name = "CHEMISTRY: Chem recipes shall not be subsets of other chem recipes for other reagents"

/datum/unit_test/chem_recipes_shall_not_overlap/start_test()
	var/list/bad_recipes = list()
	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)
	for(var/path in all_reactions)
		var/decl/chemical_reaction/reaction = all_reactions[path]
		for(var/reagent in reaction.required_reagents)
			for(var/decl/chemical_reaction/other_reaction in SSmaterials.chemical_reactions_by_id[reagent])
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

/datum/unit_test/chemistry_premade_bottles_shall_not_melt
	name = "CHEMISTRY: Reagent containers shall not be destroyed by their contents"
	// List of master types that can be reasonably expected to spawn with chems inside them.
	var/static/list/master_types = list(
		/obj/item/chems,
		/obj/structure/reagent_dispensers
	)
	// Types to be skipped for reasons other than abstraction/spawnability.
	var/static/list/excepted_types = list(
		// Not technically abstract, but should not be spawned outside of /datum/seed/harvest().
		/obj/item/chems/food/grown,
		/obj/item/chems/food/grown/dry,
		/obj/item/chems/food/grown/grilled
	)

/datum/unit_test/chemistry_premade_bottles_shall_not_melt/start_test()

	// Main test.
	var/list/chem_refs = list()
	var/turf/spawn_spot = get_safe_turf()
	var/list/failures = list()
	for(var/master_type in master_types)
		for(var/chem_type in subtypesof(master_type))
			if(chem_type in excepted_types)
				continue
			var/atom/chem = chem_type
			if(TYPE_IS_ABSTRACT(chem))
				continue
			chem = new chem(spawn_spot)
			if(QDELETED(chem))
				failures += "- [chem.type] qdeleted after Initialize()"
				continue
			chem_refs[chem.type] = weakref(chem)

	// Let SSmaterials process chemical reactions and solvents.
	sleep(SSmaterials.wait * 2)

	// Followup status checking.
	for(var/chem_type in chem_refs)
		var/weakref/chem_ref = chem_refs[chem_type]
		var/atom/chem_instance = istype(chem_ref) && chem_ref.resolve()
		if(QDELETED(chem_instance) || !istype(chem_instance, chem_type) || chem_instance.loc != spawn_spot)
			failures += "- [chem_type] qdeleted after reacting"
		else
			// Cleanup pt. 1
			qdel(chem_instance)

	// Cleanup pt. 2
	chem_refs.Cut()
	if(spawn_spot.reagents?.total_volume)
		spawn_spot.reagents.clear_reagents()
		failures += "- spawn turf had fluids post-test"

	// Report status.
	if(length(failures))
		fail("At least one subtype was qdeleted:\n[jointext(failures, "\n")]")
	else
		pass("No subtypes melted.")
	return 1