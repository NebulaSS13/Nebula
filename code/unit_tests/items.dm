/datum/unit_test/items_test
	name = "ITEMS: Items Shall Pass Test Battery"
	var/list/obj_test_instances = list()
	var/list/failures = list()

/datum/unit_test/items_test/start_test()
	// Instantiate all spawnable items
	for(var/path in subtypesof(/obj/item))
		try
			var/obj/item/I = path
			if(!TYPE_IS_SPAWNABLE(I))
				continue
			I = new path
			if(QDELETED(I))
				continue
			obj_test_instances[path] = I
		catch(var/exception/e)
			failures += "Runtime during creation of [path]: [e]"

	// Create tests
	var/list/constant_tests = list()
	for(var/test_path in subtypesof(/datum/item_unit_test/constant))
		constant_tests += new test_path(src)
	var/list/volatile_tests = list()
	for(var/test_path in subtypesof(/datum/item_unit_test/volatile))
		volatile_tests += new test_path(src)

	// Run tests on each object.
	for(var/objpath in obj_test_instances)
		//Run constant tests first
		for(var/datum/item_unit_test/T in constant_tests)
			if(!T.run_test(obj_test_instances[objpath]))
				failures += "Failed constant test: [objpath], [T.type]"
		//Run volatile tests second
		for(var/datum/item_unit_test/T in volatile_tests)
			if(!T.run_test(obj_test_instances[objpath]))
				failures += "Failed volatile test: [objpath], [T.type]"

	if(length(failures))
		fail("[length(failures)] issue\s with item [length(failures) > 1? "were" : "was"] found:\n[jointext(failures, "\n")]")
	else
		pass("All items passed the tests.")

	//Clean up
	QDEL_LIST_ASSOC_VAL(obj_test_instances)
	return TRUE

/////////////////////////////////////////////////////////
// Item Unit Test
/////////////////////////////////////////////////////////
/datum/item_unit_test
	var/datum/unit_test/items_test/IT

/datum/item_unit_test/New(var/datum/unit_test/items_test/_IT)
	. = ..()
	IT = _IT

/datum/item_unit_test/proc/run_test(var/obj/item/I)
	return !QDELETED(I)

//Checks that don't modify the objects
/datum/item_unit_test/constant

//Checks that modify the objects
/datum/item_unit_test/volatile