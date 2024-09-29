/mob/living/mob_throw_item(atom/target, atom/movable/item)

	toggle_throw_mode(FALSE)
	if(!item)
		item = get_active_held_item()

	if(incapacitated() || !target || istype(target, /obj/screen) || !istype(item) || !(item in get_held_items()))
		return FALSE

	var/place_item = a_intent != I_HURT && Adjacent(target)

	if(istype(item, /obj/item/grab))
		var/obj/item/grab/grab = item
		item = grab.throw_held()
		/// throw the person instead of the grab
		if(ismob(item))
			var/mob/mob = item
			//limit throw range by relative mob size
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T && usr == src)
				var/start_T_descriptor = "<font color='#6b5d00'>[start_T] \[[start_T.x],[start_T.y],[start_T.z]\] ([start_T.loc])</font>"
				var/end_T_descriptor = "<font color='#6b4400'>[start_T] \[[end_T.x],[end_T.y],[end_T.z]\] ([end_T.loc])</font>"
				admin_attack_log(usr, mob, "Threw the victim from [start_T_descriptor] to [end_T_descriptor].", "Was from [start_T_descriptor] to [end_T_descriptor].", "threw, from [start_T_descriptor] to [end_T_descriptor], ")
		drop_from_inventory(grab)

	// Hand items to a nearby target, or place them on the turf.
	// Don't unequip early, keep it in our hands so we can give it!
	else if(place_item && !QDELETED(item) && !QDELETED(target))
		// We've already been unequipped above.
		if(isliving(target))
			var/mob/living/mob = target
			if(length(mob.get_held_item_slots()))
				if(mob == src || (mob.in_throw_mode && mob.a_intent == I_HELP))
					if(!try_unequip(item, play_dropsound = place_item))
						return FALSE
					if(target != src)
						mob.put_in_hands(item) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
						visible_message(
							"<b>\The [src]</b> hands \the [mob] \a [item].",
							SPAN_NOTICE("You give \the [mob] \a [item].")
						)
					else
						var/same_hand = a_intent == I_HELP
						var/decl/pronouns/user_pronouns = get_pronouns()
						visible_message(
							"<b>\The [src]</b> tosses \the [item] [same_hand ? "in the air and catches it." : "between [user_pronouns.his] hands"].",
							SPAN_NOTICE("You toss \the [item] [same_hand ? "in the air and catch it" : "between your hands"].")
						)
						if(same_hand)
							put_in_active_hand(item)
						else
							put_in_inactive_hand(item)
				else
					to_chat(src, SPAN_NOTICE("You offer \the [item] to \the [mob]."))
					do_give(mob)
				return TRUE
			to_chat(src, SPAN_WARNING("\The [mob] has no way to hold \the [item]!"))
			return TRUE

		if(!QDELETED(item) && item.loc != target)
			if(item.loc == src)
				try_unequip(item, get_turf(target), play_dropsound = place_item)
			else
				item.forceMove(get_turf(target))

		return TRUE
	else if(!try_unequip(item, play_dropsound = place_item))
		return FALSE

	if(!istype(item) || QDELETED(item) || !isturf(item.loc))
		return FALSE

	if(place_item)
		return TRUE

	var/itemsize = item.get_object_size()
	var/message = "\The [src] has thrown \the [item]!"
	var/skill_mod = 0.2
	if(!skill_check(SKILL_HAULING, min(round(itemsize - ITEM_SIZE_HUGE) + 2, SKILL_MAX)))
		if(prob(30))
			SET_STATUS_MAX(src, STAT_WEAK, 2)
			message = "\The [src] barely manages to throw \the [item], and is knocked off-balance!"
	else
		skill_mod += 0.2

	skill_mod += 0.8 * (get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN)
	var/throw_range = round(item.throw_range * min(mob_size/itemsize, 1) * skill_mod)

	//actually throw it!
	visible_message(SPAN_WARNING(message), range = min(itemsize*2,world.view))
	lastarea = lastarea || get_area(loc)
	if(!check_space_footing() && prob((itemsize * itemsize * 10) * MOB_SIZE_MEDIUM/mob_size))
		var/direction = get_dir(target, src)
		step(src, direction)
		space_drift(direction)

	item.throw_at(target, throw_range, item.throw_speed * skill_mod, src)
	playsound(src, 'sound/effects/throw.ogg', 50, 1)
	animate_throw(src)
