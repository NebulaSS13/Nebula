/obj/item/chems/drinks/handle_eaten_by_mob(var/mob/user, var/mob/target)
	if(!do_open_check(user))
		return EATEN_UNABLE
	. = ..()
	if(. == EATEN_SUCCESS)
		target = target || user
		if(target?.has_personal_goal(/datum/goal/achievement/specific_object/drink))
			for(var/R in reagents.reagent_volumes)
				target.update_personal_goal(/datum/goal/achievement/specific_object/drink, R)

/obj/item/chems/drinks/show_feed_message_end(var/mob/user, var/mob/target)
	if(user == target)
		to_chat(user, SPAN_NOTICE("You swallow a gulp from \the [src]."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] feeds \the [src] to \the [target]!"))
