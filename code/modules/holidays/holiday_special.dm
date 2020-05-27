/datum/holiday/christmas/New()
	..()
	announcement = "Merry Christmas, everyone!"

/datum/holiday/christmas/set_up_holiday()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		if(isNotStationLevel(xmas.z))
			continue
		for(var/turf/simulated/floor/T in orange(1,xmas))
			for(var/i=1,i<=rand(1,5),i++)
				new /obj/item/a_gift(T)
