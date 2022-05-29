// ==============================================================================

/datum/unit_test/max_damage_setup
	name = "ORGAN: Max Damage Is Setup"

/datum/unit_test/max_damage_setup/start_test()
	var/list/skipped_organ_types = list(/obj/item/organ/external, /obj/item/organ/internal)

	var/list/failed_organ_types = list()
	for(var/organ_type in (subtypesof(/obj/item/organ) - skipped_organ_types))
		var/obj/item/organ/O = organ_type
		if(!initial(O.max_damage))
			failed_organ_types += O

	if(failed_organ_types.len)
		fail("The following organs have incorrectly setup max damage: [english_list(failed_organ_types)]")
	else
		pass("All organs have a correctly setup max damage")

	return 1

/datum/unit_test/species_organ_creation
	name = "ORGAN: Species Organs are Created Correctly"

/datum/unit_test/species_organ_creation/proc/check_internal_organs(var/mob/living/carbon/human/H, var/decl/species/species)
	. = 1
	for(var/organ_tag in species.has_organ)
		var/obj/item/organ/internal/I = H.get_organ(organ_tag)
		if(!istype(I))
			fail("[species.name] failed to register internal organ for tag \"[organ_tag]\" to internal_organs_by_name.")
			. = 0
			continue
		if(!(I in H.get_internal_organs()))
			fail("[species.name] failed to register internal organ for tag \"[organ_tag]\" to internal_organs.")
			. = 0
			continue
		var/req_type = species.has_organ[organ_tag]
		if(!istype(I, req_type))
			fail("[species.name] incorrect type of internal organ created for tag \"[organ_tag]\". Expected [req_type], found [I.type].")
			. = 0
			continue
		if(I.organ_tag != organ_tag)
			fail("[species.name] internal organ tag mismatch. Registered as \"[organ_tag]\", actual tag was \"[I.organ_tag]\".")
			. = 0
		if(!isnum(I.absolute_max_damage) || I.absolute_max_damage <= 0)
			fail("[species.name] internal organ has invalid absolute_max_damage value ([I.absolute_max_damage]).")
			. = 0

/datum/unit_test/species_organ_creation/proc/check_external_organs(var/mob/living/carbon/human/H, var/decl/species/species)
	. = 1
	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/E = H.get_organ(organ_tag)
		if(!istype(E))
			fail("[species.name] failed to register external organ for tag \"[organ_tag]\" to organs_by_name.")
			. = 0
			continue
		if(!(E in H.get_external_organs()))
			fail("[species.name] failed to register external organ for tag \"[organ_tag]\" to organs.")
			. = 0
			continue
		var/list/organ_data = species.has_limbs[organ_tag]
		var/req_type = organ_data["path"]
		if(!istype(E, req_type))
			fail("[species.name] incorrect type of external organ created for tag \"[organ_tag]\". Expected [req_type], found [E.type].")
			. = 0
			continue
		if(E.organ_tag != organ_tag)
			fail("[species.name] external organ tag mismatch. Registered as \"[organ_tag]\", actual tag was \"[E.organ_tag]\".")
			. = 0
		if(!isnum(E.absolute_max_damage) || E.absolute_max_damage <= 0)
			fail("[species.name] external organ has invalid absolute_max_damage value ([E.absolute_max_damage]).")
			. = 0

/datum/unit_test/species_organ_creation/proc/check_organ_parents(var/mob/living/carbon/human/H, var/decl/species/species)
	. = 1
	var/list/external_organs = H.get_external_organs()
	for(var/obj/item/organ/external/E in external_organs)
		if(!E.parent_organ)
			continue
		var/obj/item/organ/external/parent = H.get_organ(E.parent_organ)
		if(!istype(parent))
			fail("[species.name] external organ [E] could not find its parent in organs_by_name. Parent tag was \"[E.parent_organ]\".")
			. = 0
			continue
		if(!(parent in external_organs))
			fail("[species.name] external organ [E] could not find its parent in organs. Parent was [parent](parent.type). Parent tag was \"[E.parent_organ]\".")
			. = 0
			continue
		if(E.parent != parent)
			fail("[species.name] external organ [E] parent mismatch. Parent reference was [E.parent] with tag \"[E.parent? E.parent.organ_tag : "N/A"]\". Parent was [parent](parent.type). Parent tag was \"[E.parent_organ]\".")
			. = 0
			continue
		if(!(E in parent.children))
			fail("[species.name] external organ [E] was not found in parent's children. Parent was [parent]. Parent tag was \"[E.parent_organ]\".")
			. = 0
			continue

	for(var/obj/item/organ/internal/I in H.get_internal_organs())
		if(!I.parent_organ)
			fail("[species.name] internal organ [I] did not have a parent_organ tag.")
			. = 0
			continue
		var/obj/item/organ/external/parent = H.get_organ(I.parent_organ)
		if(!istype(parent))
			fail("[species.name] internal organ [I] could not find its parent in organs_by_name. Parent tag was \"[I.parent_organ]\".")
			. = 0
			continue
		if(!(parent in external_organs))
			fail("[species.name] internal organ [I] could not find its parent in organs. Parent was [parent]. Parent tag was \"[I.parent_organ]\".")
			. = 0
			continue
		if(!(I in parent.internal_organs))
			fail("[species.name] internal organ [I] was not found in parent's internal_organs. Parent was [parent]. Parent tag was \"[I.parent_organ]\".")
			. = 0
			continue

