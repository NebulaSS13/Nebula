/**
 *  Each slice origin items should cut into the same slice.
 *
 *  Each slice type defines an item from which it originates. Each sliceable
 *  item defines what item it cuts into. This test checks if the two defnitions
 *  are consistent between the two items.
 */
/datum/unit_test/food_slices_and_origin_items_should_be_consistent
	name = "FOOD: Each slice origin item should cut into the appropriate slice"

/datum/unit_test/food_slices_and_origin_items_should_be_consistent/start_test()
	var/any_failed = FALSE

	for (var/subtype in subtypesof(/obj/item/chems/food/snacks/slice))
		var/obj/item/chems/food/snacks/slice/slice = subtype
		if(!initial(slice.whole_path))
			log_bad("[slice] does not define a whole_path.")
			any_failed = TRUE
			continue

		if(!ispath(initial(slice.whole_path), /obj/item/chems/food/snacks/sliceable))
			log_bad("[slice]/whole_path is not a subtype of sliceable.")
			any_failed = TRUE
			continue

		var/obj/item/chems/food/snacks/sliceable/whole = initial(slice.whole_path)

		// note that the slice can be a subtype of the one defined in slice_path
		if(!ispath(slice, initial(whole.slice_path)))
			log_bad("[whole] does not define slice_path as [slice].")
			any_failed = TRUE
			continue

	if(any_failed)
		fail("Some slice types were incorrectly defined.")
	else
		pass("All slice types defined correctly.")

	return 1

/datum/unit_test/atoms_should_use_valid_json
	name = "ATOMS: Atoms using JSON should have valid JSON values"

/datum/unit_test/atoms_should_use_valid_json/start_test()
	// Tried doing this with a list, but accessing initial vars is noodly 
	// without an object instance so I'm being slack and hardcoding it.
	var/list/failures
	var/list/json_to_check

	for(var/subtype in typesof(/obj))
		var/obj/test = subtype
		var/check_json = initial(test.buckle_pixel_shift)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].buckle_pixel_shift", check_json)
	for(var/subtype in typesof(/obj/item))
		var/obj/item/test = subtype
		var/check_json = initial(test.center_of_mass)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].center_of_mass", check_json)
	for(var/subtype in typesof(/obj/item/chems))
		var/obj/item/chems/test = subtype
		var/check_json = initial(test.possible_transfer_amounts)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].possible_transfer_amounts", check_json)
	for(var/subtype in typesof(/obj/item/chems/food/drinks))
		var/obj/item/chems/food/drinks/test = subtype
		var/check_json = initial(test.filling_states)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].filling_states", check_json)
	for(var/subtype in typesof(/obj/item/chems/food/drinks/glass2))
		var/obj/item/chems/food/drinks/glass2/test = subtype
		var/check_json = initial(test.rim_pos)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].rim_pos", check_json)
	for(var/subtype in typesof(/obj/structure/reagent_dispensers))
		var/obj/structure/reagent_dispensers/test = subtype
		var/check_json = initial(test.possible_transfer_amounts)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].possible_transfer_amounts", check_json)
	// Validate JSON.
	for(var/check_key in json_to_check)
		try
			to_chat(null, cached_json_decode(json_to_check[check_key])) // to_chat() so compiler doesn't complain about useless line
		catch()
			LAZYADD(failures, check_key)
	if(LAZYLEN(failures))
		fail("Some atoms had invalid JSON defined: [english_list(failures)].")
	else
		pass("All atoms expecting JSON values have valid JSON.")

	return 1

