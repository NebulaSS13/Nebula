/turf/simulated/wall/natural/random
	reinf_material = null

/turf/simulated/wall/natural/random/proc/get_weighted_mineral_list()
	if(strata)
		var/decl/strata/strata_info = decls_repository.get_decl(strata)
		. = strata_info.ores_sparse
	if(!.)
		. = SSmaterials.weighted_minerals_sparse

/turf/simulated/wall/natural/random/high_chance/get_weighted_mineral_list()
	if(strata)
		var/decl/strata/strata_info = decls_repository.get_decl(strata)
		. = strata_info.ores_rich
	if(!.)
		. = SSmaterials.weighted_minerals_rich

/turf/simulated/wall/natural/random/Initialize()
	if(isnull(reinf_material))
		var/default_mineral_list = get_weighted_mineral_list()
		if(LAZYLEN(default_mineral_list))
			reinf_material = pickweight(default_mineral_list)
	. = ..()

/turf/simulated/wall/natural/volcanic
	strata = /decl/strata/igneous

/turf/simulated/wall/natural/random/volcanic
	strata = /decl/strata/igneous

/turf/simulated/wall/natural/random/high_chance/volcanic
	strata = /decl/strata/igneous

/turf/simulated/wall/natural/ice
	strata = /decl/strata/permafrost

/turf/simulated/wall/natural/random/ice
	strata = /decl/strata/permafrost

/turf/simulated/wall/natural/random/high_chance/ice
	strata = /decl/strata/permafrost
