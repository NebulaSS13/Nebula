/////////////////////////////////////////////////////////
// items_shall_stay_invincible
/////////////////////////////////////////////////////////
/datum/item_unit_test/constant/items_shall_stay_invincible/run_test(var/obj/item/I)
	if(initial(I.current_health) != ITEM_HEALTH_NO_DAMAGE && initial(I.max_health) != ITEM_HEALTH_NO_DAMAGE)
		return TRUE //Ignore things that aren't invincible
	if(I.current_health != ITEM_HEALTH_NO_DAMAGE || I.get_max_health() != ITEM_HEALTH_NO_DAMAGE)
		IT.report_failure(src, I.type, "Is defined as not taking health damage, but it can take damage after init.")
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////
// items_shall_define_their_max_health
/////////////////////////////////////////////////////////
/datum/item_unit_test/constant/items_shall_define_their_max_health/run_test(var/obj/item/I)
	var/current_max_health = I.get_max_health()
	if(I.current_health == ITEM_HEALTH_NO_DAMAGE || current_max_health == ITEM_HEALTH_NO_DAMAGE)
		return TRUE //We don't care about invincible things
	if(I.current_health > 0 && current_max_health != I.current_health)
		IT.report_failure(src, I.type, "Defines health = [I.current_health], but its max health is [current_max_health || "null"].")
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////
// items_shall_set_health_var_only_if_null
/////////////////////////////////////////////////////////
/**Items should only change their defined health variable during init if it was set to null. Otherwise issues will arise. */
/datum/item_unit_test/constant/items_shall_set_health_var_only_if_null/run_test(var/obj/item/I)
	if(initial(I.current_health) == ITEM_HEALTH_NO_DAMAGE || initial(I.max_health) == ITEM_HEALTH_NO_DAMAGE)
		return TRUE

	if(isnull(initial(I.current_health)))
		if(I.current_health > 0)
			return TRUE
		else if(istype(I.material))
			IT.report_failure(src, I.type, "Had its health defined as null, and its material '[I.material.type]' left it as null!")
			return FALSE
		else
			IT.report_failure(src, I.type, "Had its health defined as null, didn't assign a valid health value during init, and isn't marked as invincible.")
			return FALSE

	else if(I.current_health != initial(I.current_health))
		IT.report_failure(src, I.type, "Defined a health value ([I.current_health? I.current_health : "null"]), but it was replaced during init! Highly likely to be undesired!")
		return FALSE

	//In this case, the health was set to something, and didn't change during init
	return TRUE

/////////////////////////////////////////////////////////
// Items shall get a valid health from materials
/////////////////////////////////////////////////////////
/** Makes sure that if we have a material setting up our health, it actually sets it to something sane. */
/datum/item_unit_test/constant/items_shall_get_a_valid_health_from_materials/run_test(var/obj/item/I)
	//If any health is specified or if the object is invincible skip. Return true on no material too since its not our job to validate the material logic
	if(!isnull(initial(I.current_health)) || !isnull(initial(I.max_health)) || !I.material)
		return TRUE

	if((I.get_max_health() < 1.0) || (I.current_health < 1.0))
		IT.report_failure(src, I.type, "Had its health/max health set to a value < 1 by its material '[I.material.type]', where '[I.material.name]''s 'integrity' == '[I.material.integrity]', and '[I]''s 'material_health_multiplier' == '[I.material_health_multiplier]'.")
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////
// Items shall Take Damage
/////////////////////////////////////////////////////////
/datum/item_unit_test/volatile/items_shall_take_damage/run_test(var/obj/item/I)
	var/failure_text = ""
	var/old_health = I.current_health
	var/damage_taken_returned = I.take_damage(1, BRUTE, 0, null, 100) //Ignore armor

	//Check if invincibility actually works
	if(!isnull(old_health))
		if(old_health && old_health == I.current_health && old_health != ITEM_HEALTH_NO_DAMAGE && I.get_max_health() != ITEM_HEALTH_NO_DAMAGE)
			failure_text += "Item took no damage and isn't defined as invincible. (old: [old_health? old_health : "null"], new: [I.current_health? I.current_health : "null"], returned: [damage_taken_returned? damage_taken_returned : "null"]) "
		if(old_health != I.current_health && (old_health == ITEM_HEALTH_NO_DAMAGE || I.get_max_health() == ITEM_HEALTH_NO_DAMAGE))
			failure_text += "Item took some damage while defined as invincible. (old: [old_health? old_health : "null"], new: [I.current_health? I.current_health : "null"], returned: [damage_taken_returned? damage_taken_returned : "null"]) "
	else
		failure_text += "Item health is null after init. "

	//Check the take damage returned damage value
	var/damage_taken_actual = (old_health == ITEM_HEALTH_NO_DAMAGE || I.get_max_health() == ITEM_HEALTH_NO_DAMAGE || isnull(old_health))? 0 : old_health - I.current_health
	if(damage_taken_returned != damage_taken_actual)
		failure_text += "take_damage() returned the wrong amount of damage (health before: [old_health? old_health : "null"], after: [I.current_health? I.current_health : "null"], returned damage:[damage_taken_returned? damage_taken_returned : "null"])."

	if(length(failure_text))
		IT.report_failure(src, I.type, failure_text)
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////
// Items shall be destroyed gracefully
/////////////////////////////////////////////////////////
/**Damages items to destruction and see if it throws runtimes. Type starts with z so it's run last.*/
/datum/item_unit_test/volatile/z_items_shall_be_destroyed_gracefully/run_test(var/obj/item/I)
	try
		var/damage_dealt = I.can_take_damage() ? (I.get_max_health() + 1) : 9999 //Arbitrary large damage value for invincible things
		I.take_damage(damage_dealt, BRUTE, 0, "TEST", ARMOR_PIERCING_BYPASSED) //Just let the exception handler do its job
		. = TRUE
	catch(var/exception/E)
		IT.report_failure(src, I.type, "Threw an exception when destroyed by brute damage!: [EXCEPTION_TEXT(E)]")
		. = FALSE
		throw E
