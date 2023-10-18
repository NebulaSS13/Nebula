/mob/living/deity
	hud_type = /datum/hud/deity

/datum/hud/deity/FinalizeInstantiation()
	action_intent =  new /obj/screen/intent/deity(null, mymob)
	src.adding = list(action_intent)
	src.other = list()
	..()
	var/obj/screen/intent/deity/D = action_intent
	D.sync_to_mob(mymob)
