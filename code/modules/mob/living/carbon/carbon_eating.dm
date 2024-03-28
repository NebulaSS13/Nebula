/mob/living/can_eat_food_currently(obj/eating, mob/user, consumption_method)
	user = user || src
	if(get_food_satiation(consumption_method) < get_max_nutrition())
		return TRUE
	if(user == src)
		to_chat(user, SPAN_WARNING("You cannot force any more of \the [eating] down your throat."))
	else
		to_chat(user, SPAN_WARNING("You cannot force any more of \the [eating] down \the [src]'s throat."))
	return FALSE
