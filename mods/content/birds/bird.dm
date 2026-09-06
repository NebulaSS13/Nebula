/mob/living/simple_animal/passive/bird
	mob_size = MOB_SIZE_SMALL
	pass_flags = PASS_FLAG_TABLE
	abstract_type = /mob/living/simple_animal/passive/bird
	natural_weapon = /obj/item/natural_weapon/bird_claws
	holder_type = /obj/item/holder/bird

/mob/living/simple_animal/passive/bird/proc/can_be_handled_by(mob/user)
	return TRUE // TODO: trained animals, animal memories

/mob/living/simple_animal/passive/bird/proc/fly_to_target(mob/releaser, atom/target)
	if(!is_outside())
		return
	if(!istype(target) || QDELETED(target))
		return // todo: check if the target is accessible from the sky
	if(releaser)
		releaser.visible_message(SPAN_NOTICE("\The [releaser] releases \a [src], which flutters away into the sky."))
	else
		visible_message(SPAN_NOTICE("\The [src] flutters away into the sky."))
	set_dir(SOUTH)
	// this is done manually due to the actual flying state primarily being handled as a movement state.
	icon_state = "world-flying"
	new /obj/effect/dummy/fadeout(loc, NORTH, src)
	new /obj/effect/dummy/fadein(get_turf(target), SOUTH, src)
	update_icon()

	target.visible_message(SPAN_NOTICE("\A [src] alights on \the [target] in a flutter of wings."))

	var/obj/structure/hutch/hutch = target
	if(istype(hutch))
		var/obj/item/holder/bird_item = new holder_type
		forceMove(bird_item)
		bird_item.sync(src)
		hutch.storage?.handle_item_insertion(null, bird_item)
		if(bird_item.loc != target)
			dropInto(target.loc)
			qdel(bird_item)
	else
		dropInto(isturf(target) ? target : target.loc)
		if(ismob(target))
			give_held_items_to_handler(target)

/mob/living/simple_animal/passive/bird/proc/give_held_items_to_handler(mob/user)
	for(var/obj/item/thing in get_equipped_items(include_carried = TRUE))
		drop_from_inventory(thing)
		if(!QDELETED(thing))
			user.put_in_hands(thing)
			var/equipped_to = user.get_equipped_slot_for_item(thing)
			var/datum/inventory_slot/slot = equipped_to && user.get_inventory_slot_datum(equipped_to)
			if(istype(slot))
				to_chat(user, SPAN_NOTICE("\The [src] drops \a [thing] into your [lowertext(slot.slot_name)]."))
			else
				to_chat(user, SPAN_NOTICE("\The [src] drops \a [thing]."))

/obj/item/holder/bird
	w_class = MOB_SIZE_SMALL

/obj/item/holder/bird/attack_hand(mob/user)
	if(loc == user)
		var/mob/bird = locate() in src
		if(istype(bird) && length(bird.get_held_item_slots()))
			var/list/equipped = bird.get_held_items()
			if(length(equipped))
				var/obj/item/removing = pick(equipped)
				if(bird.try_unequip(removing))
					user.put_in_hands(removing)
					user.visible_message(SPAN_NOTICE("\The [user] confiscates \the [bird]'s [removing.name]."))
					return TRUE
	return ..()

/obj/item/holder/bird/attackby(obj/item/used_item, mob/user)
	var/mob/living/simple_animal/passive/bird/bird = locate() in src
	if(istype(bird) && bird.can_be_handled_by(user) && bird.get_empty_hand_slot() && user.try_unequip(used_item))
		bird.put_in_hands(used_item)
		if(used_item.loc != bird)
			user.put_in_hands(used_item)
		else
			user.visible_message(SPAN_NOTICE("\The [user] gives \the [bird] \a [used_item] to carry."))
		return TRUE
	return ..()
