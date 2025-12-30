/datum/holiday/christmas
	announcement = "Merry Christmas, everyone!"

/datum/holiday/christmas/set_up_holiday()
	for(var/obj/structure/flora/tree/pine/xmas/crimmas_tree in global.christmas_trees)
		if(isNotStationLevel(crimmas_tree.z))
			continue
		for(var/turf/T in orange(1, crimmas_tree))
			if(!T.is_floor() || !T.simulated)
				continue
			for(var/i = 1 to rand(1,5))
				new /obj/item/a_gift(T)
