var/global/list/_wounds_being_tended_by_drakes = list()

/datum/ability_handler/grafadreka/proc/handle_wound_cleaning(mob/user, mob/living/friend)
	// Can't heal ghosts or rocks.
	if(!isliving(friend))
		return FALSE
	// We can't heal robots.
	if(friend.isSynthetic())
		return FALSE
	// Check if someone else is looking after them already.
	if(global._wounds_being_tended_by_drakes["\ref[friend]"] > world.time)
		return FALSE
	// Can't heal the dead.
	if(friend.stat == DEAD)
		to_chat(user, SPAN_WARNING("\The [friend] is dead; tending their wounds is pointless."))
		return TRUE

	// Complex mobs need to have a bleeding external organ to qualify.
	var/can_tend   = FALSE
	var/is_wounded = FALSE
	if(length(friend.get_external_organs()))
		var/list/injured_organs = friend.get_injured_organs()
		if(length(injured_organs))
			var/mob/living/human/H = friend
			for (var/obj/item/organ/external/E in H.bad_external_organs)
				if(!length(E.wounds))
					continue
				is_wounded = TRUE
				for(var/datum/wound/wound in E.wounds)
					if(!wound.salved || wound.bleeding())
						can_tend = TRUE
						break
	// Simple mobs just need health damage.
	else if(friend.current_health < friend.get_max_health())
		is_wounded = TRUE
		can_tend = TRUE

	if(!can_tend)
		if(friend == user)
			if(!is_wounded)
				to_chat(user, SPAN_NOTICE("You are unwounded."))
			else
				to_chat(user, SPAN_WARNING("You cannot tend any of your wounds."))
		else
			if(!is_wounded)
				to_chat(user, SPAN_NOTICE("\The [friend] is unwounded."))
			else
				to_chat(user, SPAN_WARNING("You cannot tend any of \the [friend]'s wounds."))
		return TRUE

	// Are we already regenerating?
	if(friend.has_aura(/obj/aura/sifsap_salve))
		if(friend == user)
			to_chat(user, SPAN_WARNING("Your wounds have already been cleaned."))
		else
			to_chat(user, SPAN_WARNING("\The [friend]'s wounds have already been cleaned."))
		return TRUE

	// Do we have enough sap?
	if(!drake_has_sap(user, 10))
		if(friend == user)
			to_chat(user, SPAN_WARNING("You don't have enough sap to clean your wounds."))
		else
			to_chat(user, SPAN_WARNING("You don't have enough sap to clean \the [friend]'s wounds."))
		return TRUE

	if(friend == user)
		user.visible_message(SPAN_NOTICE("\The [user] begins to drool a blue-glowing liquid, which they start slathering over their wounds."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] begins to drool a blue-glowing liquid, which they start slathering over \the [friend]'s wounds."))
	playsound(user, 'sound/effects/ointment.ogg', 25)
	var/friend_ref = "\ref[friend]"
	global._wounds_being_tended_by_drakes[friend_ref] = world.time + (8 SECONDS)

	if(!do_after(user, 8 SECONDS, friend) || QDELETED(friend) || friend.has_aura(/obj/aura/sifsap_salve) || user.incapacitated() || !drake_spend_sap(user, 10))
		global._wounds_being_tended_by_drakes -= friend_ref
		return TRUE

	global._wounds_being_tended_by_drakes -= friend_ref
	if(friend == user)
		user.visible_message(SPAN_NOTICE("\The [user] finishes licking at their wounds."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] finishes licking at \the [friend]'s wounds."))
	playsound(user, 'sound/effects/ointment.ogg', 25)

	// Sivian animals get a heal buff from the modifier, others just
	// get it to stop friendly drakes constantly licking their wounds.
	// Organ wounds are closed, but the owners get sifsap injected via open wounds.
	friend.add_aura(new /obj/aura/sifsap_salve(null, 60 SECONDS))
	var/list/friend_organs = friend.get_external_organs()
	if(length(friend_organs))
		for (var/obj/item/organ/external/E in friend_organs)
			if(E.status & ORGAN_BLEEDING)
				E.clamp_organ()
				var/datum/reagents/bloodstream = friend.get_injected_reagents()
				if(bloodstream)
					bloodstream.add_reagent(/decl/material/liquid/sifsap, rand(1,2))
			for (var/datum/wound/W in E.wounds)
				W.clamped = TRUE // use this rather than bandaged to avoid message weirdness
				W.salve()
				W.disinfect()
	// Everyone else is just poisoned.
	else if(!friend.has_trait(/decl/trait/sivian_biochemistry))
		friend.take_damage(rand(1,2), TOX)
	return TRUE