/datum/unit_test/species_organ_creation/start_test()
	var/failcount = 0
	for(var/decl/species/species in get_all_species())
		var/mob/living/carbon/human/test_subject = new(null, species.name)

		var/fail = 0
		fail |= !check_internal_organs(test_subject, species)
		fail |= !check_external_organs(test_subject, species)
		fail |= !check_organ_parents(test_subject, species)

		if(fail) failcount++

	if(failcount)
		fail("[failcount] species mobs were created with invalid organ configuration.")
	else
		pass("All species mobs were created with valid organ configuration.")

	return 1

/datum/unit_test/species_organ_lists_update
	name = "ORGAN: Species Mob Organ Lists Update when Organs are Removed and Replaced."

/datum/unit_test/species_organ_lists_update/proc/check_internal_organ_present(var/mob/living/carbon/human/H, var/obj/item/organ/internal/I)
	if(!(I in H.get_internal_organs()))
		fail("[H.species.name] internal organ [I] not in internal_organs.")
		return 0
	var/found = H.get_organ(I.organ_tag)
	if(I != found)
		fail("[H.species.name] internal organ [I] not in internal_organs_by_name. Organ tag was \"[I.organ_tag]\", found [found? found : "nothing"] instead.")
		return 0
	var/obj/item/organ/external/parent = H.get_organ(I.parent_organ)
	if(!istype(parent))
		fail("[H.species.name] internal organ [I] could not find its parent in organs_by_name. Parent tag was \"[I.parent_organ]\".")
		return 0
	if(!(I in parent.internal_organs))
		fail("[H.species.name] internal organ [I] was not in parent's internal_organs. Parent was [parent]. Parent tag was \"[I.parent_organ]\".")
		return 0
	return 1

/datum/unit_test/species_organ_lists_update/proc/check_internal_organ_removed(var/mob/living/carbon/human/H, var/obj/item/organ/internal/I, var/obj/item/organ/external/old_parent)
	if(I in H.get_internal_organs())
		fail("[H.species.name] internal organ [I] was not removed from internal_organs.")
		return 0
	var/found = H.get_organ(I.organ_tag)
	if(found)
		fail("[H.species.name] internal organ [I] was not removed from internal_organs_by_name. Organ tag was \"[I.organ_tag]\".")
		return 0
	if(I in old_parent.internal_organs)
		fail("[H.species.name] internal organ [I] was not removed from parent's internal_organs. Parent was [old_parent].")
		return 0
	return 1

/datum/unit_test/species_organ_lists_update/proc/check_external_organ_present(var/mob/living/carbon/human/H, var/obj/item/organ/external/E)
	if(!(E in H.get_external_organs()))
		fail("[H.species.name] external organ [E] not in organs.")
		return 0
	var/found = H.get_organ(E.organ_tag)
	if(E != found)
		fail("[H.species.name] external organ [E] not in organs_by_name. Organ tag was \"[E.organ_tag]\", found [found? found : "nothing"] instead.")
		return 0
	if(E.parent_organ)
		var/obj/item/organ/external/parent = E.parent
		if(!istype(parent))
			fail("[H.species.name] external organ [E] had no parent. Parent tag was \"[E.parent_organ]\".")
			return 0
		if(parent.organ_tag != E.parent_organ)
			fail("[H.species.name] external organ [E] parent tag mismatch. Parent tag was \"[E.parent_organ]\", actual tag was \"[parent.organ_tag]\".")
			return 0
		if(!(E in parent.children))
			fail("[H.species.name] external organ [E] was not in parent's children. Parent was [parent]. Parent tag was \"[E.parent_organ]\".")
			return 0
	return 1

