/turf/simulated/wall/natural/random/Initialize(ml, materialtype, rmaterialtype, default_mineral_list)
	if(!default_mineral_list)
		default_mineral_list = GLOB.weighted_minerals_sparse
	if(!reinf_material && LAZYLEN(default_mineral_list))
		reinf_material = pickweight(default_mineral_list)
	. = ..()

/turf/simulated/wall/natural/random/high_chance/Initialize(ml, materialtype, rmaterialtype, default_mineral_list)
	. = ..(ml, materialtype, rmaterialtype, GLOB.weighted_minerals_rich)
