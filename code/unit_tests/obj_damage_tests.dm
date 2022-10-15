/////////////////////////////////////////////////////////
// Items Test
/////////////////////////////////////////////////////////

//
// Item tests
//
/datum/unit_test/items_test
	name = "Items Test"
	var/list/obj_test_instances = list()
	var/list/failures = list()

/datum/unit_test/items_test/start_test()
	//Instantiate all items
	for(var/path in subtypesof(/obj/item))
		if(!TYPE_IS_SPAWNABLE(path))
			continue
		var/obj/item/I = new path
		if(QDELETED(I))
			log_warning("Item type '[path]' got destroyed during test init.")
		else
			obj_test_instances[path] = I

	//Create tests
	var/list/constant_tests = list()
	var/list/volatile_tests = list()
	for(var/test_path in subtypesof(/datum/item_unit_test/constant))
		constant_tests += new test_path(src)
	for(var/test_path in subtypesof(/datum/item_unit_test/volatile))
		volatile_tests += new test_path(src)

	//Run tests on each objects
	for(var/objpath in obj_test_instances)
		//Run constant tests first
		for(var/datum/item_unit_test/T in constant_tests)
			T.run_test(obj_test_instances[objpath])
		//Run volatile tests second
		for(var/datum/item_unit_test/T in volatile_tests)
			T.run_test(obj_test_instances[objpath])

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
	return FALSE

//Checks that don't modify the objects
/datum/item_unit_test/constant

//Checks that modify the objects
/datum/item_unit_test/volatile

/////////////////////////////////////////////////////////
// items_shall_stay_invincible
/////////////////////////////////////////////////////////
/datum/item_unit_test/constant/items_shall_stay_invincible/run_test(var/obj/item/I)
	if(initial(I.health) != ITEM_HEALTH_NO_DAMAGE && initial(I.max_health) != ITEM_HEALTH_NO_DAMAGE)
		return TRUE //Ignore things that aren't invincible
	if(I.health != ITEM_HEALTH_NO_DAMAGE || I.max_health != ITEM_HEALTH_NO_DAMAGE)
		IT.failures += "Item type '[I.type]' is defined as not taking health damage, but it can take damage after init."
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////
// items_shall_define_their_max_health
/////////////////////////////////////////////////////////
/datum/item_unit_test/constant/items_shall_define_their_max_health/run_test(var/obj/item/I)
	if(I.health == ITEM_HEALTH_NO_DAMAGE || I.max_health == ITEM_HEALTH_NO_DAMAGE)
		return TRUE //We don't care about invincible things
	if(I.health > 0 && I.max_health != I.health)
		IT.failures += "Item type '[I.type]' defines health = [I.health], but its max_health is [I.max_health? I.max_health : "null"]."
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////
// items_shall_set_health_var_only_if_null
/////////////////////////////////////////////////////////
/**Items should only change their defined health variable during init if it was set to null. Otherwise issues will arise. */
/datum/item_unit_test/constant/items_shall_set_health_var_only_if_null/run_test(var/obj/item/I)
	if(initial(I.health) == ITEM_HEALTH_NO_DAMAGE || initial(I.max_health) == ITEM_HEALTH_NO_DAMAGE)
		return TRUE
	if(isnull(initial(I.health)))
		if(I.health > 0)
			return TRUE
		else if(istype(I.material))
			IT.failures += "Item type '[I.type]' had its health defined as null, and its material '[I.material.type]' left it as null!"
			return FALSE
	else if(I.health != initial(I.health))
		IT.failures += "Item type '[I.type]' defined a health value ([I.health? I.health : "null"]), but it was replaced during init!"
		return FALSE

/////////////////////////////////////////////////////////
// Items shall Take Damage
/////////////////////////////////////////////////////////
/datum/item_unit_test/volatile/items_shall_take_damage/run_test(var/obj/item/I)
	var/failure_text = ""
	var/old_health = I.health
	var/damage_taken_returned = I.take_damage(1, BRUTE, 0, null, 100) //Ignore armor

	//Check if invincibility actually works
	if(!isnull(old_health))
		if(old_health && old_health == I.health && old_health != ITEM_HEALTH_NO_DAMAGE && I.max_health != ITEM_HEALTH_NO_DAMAGE)
			failure_text += "Item took no damage and isn't defined as invincible. (old: [old_health? old_health : "null"], new: [I.health? I.health : "null"], returned: [damage_taken_returned? damage_taken_returned : "null"]) "
		if(old_health != I.health && (old_health == ITEM_HEALTH_NO_DAMAGE || I.max_health == ITEM_HEALTH_NO_DAMAGE))
			failure_text += "Item took some damage while defined as invincible. (old: [old_health? old_health : "null"], new: [I.health? I.health : "null"], returned: [damage_taken_returned? damage_taken_returned : "null"]) "
	else
		failure_text += "Item health is null after init. "

	//Check the take damage returned damage value
	var/damage_taken_actual = (old_health == ITEM_HEALTH_NO_DAMAGE || I.max_health == ITEM_HEALTH_NO_DAMAGE || isnull(old_health))? 0 : old_health - I.health
	if(damage_taken_returned != damage_taken_actual)
		failure_text += "take_damage() returned the wrong amount of damage (health before: [old_health? old_health : "null"], after: [I.health? I.health : "null"], returned damage:[damage_taken_returned? damage_taken_returned : "null"])."

	if(length(failure_text))
		IT.failures += "Item type [I.type]: [failure_text]"
		return FALSE
	return TRUE
