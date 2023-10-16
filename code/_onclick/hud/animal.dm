
/mob/living/simple_animal
	hud_type = /datum/hud/animal

/datum/hud/animal/FinalizeInstantiation()
	action_intent = new /obj/screen/intent(null, mymob)
	adding += action_intent
	..()

