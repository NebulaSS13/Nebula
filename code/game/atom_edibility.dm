/atom/proc/show_food_empty_message(mob/user, consumption_method = EATING_METHOD_EAT)
	to_chat(user, SPAN_NOTICE("\The [src] is empty of anyting [consumption_method == EATING_METHOD_EAT ? "edible" : "potable"]."))
