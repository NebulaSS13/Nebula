
/mob/living/simple_animal
	hud_type = /datum/hud/animal

/datum/hud/animal/FinalizeInstantiation()
	mymob.client.screen = list()
	action_intent = new /obj/screen/intent()
	mymob.client.screen |= action_intent