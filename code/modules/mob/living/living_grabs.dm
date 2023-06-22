/mob/living/proc/can_grab(var/atom/movable/target, var/target_zone, var/defer_hand = FALSE)
	if(!ismob(target) && target.anchored)
		to_chat(src, SPAN_WARNING("\The [target] won't budge!"))
		return FALSE
	if(defer_hand)
		if(!get_empty_hand_slot())
			to_chat(src, SPAN_WARNING("Your hands are full!"))
			return FALSE
	else if(get_active_hand())
		to_chat(src, SPAN_WARNING("Your hand is full!"))
		return FALSE
	if(LAZYLEN(grabbed_by))
		to_chat(src, SPAN_WARNING("You cannot start grappling while already being grappled!"))
		return FALSE
	for(var/obj/item/grab/G in target.grabbed_by)
		if(G.assailant != src)
			continue
		if(!target_zone || !ismob(target))
			to_chat(src, SPAN_WARNING("You already have a grip on \the [target]!"))
			return FALSE
		if(G.target_zone == target_zone)
			var/obj/O = G.get_targeted_organ()
			if(O)
				to_chat(src, SPAN_WARNING("You already have a grip on \the [target]'s [O.name]."))
				return FALSE
	return TRUE

/mob/living/proc/make_grab(var/atom/movable/target, var/grab_tag = /decl/grab/simple, var/defer_hand = FALSE)

	// Resolve to the 'topmost' atom in the buckle chain, as grabbing someone buckled to something tends to prevent further interaction.
	var/atom/movable/original_target = target
	var/mob/grabbing_mob = (ismob(target) && target)
	while(istype(grabbing_mob) && grabbing_mob.buckled)
		grabbing_mob = grabbing_mob.buckled
	if(grabbing_mob && grabbing_mob != original_target)
		target = grabbing_mob
		to_chat(src, SPAN_WARNING("As \the [original_target] is buckled to \the [target], you try to grab that instead!"))

	if(!istype(target))
		return

	face_atom(target)
	var/obj/item/grab/grab
	if(ispath(grab_tag, /decl/grab) && can_grab(target, get_target_zone(), defer_hand = defer_hand) && target.can_be_grabbed(src, get_target_zone(), defer_hand))
		grab = new /obj/item/grab(src, target, grab_tag, defer_hand)

	if(QDELETED(grab))
		if(original_target != src && ismob(original_target))
			to_chat(original_target, SPAN_WARNING("\The [src] tries to grab you, but fails!"))
		to_chat(src, SPAN_WARNING("You try to grab \the [target], but fail!"))
	return grab

/mob/living/add_grab(var/obj/item/grab/grab, var/defer_hand = FALSE)
	for(var/obj/item/grab/other_grab in contents)
		if(other_grab != grab)
			return FALSE
	grab.forceMove(src)
	return TRUE

/mob/living/ProcessGrabs()
	if(LAZYLEN(grabbed_by))
		resist()