/datum/unit_test/species_organ_lists_update/proc/check_external_organ_removed(var/mob/living/carbon/human/H, var/obj/item/organ/external/E, var/obj/item/organ/external/old_parent = null)
	if(E in H.get_external_organs())
		fail("[H.species.name] external organ [E] was not removed from organs.")
		return 0
	var/found = H.get_organ(E.organ_tag)
	if(found)
		fail("[H.species.name] external organ [E] was not removed from organs_by_name. Organ tag was \"[E.organ_tag]\".")
		return 0
	if(old_parent)
		if(!(E in old_parent.children))
			fail("[H.species.name] external organ [E] was not removed from parent's children. Parent was [old_parent].")
			return 0
	return 1

/datum/unit_test/species_organ_lists_update/proc/test_internal_organ(var/mob/living/carbon/human/H, var/obj/item/organ/internal/I)
	if(!check_internal_organ_present(H, I))
		fail("[H.species.name] internal organ [I] failed initial presence check.")
		return 0

	var/obj/item/organ/external/parent = H.get_organ(I.parent_organ)

	H.remove_organ(I)
	if(!check_internal_organ_removed(H, I, parent))
		fail("[H.species.name] internal organ [I] was not removed correctly.")
		return 0

	H.add_organ(I, parent)
	if(!check_internal_organ_present(H, I))
		fail("[H.species.name] internal organ [I] was not replaced correctly.")
		return 0

	return 1

/datum/unit_test/species_organ_lists_update/proc/test_external_organ(var/mob/living/carbon/human/H, var/obj/item/organ/external/E)
	if(!check_external_organ_removed(H, E))
		fail("[H.species.name] internal organ [E] failed initial presence check.")
		return 0

	var/obj/item/organ/external/parent = E.parent

	H.remove_organ(E)
	if(!check_internal_organ_removed(H, E, parent))
		fail("[H.species.name] internal organ [E] was not removed correctly.")
		return 0

	H.add_organ(E)
	if(!check_internal_organ_present(H, E))
		fail("[H.species.name] internal organ [E] was not replaced correctly.")
		return 0

	return 1

/datum/unit_test/species_organ_lists_update/start_test()
	var/failcount = 0
	for(var/decl/species/species in get_all_species())
		var/mob/living/carbon/human/test_subject = new(null, species.name)

		for(var/O in test_subject.get_internal_organs())
			if(!test_internal_organ(test_subject, O))
				failcount++

		for(var/O in test_subject.get_external_organs())
			if(!test_external_organ(test_subject, O))
				failcount++

	if(failcount)
		fail("[failcount] organs failed to be removed and replaced correctly.")
	else
		pass("All organs were removed and replaced correctly.")

	return 1

// ==============================================================================
// Stumps shall not drop
// ==============================================================================
/datum/unit_test/stumps_shall_not_drop
	name = "ORGAN: Stumps Shall Not Drop From a Gibbed Mob or Severed Limbs."

/datum/unit_test/stumps_shall_not_drop/proc/find_stumps()
	var/list/found_stumps
	//Look for stumps that aren't deleted
	for(var/obj/item/organ/external/stump/O in world)
		if(!QDELETED(O))
			LAZYDISTINCTADD(found_stumps, O)
	return found_stumps

/datum/unit_test/stumps_shall_not_drop/proc/fill_limb_with_stumps(var/obj/item/organ/external/E)
	for(var/obj/item/organ/external/C in E.children)
		//Gib child limbs to create stumps on our target organ
		if(C.limb_flags & ORGAN_FLAG_CAN_AMPUTATE)
			C.dismember(FALSE, DISMEMBER_METHOD_BLUNT, FALSE, TRUE)

/datum/unit_test/stumps_shall_not_drop/proc/do_cleanup(var/mob/living/carbon/human/H)
	if(H && !QDELETED(H))
		qdel(H)
	for(var/obj/item/organ/O in (locate(/obj/item/organ) in world))
		qdel(O)

