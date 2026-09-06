/obj/item/mine/radiation
	name = "radiation mine"
	desc = "A small explosive mine with a radiation symbol on the side."
	payload = /datum/mine_payload/radiation

/obj/item/mine/radiation/mapped
	armed = TRUE

/datum/mine_payload/radiation/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	if(isliving(trigger))
		var/mob/living/victim = trigger
		victim.apply_random_mutation(50)
	owner.visible_message(SPAN_DANGER("\The [owner] flashes violently before disintegrating!"))
