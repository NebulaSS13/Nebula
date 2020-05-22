/turf/simulated/wall/natural/random/proc/get_weighted_mineral_list()
	. = GLOB.weighted_minerals_sparse

/turf/simulated/wall/natural/random/high_chance/get_weighted_mineral_list()
	. = GLOB.weighted_minerals_rich

/turf/simulated/wall/natural/random/Initialize()
	if(!reinf_material)
		var/default_mineral_list = get_weighted_mineral_list()
		if(LAZYLEN(default_mineral_list))
			reinf_material = pickweight(default_mineral_list)
	. = ..()
