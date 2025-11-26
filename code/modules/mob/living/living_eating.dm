/mob/living/can_eat_food_currently(obj/eating, mob/user, consumption_method)
	user = user || src
	if(get_food_satiation(consumption_method) < get_max_nutrition())
		return TRUE
	to_chat(user, SPAN_WARNING(user.get_targeted_action_string(src, TRUE, "cannot", "force $TARGET$ to [consumption_method == EATING_METHOD_EAT ? "eat" : "drink"] any more[eating ? " of \the [eating]" : null].")))
	return FALSE
