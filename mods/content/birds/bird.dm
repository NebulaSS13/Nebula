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
	if(istype(hutch) && istype(hutch.storage))
		hutch.storage.scoop_inside(src, src)
	else
		dropInto(target)
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
	if(loc != user)
		return ..()
	var/mob/bird = locate() in src
	var/list/equipped = bird?.get_held_items()
	if(!length(equipped))
		return ..()
	var/obj/item/removing = pick(equipped)
	if(!bird.try_unequip(removing))
		return ..()
	user.put_in_hands(removing)
	user.visible_message(SPAN_NOTICE("\The [user] confiscates \the [bird]'s [removing.name]."))
	return TRUE

/obj/item/holder/bird/attackby(obj/item/used_item, mob/user)
	var/mob/living/simple_animal/passive/bird/bird = locate() in src
	if(istype(bird) && bird.can_be_handled_by(user) && bird.get_empty_hand_slot() && user.try_unequip(used_item))
		if(bird.put_in_hands(used_item))
			user.visible_message(SPAN_NOTICE("\The [user] gives \the [bird] \a [used_item] to carry."))
		else
			user.put_in_hands(used_item)
		return TRUE
	return ..()
