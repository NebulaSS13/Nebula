
/datum/random_map/noise/sif/forest
	descriptor = "Sif forest (roundstart)"

/datum/random_map/noise/sif/forest/get_appropriate_path(var/value)
	switch(value)
		if(0 to 3)
			return /turf/floor/grass/sif
		if(4 to 6)
			return /turf/floor/grass/wild/sif
		if(7 to 9)
			return /turf/floor/snow

/datum/random_map/noise/sif/forest/get_additional_spawns(var/value, var/turf/T)
	if(prob(25) || T.density)
		return
	switch(value)
		if(0 to 5)
			if(value >= 3 && prob(5))
				new /obj/structure/flora/tree/sif(T)
				return
			if(prob(1))
				new /obj/structure/flora/sif/eyes(T)
			else if(prob(1))
				new /obj/structure/flora/sif/tendrils(T)
			else if(prob(1))
				new /obj/structure/flora/mushroom(T)
		if(6 to 9)
			if(prob((value <= 7) ? 15 : 35))
				new /obj/structure/flora/tree/sif(T)
				return
			if(prob(1))
				new /obj/structure/flora/sif/frostbelle(T)
			else if(prob(1))
				new /obj/structure/flora/sif/eyes(T)
			else if(prob(1))
				new /obj/structure/flora/sif/tendrils(T)
