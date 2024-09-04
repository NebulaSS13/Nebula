/mob/living/can_eat_food_currently(obj/eating, mob/user, consumption_method)
	user = user || src
	if(get_food_satiation(consumption_method) < get_max_nutrition())
		return TRUE
	var/eat_verb = consumption_method == EATING_METHOD_EAT ? "eat" : "drink"
	if(eating)
		if(user == src)
			to_chat(user, SPAN_WARNING("You cannot force yourself to [eat_verb] any more of \the [eating]."))
		else
			to_chat(user, SPAN_WARNING("You cannot force \the [src] to [eat_verb] any more of \the [eating]."))
	else
		if(user == src)
			to_chat(user, SPAN_WARNING("You cannot force yourself to [eat_verb] any more."))
		else
			to_chat(user, SPAN_WARNING("You cannot force \the [src] to [eat_verb] any more."))
	return FALSE
