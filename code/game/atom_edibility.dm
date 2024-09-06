/atom/proc/show_food_empty_message(mob/user, consumption_method = EATING_METHOD_EAT)
	to_chat(user, SPAN_NOTICE("\The [src] is empty of anyting [consumption_method == EATING_METHOD_EAT ? "edible" : "potable"]."))

/atom/proc/show_food_no_mouth_message(mob/user, mob/target)
	target = target || user
	if(user)
		if(user == target)
			to_chat(user, SPAN_WARNING("Where do you intend to put \the [src]? You don't have a mouth!"))
		else
			to_chat(user, SPAN_WARNING("Where do you intend to put \the [src]? \The [target] doesn't have a mouth!"))
