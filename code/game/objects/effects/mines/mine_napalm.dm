/obj/item/mine/napalm
	name = "napalm mine"
	desc = "A small explosive mine with a fire symbol on the side."
	payload = /datum/mine_payload/napalm

/obj/item/mine/napalm/mapped
	armed = TRUE

/datum/mine_payload/napalm/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	if(isliving(trigger))
		var/mob/living/M = trigger
		M.adjust_fire_intensity(5)
		M.fire_act()
	owner.visible_message(SPAN_DANGER("\The [owner] bursts into flames!"))
