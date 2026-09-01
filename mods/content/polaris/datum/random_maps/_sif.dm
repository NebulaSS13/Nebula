/datum/random_map/noise/sif
	descriptor = "Sif plains (roundstart)"
	smoothing_iterations = 3
	target_turf_type = /turf/unsimulated/mask
	smooth_single_tiles = TRUE

/datum/random_map/noise/sif/cleanup()
	..()
	// Round down to 1-9.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = TRANSLATE_COORD(x,y)
			var/current_val = map[current_cell]
			map[current_cell] = min(9,max(0,round((current_val/cell_range)*10)))
			CHECK_TICK

/datum/random_map/noise/sif/get_appropriate_path(var/value)
	switch(value)
		if(0)
			return /turf/floor/mud
		if(1 to 2)
			return /turf/floor/dirt
		if(3 to 5)
			return /turf/floor/grass/sif
		if(6 to 8)
			return /turf/floor/grass/wild/sif
		if(9)
			return /turf/floor/snow

/datum/random_map/noise/sif/get_additional_spawns(var/value, var/turf/T)
	if(prob(45) || T.density)
		return
	switch(value)
		if(1 to 2)
			if(prob(1))
				new /obj/structure/flora/sif/eyes(T)
			else if(prob(1))
				new /obj/structure/flora/mushroom(T)
		if(3 to 4)
			if(prob(1))
				new /obj/structure/flora/sif/eyes(T)
			else if(prob(1))
				new /obj/structure/flora/sif/tendrils(T)
			else if(prob(1))
				new /obj/structure/flora/mushroom(T)
		if(5 to 6)
			if(prob(1))
				new /obj/structure/flora/tree/sif(T)
			else if(prob(1))
				new /obj/structure/flora/sif/tendrils(T)
			else if(prob(1))
				new /obj/structure/flora/sif/frostbelle(T)
			else if (prob(1))
				new /obj/structure/flora/sif/eyes(T)
		if(7 to 8)
			if(prob(5))
				new /obj/structure/flora/tree/sif(T)
			else if(prob(1))
				new /obj/structure/flora/sif/frostbelle(T)
			else if(prob(1))
				new /obj/structure/flora/sif/eyes(T)
			else if(prob(1))
				new /obj/structure/flora/sif/tendrils(T)
