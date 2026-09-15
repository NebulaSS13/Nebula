/datum/mob_controller/proc/wants_to_hunt(mob/living/prey)
	if(prey.isSynthetic())
		return FALSE
	if(prey.stat != DEAD && prey.get_object_size() >= body.get_object_size())
		return FALSE
	if(body.get_nutrition() >= body.get_satiated_nutrition())
		return FALSE
	if(LAZYLEN(_enemies) && (weakref(prey) in _enemies))
		return FALSE
	return TRUE

/datum/mob_controller/proc/consume_prey(mob/living/prey)

	if(prey.stat != DEAD)
		return

	set_target(null)

	if((ai_flags & AI_FLAG_RETURNING) && last_handler && handler_set_target)
		prey.try_make_grab(body, defer_hand = TRUE)
		set_stance(/decl/mob_controller_stance/returning)
		return

	if(!prey.isSynthetic())
		body.visible_message(SPAN_DANGER("\The [body] consumes the body of \the [prey]!"))
		var/remains_type = prey.get_remains_type()
		if(remains_type)
			var/obj/item/remains/remains = new remains_type(get_turf(prey))
			remains.desc += "These look like they belonged to \a [prey.name]."
		body.adjust_nutrition(5 * prey.get_max_health())
		if(prob(5))
			prey.gib()
		else
			qdel(prey)

	set_stance(/decl/mob_controller_stance/idle)

/datum/mob_controller/proc/give_held_items_to_handler(mob/living/handler)
	for(var/obj/item/thing in body.get_equipped_items(include_carried = TRUE))
		body.drop_from_inventory(thing)
		if(!QDELETED(thing))
			handler.put_in_hands(thing)
			var/equipped_to = handler.get_equipped_slot_for_item(thing)
			var/datum/inventory_slot/slot = equipped_to && handler.get_inventory_slot_datum(equipped_to)
			if(istype(slot))
				to_chat(handler, SPAN_NOTICE("\The [body] drops \a [thing] into your [lowertext(slot.slot_name)]."))
			else
				to_chat(handler, SPAN_NOTICE("\The [body] drops \a [thing]."))
