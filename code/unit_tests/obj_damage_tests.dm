/////////////////////////////////////////////////////////
// items_shall_stay_invincible
/////////////////////////////////////////////////////////
/datum/item_unit_test/constant/items_shall_stay_invincible/run_test(var/obj/item/I)
	if(initial(I.health) != ITEM_HEALTH_NO_DAMAGE && initial(I.max_health) != ITEM_HEALTH_NO_DAMAGE)
		return TRUE //Ignore things that aren't invincible
	if(I.health != ITEM_HEALTH_NO_DAMAGE || I.max_health != ITEM_HEALTH_NO_DAMAGE)
		IT.report_failure(src, I.type, "Is defined as not taking health damage, but it can take damage after init.")
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////
// items_shall_define_their_max_health
/////////////////////////////////////////////////////////
/datum/item_unit_test/constant/items_shall_define_their_max_health/run_test(var/obj/item/I)
	if(I.health == ITEM_HEALTH_NO_DAMAGE || I.max_health == ITEM_HEALTH_NO_DAMAGE)
		return TRUE //We don't care about invincible things
	if(I.health > 0 && I.max_health != I.health)
		IT.report_failure(src, I.type, "Defines health = [I.health], but its max_health is [I.max_health? I.max_health : "null"].")
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
			IT.report_failure(src, I.type, "Had its health defined as null, and its material '[I.material.type]' left it as null!")
			return FALSE
		else
			IT.report_failure(src, I.type, "Had its health defined as null, didn't assign a valid health value during init, and isn't marked as invincible.")
			return FALSE

	else if(I.health != initial(I.health))
		IT.report_failure(src, I.type, "Defined a health value ([I.health? I.health : "null"]), but it was replaced during init! Highly likely to be undesired!")
		return FALSE

	//In this case, the health was set to something, and didn't change during init
	return TRUE

/////////////////////////////////////////////////////////
// Items shall get a valid health from materials
/////////////////////////////////////////////////////////
/** Makes sure that if we have a material setting up our health, it actually sets it to something sane. */
/datum/item_unit_test/constant/items_shall_get_a_valid_health_from_materials/run_test(var/obj/item/I)
	//If any health is specified or if the object is invincible skip. Return true on no material too since its not our job to validate the material logic
	if(!isnull(initial(I.health)) || !isnull(initial(I.max_health)) || !I.material)
		return TRUE

	if((I.max_health < 1.0) || (I.health < 1.0))
		IT.report_failure(src, I.type, "Had its health/max_health set to a value < 1 by its material '[I.material.type]', where '[I.material.name]''s 'integrity' == '[I.material.integrity]', and '[I]''s 'material_health_multiplier' == '[I.material_health_multiplier]'.")
		return FALSE
	return TRUE

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
		IT.report_failure(src, I.type, failure_text)
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////
// Items shall be destroyed gracefully
/////////////////////////////////////////////////////////
/**Damages items to destruction and see if it throws runtimes. Type starts with z so it's run last.*/
/datum/item_unit_test/volatile/z_items_shall_be_destroyed_gracefully/run_test(var/obj/item/I)
	try
		var/damage_dealt = I.can_take_damage() ? (I.max_health + 1) : 9999 //Arbitrary large damage value for invincible things
		I.take_damage(damage_dealt, BRUTE, 0, "TEST", ARMOR_PIERCING_BYPASSED) //Just let the exception handler do its job
		. = TRUE
	catch(var/exception/E)
		IT.report_failure(src, I.type, "Threw an exception when destroyed by brute damage!: [EXCEPTION_TEXT(E)]")
		. = FALSE
		throw E