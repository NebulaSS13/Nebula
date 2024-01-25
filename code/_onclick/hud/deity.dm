/mob/living/deity
	hud_type = /datum/hud/deity

/datum/hud/deity
	has_intent_selector = /obj/screen/intent/deity

/datum/hud/deity/FinalizeInstantiation()
	..()
	var/obj/screen/intent/deity/D = action_intent
	D.sync_to_mob(mymob)
