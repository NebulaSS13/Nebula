/obj/item/chems/condiment/show_feed_message_start(var/mob/user, var/mob/target)
	target = target || user
	if(user)
		if(user == target)
			to_chat(user, SPAN_NOTICE("You begin trying to eat some of \the [target]."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] is trying to feed some of the contents of \the [src] to \the [target]!"))

/obj/item/chems/condiment/show_feed_message_end(var/mob/user, var/mob/target)
	target = target || user
	if(user)
		if(user == target)
			to_chat(user, SPAN_NOTICE("You swallow some of the contents of \the [src]."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] feeds some of the contents of \the [src] to \the [target]!"))
