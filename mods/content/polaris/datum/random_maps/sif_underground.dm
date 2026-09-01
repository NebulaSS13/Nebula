/datum/random_map/noise/sif/underground
	descriptor = "Sif underground (roundstart)"
	target_turf_type = /turf/wall/natural

/datum/random_map/noise/sif/underground/get_appropriate_path(var/value)
	switch(value)
		if(0 to 2)
			return /turf/floor/mud
		if(3 to 4)
			return /turf/floor/dirt

/datum/random_map/noise/sif/underground/get_additional_spawns(var/value, var/turf/T)
	if(value <= 1 && prob(30)) // Mud is very fun-gy.
		new /obj/structure/flora/mushroom(T)
	else if(!prob(30))
		var/mushroom_prob = 0
		switch(value)
			if(2)
				mushroom_prob = 8
			if(3)
				mushroom_prob = 4
			if(4 to 6)
				mushroom_prob = 2
			if(7)
				mushroom_prob = 1
		if(mushroom_prob && prob(mushroom_prob))
			new /obj/structure/flora/mushroom(T)
		else if(prob(0.1))
			new /obj/structure/flora/sif/subterranean(T)