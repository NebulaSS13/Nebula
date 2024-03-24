/area
	var/fishing_failure_prob = 95
	var/list/fishing_results = list(/obj/random/junk = 1)

/area/proc/get_fishing_result(turf/origin, obj/item/chems/food/bait)
	if(!length(fishing_results) || prob(fishing_failure_prob))
		return null
	var/loot_type = pickweight(fishing_results)
	if(!loot_type)
		return null

	. = new loot_type(origin)

	// This is pretty rancid but we're limited in our ability to actually refine a
	// random spawner down to one specific item. Fishing devs will just need to not
	// use random spawners that can produce multiple results I guess?
	while(istype(., /obj/random))
		var/obj/random/rand = .
		if(length(rand.spawned_atoms))
			. = rand.spawned_atoms[1]
		else
			. = null
