/mob/living/proc/check_grab_hand(defer_hand)
	var/decl/pronouns/self_pronouns = get_self_pronouns()
	if(defer_hand)
		if(!get_empty_hand_slot())
			to_chat(src, SPAN_WARNING("[self_pronouns.His] hands are full!"))
			return FALSE
	else if(get_active_held_item())
		to_chat(src, SPAN_WARNING("[self_pronouns.His] [parse_zone(get_active_held_item_slot())] is full!"))
		return FALSE
	return TRUE

/mob/living/proc/can_grab(var/atom/movable/target, var/target_zone, var/defer_hand = FALSE)
	if(!ismob(target) && target.anchored)
		to_chat(src, SPAN_WARNING("\The [target] won't budge!"))
		return FALSE
	if(!check_grab_hand(defer_hand))
		return FALSE
	if(LAZYLEN(grabbed_by))
		to_chat(src, SPAN_WARNING(get_action_string(TRUE, "cannot", "start grappling while already being grappled!")))
		return FALSE
	for(var/obj/item/grab/grab as anything in target.grabbed_by)
		if(grab.assailant != src)
			continue
		if(!target_zone || !ismob(target))
			to_chat(src, SPAN_WARNING(get_action_string(TRUE, "has", "a grip on \the [target]!", "already")))
			return FALSE
		if(grab.target_zone == target_zone)
			var/obj/O = grab.get_targeted_organ()
			if(O)
				to_chat(src, SPAN_WARNING(get_targeted_action_string(target, TRUE, "has", "a grip on $TARGET'S$ [O.name].", "already")))
				return FALSE
	return TRUE

/mob/living/proc/make_grab(atom/movable/target, grab_tag = /decl/grab/simple, defer_hand = FALSE, force_grab_tag = FALSE)

	// Resolve to the 'topmost' atom in the buckle chain, as grabbing someone buckled to something tends to prevent further interaction.
	var/atom/movable/original_target = target
	var/mob/grabbing_mob = (ismob(target) && target)
	while(istype(grabbing_mob) && grabbing_mob.buckled)
		grabbing_mob = grabbing_mob.buckled
	if(grabbing_mob && grabbing_mob != original_target)
		target = grabbing_mob
		var/decl/pronouns/self_pronouns = get_self_pronouns()
		to_chat(src, SPAN_WARNING("As \the [original_target] is buckled to \the [target], [self_pronouns.he] [verb_agree_with_pronouns("try", self_pronouns)] to grab that instead!"))

	if(!istype(target))
		return

	if(!force_grab_tag)
		var/decl/species/my_species = get_species()
		if(my_species?.grab_type)
			grab_tag = my_species.grab_type

	face_atom(target)
	var/obj/item/grab/grab
	if(ispath(grab_tag, /decl/grab) && can_grab(target, get_target_zone(), defer_hand = defer_hand) && target.can_be_grabbed(src, get_target_zone(), defer_hand))
		grab = new /obj/item/grab(src, target, grab_tag, defer_hand)

	if(QDELETED(grab))
		if(original_target != src && ismob(original_target))
			to_chat(original_target, SPAN_WARNING(get_action_string(FALSE, "try", "to grab you, but fail$USER_S$!")))
		to_chat(src, SPAN_WARNING(get_targeted_action_string(target, TRUE, "try", "to grab $TARGET$, but fail$USER_S$!")))
	return grab

/mob/living/add_grab(var/obj/item/grab/grab, var/defer_hand = FALSE)

	if(has_had_gripper)
		if(defer_hand)
			. = put_in_hands(grab)
		else
			. = put_in_active_hand(grab)
		return

	for(var/obj/item/grab/other_grab in contents)
		if(other_grab != grab)
			return FALSE
	grab.forceMove(src)
	return TRUE

/mob/living/ProcessGrabs()
	if(LAZYLEN(grabbed_by))
		resist()

/mob/living/give_control_grab(var/mob/living/M)
	return (isliving(M) && M == buckled_mob) ? M.make_grab(src, /decl/grab/simple/control, force_grab_tag = TRUE) : ..()
