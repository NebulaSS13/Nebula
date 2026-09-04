/obj/item/mine/kick
	name = "kick mine"
	desc = "Concentrated war crimes. Handle with care."
	payload = /datum/mine_payload/kick

/obj/item/mine/kick/mapped
	armed = TRUE

/datum/mine_payload/kick/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	if(isexosuit(trigger))
		var/mob/living/exosuit/mech = trigger
		for(var/mob/pilot in mech.pilots)
			qdel(pilot.client)
	if(ismob(trigger))
		var/mob/M = trigger
		qdel(M.client)
