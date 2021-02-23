turf/exterior/wall/random
	reinf_material = null

/turf/exterior/wall/random/proc/get_weighted_mineral_list()
	if(strata)
		var/decl/strata/strata_info = GET_DECL(strata)
		. = strata_info.ores_sparse
	if(!.)
		. = SSmaterials.weighted_minerals_sparse

/turf/exterior/wall/random/high_chance/get_weighted_mineral_list()
	if(strata)
		var/decl/strata/strata_info = GET_DECL(strata)
		. = strata_info.ores_rich
	if(!.)
		. = SSmaterials.weighted_minerals_rich

/turf/exterior/wall/random/Initialize()
	if(isnull(reinf_material))
		var/default_mineral_list = get_weighted_mineral_list()
		if(LAZYLEN(default_mineral_list))
			reinf_material = pickweight(default_mineral_list)
	. = ..()

/turf/exterior/wall/volcanic
	strata = /decl/strata/igneous

/turf/exterior/wall/random/volcanic
	strata = /decl/strata/igneous

/turf/exterior/wall/random/high_chance/volcanic
	strata = /decl/strata/igneous

/turf/exterior/wall/ice
	strata = /decl/strata/permafrost

/turf/exterior/wall/random/ice
	strata = /decl/strata/permafrost

/turf/exterior/wall/random/high_chance/ice
	strata = /decl/strata/permafrost
