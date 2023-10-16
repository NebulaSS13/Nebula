/mob/living/deity
	hud_type = /datum/hud/deity

/datum/hud/deity/FinalizeInstantiation()
	var/obj/screen/intent/deity/D = new()
	adding += D
	action_intent = D
	..()
	D.sync_to_mob(mymob)
