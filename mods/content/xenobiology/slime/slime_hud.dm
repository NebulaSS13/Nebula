/datum/hud/slime/FinalizeInstantiation()
	action_intent = new /obj/screen/intent(null, mymob)
	src.adding = list(action_intent)

	..()
