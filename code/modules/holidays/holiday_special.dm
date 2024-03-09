/datum/holiday/christmas/New()
	..()
	announcement = "Merry Christmas, everyone!"

/datum/holiday/christmas/set_up_holiday()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		if(isNotStationLevel(xmas.z))
			continue
		for(var/turf/T in orange(1,xmas))
			if(T.is_floor() && T.simulated)
				for(var/i = 1 to rand(1,5))
					new /obj/item/a_gift(T)
