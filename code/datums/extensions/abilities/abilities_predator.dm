/datum/ability_handler/predator
	var/max_dismember_size = MOB_SIZE_SMALL

/datum/ability_handler/predator/can_do_melee_invocation(mob/user, atom/target)
	return istype(user) && !user.incapacitated() && isatom(target) && target.Adjacent(user)

/datum/ability_handler/predator/do_melee_invocation(mob/user, atom/target)
	// Nibbles
	if(user.a_intent == I_HURT)
		if(isliving(target))
			return handle_dismemberment(user, target)
		if(istype(target, /obj/item/organ))
			return handle_organ_destruction(user, target)
	return FALSE

/datum/ability_handler/predator/proc/handle_organ_destruction(mob/user, obj/item/organ/chewtoy)
	if(!chewtoy.is_internal())
		user.visible_message(SPAN_DANGER("\The [user] tears apart \the [chewtoy]."))
		chewtoy.physically_destroyed()
	else if(BP_IS_PROSTHETIC(chewtoy))
		to_chat(user, SPAN_WARNING("\The [chewtoy] seems to be inedible."))
	else
		user.visible_message(SPAN_DANGER("\The [user] nibbles on \the [chewtoy]."))
		chewtoy.convert_to_food(user)
	return TRUE

/datum/ability_handler/predator/proc/handle_dismemberment(mob/user, mob/living/victim)

	if(victim.stat != DEAD || !victim.current_posture?.prone)
		return FALSE

	if(!victim.butchery_data)
		to_chat(user, SPAN_WARNING("\The [victim] appears to be inedible."))
		return TRUE

	if(victim.get_object_size() > max_dismember_size)
		to_chat(user, SPAN_WARNING("\The [victim] is too big for you to dismember."))
		return TRUE

	to_chat(user, SPAN_NOTICE("You dig into \the [victim], hunting for something edible."))
	if(!do_after(user, max(2 SECONDS, victim.get_object_size() * 5), victim) || QDELETED(victim) || !victim.butchery_data || victim.stat != DEAD)
		return TRUE

	var/list/external_organs = victim.get_external_organs()
	if(length(external_organs) <= 1)
		user.visible_message(SPAN_DANGER("\The [user] tears \the [victim] apart!"))
		victim.gib()
		return TRUE

	var/obj/item/organ/external/limb = victim.get_organ(user.get_target_zone())
	if(!limb)
		to_chat(user, SPAN_WARNING("\The [victim] is missing that limb!"))
		return TRUE

	user.visible_message(SPAN_DANGER("\The [user] tears \the [limb] from \the [victim]!"))
	limb.dismember(FALSE, DISMEMBER_METHOD_EDGE, silent = TRUE)
	if(!QDELETED(limb))
		user.put_in_hands(limb)
	return TRUE
