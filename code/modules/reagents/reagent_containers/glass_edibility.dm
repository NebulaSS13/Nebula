/obj/item/chems/glass/handle_eaten_by_mob(var/mob/user, var/mob/target)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_WARNING("You need to open \the [src] first."))
		return EATEN_UNABLE
	if(user.a_intent == I_HURT)
		return EATEN_INVALID
	. = ..()
	if(. == EATEN_SUCCESS && target?.has_personal_goal(/datum/goal/achievement/specific_object/drink))
		for(var/R in reagents.reagent_volumes)
			target.update_personal_goal(/datum/goal/achievement/specific_object/drink, R)

/obj/item/chems/glass/show_feed_message_start(var/mob/user, var/mob/target)
	target = target || user
	if(user)
		if(user == target)
			to_chat(user, SPAN_NOTICE("You begin trying to drink from \the [target]."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] is trying to feed some of the contents of \the [src] to \the [target]!"))

/obj/item/chems/glass/show_feed_message_end(var/mob/user, var/mob/target)
	target = target || user
	if(user)
		if(user == target)
			to_chat(user, SPAN_NOTICE("You swallow a gulp from \the [src]."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] feeds some of the contents of \the [src] to \the [target]!"))
