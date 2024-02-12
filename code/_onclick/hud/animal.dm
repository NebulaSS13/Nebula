
/mob/living/simple_animal
	hud_type = /datum/hud/animal

/datum/hud/animal/FinalizeInstantiation()
	action_intent = new /obj/screen/intent()
	adding += action_intent
	..()

