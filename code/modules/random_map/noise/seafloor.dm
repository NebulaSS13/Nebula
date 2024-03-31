/datum/random_map/noise/seafloor
	descriptor = "seafloor (roundstart)"
	smoothing_iterations = 3
	target_turf_type = /turf/floor/seafloor/flooded

/datum/random_map/noise/seafloor/replace_space
	descriptor = "seafloor (replace)"
	target_turf_type = TRUE

/datum/random_map/noise/seafloor/replace_space/get_appropriate_path(var/value)
	return /turf/floor/seafloor/flooded

/datum/random_map/noise/seafloor/get_appropriate_path(var/value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	switch(val)
		if(6)
			return /turf/floor/clay/flooded
		if(7 to 9)
			return /turf/floor/mud/flooded

/datum/random_map/noise/seafloor/get_additional_spawns(var/value, var/turf/T)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(3,4)
			if(prob(10))
				new /obj/structure/flora/seaweed(T)
			else if(prob(10))
				new /obj/structure/flora/seaweed/mid(T)
		if(5)
			if(prob(20))
				new /obj/structure/flora/seaweed(T)
			else if(prob(20))
				new /obj/structure/flora/seaweed/mid(T)
			else if(prob(60))
				new /obj/structure/flora/seaweed/large(T)
			else if(prob(10))
				new /obj/structure/flora/seaweed/glow(T)
		if(6)
			if(prob(20))
				new /obj/structure/flora/seaweed/mid(T)
			else if(prob(30))
				new /obj/structure/flora/seaweed/large(T)
			else if (prob(5))
				new /obj/structure/flora/seaweed/glow(T)
		if(7,9)
			if(prob(35))
				new /obj/structure/flora/seaweed/large(T)
			else if(prob(1))
				new /obj/structure/flora/seaweed/glow(T)
