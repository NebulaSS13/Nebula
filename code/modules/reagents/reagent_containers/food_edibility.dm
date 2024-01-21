/obj/item/chems/food/show_feed_message_end(var/mob/user, var/mob/target)
	target = target || user
	if(user && user == target && isliving(user))
		var/mob/living/living_user = user
		switch(living_user.get_food_satiation() / living_user.get_satiated_nutrition())
			if(-(INFINITY) to 0.2)
				to_chat(living_user, SPAN_WARNING("You hungrily chew out a piece of [src] and gobble it!"))
			if(0.2 to 0.4)
				to_chat(living_user, SPAN_NOTICE("You hungrily begin to eat [src]."))
			if(0.4 to 0.8)
				. = ..()
			else
				to_chat(living_user, SPAN_NOTICE("You unwillingly chew a bit of [src]."))

/obj/item/chems/food/play_feed_sound(mob/user, consumption_method = EATING_METHOD_EAT)
	if(eat_sound)
		playsound(user, pick(eat_sound), rand(10, 50), 1)
		return
	return ..()

/obj/item/chems/food/handle_eaten_by_mob(mob/user, mob/target)
	. = ..()
	if(. == EATEN_SUCCESS)
		bitecount++

/obj/item/chems/food/get_food_default_transfer_amount(mob/eater)
	return eater?.get_eaten_transfer_amount(bitesize)

/obj/item/chems/food/handle_consumed(mob/feeder, mob/eater, consumption_method = EATING_METHOD_EAT)

	if(isliving(eater) && cooked_food)
		var/mob/living/living_eater = eater
		living_eater.add_stressor(/datum/stressor/ate_cooked_food, 15 MINUTES)

	var/trash_ref = trash
	. = ..()
	if(. && trash_ref)
		if(ispath(trash_ref, /obj/item))
			var/obj/item/trash_item = new trash_ref(get_turf(feeder))
			feeder.put_in_hands(trash_item)
		else if(istype(trash_ref, /obj/item))
			feeder.put_in_hands(trash_ref)
