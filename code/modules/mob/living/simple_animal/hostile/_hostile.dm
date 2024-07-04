/mob/living/simple_animal/hostile
	abstract_type = /mob/living/simple_animal/hostile
	faction = "hostile"
	a_intent = I_HURT
	response_help_3p = "$USER$ pokes $TARGET$."
	response_help_1p = "You poke $TARGET$."
	response_disarm =  "shoves"
	response_harm =    "strikes"
	ai = /datum/mob_controller/aggressive

/mob/living/simple_animal/hostile/can_pry_door()
	return TRUE