//Check whether using the proper tool on a removed limb to extract the contents drops any stumps
/datum/unit_test/stumps_shall_not_drop/proc/test_removed_limb_dropping_stumps_on_interact(var/mob/living/carbon/human/H, var/mob/living/carbon/human/tester, var/list/details)
	. = TRUE
	details.Cut()

	var/list/limbs_to_test
	for(var/obj/item/organ/external/O in H.get_external_organs())
		if(isnull(O.parent_organ) || !LAZYLEN(O.children) || !(O.limb_flags & ORGAN_FLAG_CAN_AMPUTATE))
			continue //We don't want the root limb since it won't gib, or limbs with no child
		fill_limb_with_stumps(O)
		//Amputate the limb via edge damage so it doesn't get gibbed
		O.dismember(FALSE, DISMEMBER_METHOD_EDGE, FALSE, TRUE)
		LAZYDISTINCTADD(limbs_to_test, O)

	//Test every single limbs we removed
	var/obj/item/scalpel/tool = tester.get_active_hand() 
	for(var/obj/item/organ/external/E in limbs_to_test)
		//Skip to the actual part where we remove things
		E.stage = 2

		//Poke it enough times to remove everything inside at least once
		for(var/i = 0, i < LAZYLEN(E.contents), i++)
			E.attackby(tool, tester)

		//Look for any dropped stumps
		var/list/found_stumps = find_stumps()
		if(LAZYLEN(found_stumps))
			details[E.organ_tag] = "Found [LAZYLEN(found_stumps)] stumps after extracting from removed limb type '[E.type]'!"
			. = FALSE

	//Cleanup
	do_cleanup(H)

//Gib a limb with stumps inside and see if the stumps were dropped
/datum/unit_test/stumps_shall_not_drop/proc/test_gibbing_limbs(var/mob/living/carbon/human/H, var/list/details)
	. = TRUE
	details.Cut()

	//Gib limbs that have child stumps
	for(var/obj/item/organ/external/O in H.get_external_organs())
		if(isnull(O.parent_organ) || !LAZYLEN(O.children) || !(O.limb_flags & ORGAN_FLAG_CAN_AMPUTATE))
			continue //We don't want the root limb since it won't gib, or limbs with no child
		fill_limb_with_stumps(O)
		//Then gib the part we just placed stumps on
		O.dismember(FALSE, DISMEMBER_METHOD_BLUNT, FALSE, TRUE)

		//Look for any dropped stumps
		var/list/found_stumps = find_stumps()
		if(LAZYLEN(found_stumps))
			. = FALSE
			details[O.organ_tag] = "Found [LAZYLEN(found_stumps)] stumps after gibbing limb type '[O.type]' with child stumps!"

	//Cleanup
	do_cleanup(H)

//Gibs a mob with stumps inside and see if any were dropped
/datum/unit_test/stumps_shall_not_drop/proc/test_gibbing(var/mob/living/carbon/human/H, var/list/details)
	. = TRUE
	details.Cut()

	//Remove all limbs via dismember to create stumps
	for(var/obj/item/organ/external/O in H.get_external_organs())
		if(isnull(O.parent_organ) || !(O.limb_flags & ORGAN_FLAG_CAN_AMPUTATE))
			continue //We don't want the root limb since it won't gib
		O.dismember(FALSE, DISMEMBER_METHOD_BLUNT, FALSE, TRUE)
	
	//Then gib the mob, so it releases its contents
	if(!QDELETED(H))
		H.gib()
	
	//Look for any dropped stumps
	var/list/found_stumps = find_stumps()
	if(LAZYLEN(found_stumps))
		details["msg"] = "Found [LAZYLEN(found_stumps)] stumps after amputating all limbs, and gibbing human of species '[H.species?.name]'!"
		. = FALSE
	
	//Cleanup
	do_cleanup(H)

/datum/unit_test/stumps_shall_not_drop/start_test()
	var/list/details = list()

	//Equip our tester
	var/mob/living/carbon/human/dummy/tester = new(null, SPECIES_HUMAN)
	var/obj/item/scalpel/tool = new/obj/item/scalpel(tester)
	tester.put_in_active_hand(tool)

	//Run the tests
	for(var/decl/species/species in get_all_species())

		if(!test_gibbing(new/mob/living/carbon/human(null, species.name), details))
			var/failtext = ""
			for(var/k in details)
				failtext = "[failtext]\n[k]: [details[k]]"
			fail(failtext)

		if(!test_gibbing_limbs(new/mob/living/carbon/human(null, species.name), details))
			var/failtext = ""
			for(var/k in details)
				failtext = "[failtext]\n[k]: [details[k]]"
			fail(failtext)

		if(!test_removed_limb_dropping_stumps_on_interact(new/mob/living/carbon/human(null, species.name), tester, details))
			var/failtext = ""
			for(var/k in details)
				failtext = "[failtext]\n[k]: [details[k]]"
			fail(failtext)

	pass("All stumps tested were not dropped!")
	return TRUE
