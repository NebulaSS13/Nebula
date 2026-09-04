/obj/item/mine/frag
	name = "fragmentation mine"
	desc = "A small explosive mine with 'FRAG' and a grenade symbol on the side."
	payload = /datum/mine_payload/frag

/obj/item/mine/frag/mapped
	armed = TRUE

/datum/mine_payload/frag
	var/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment)
	var/num_fragments = 20  //total number of fragments produced by the grenade
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7
	var/explosion_size = 3

/datum/mine_payload/frag/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	owner.visible_message("\The [owner] detonates!")
	var/turf/O = get_turf(owner)
	if(O)
		owner.fragmentate(O, num_fragments, spread_range, fragment_types)
		if(explosion_size)
			explosion(O, -1, -1, round(explosion_size/2), explosion_size, FALSE)
