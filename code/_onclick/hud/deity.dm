/mob/living/deity
	hud_used = /datum/hud/deity

/datum/hud/deity/FinalizeInstantiation()
	action_intent =  new /obj/screen/intent/deity(null, mymob)
	adding += action_intent
	..()
	var/obj/screen/intent/deity/D = action_intent
	D.sync_to_mob(mymob)
