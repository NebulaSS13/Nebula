/turf/exterior/wall/random
	reinf_material = null

/turf/exterior/wall/random/proc/get_weighted_mineral_list()
	if(strata_override)
		var/decl/strata/strata_info = GET_DECL(strata_override)
		. = strata_info.ores_sparse
	if(!.)
		. = SSmaterials.weighted_minerals_sparse

/turf/exterior/wall/random/high_chance/get_weighted_mineral_list()
	if(strata_override)
		var/decl/strata/strata_info = GET_DECL(strata_override)
		. = strata_info.ores_rich
	if(!.)
		. = SSmaterials.weighted_minerals_rich

/turf/exterior/wall/random/Initialize(ml, materialtype, rmaterialtype)
	if(!strata_override)
		strata_override = SSmaterials.get_strata_type(src)
	if(isnull(reinf_material))
		var/default_mineral_list = get_weighted_mineral_list()
		if(LAZYLEN(default_mineral_list))
			reinf_material = pickweight(default_mineral_list)
	. = ..()

/turf/exterior/wall/volcanic
	strata_override = /decl/strata/igneous

/turf/exterior/wall/random/volcanic
	strata_override = /decl/strata/igneous

/turf/exterior/wall/random/high_chance/volcanic
	strata_override = /decl/strata/igneous

/turf/exterior/wall/ice
	strata_override = /decl/strata/permafrost
	floor_type = /turf/exterior/ice

/turf/exterior/wall/random/ice
	strata_override = /decl/strata/permafrost
	floor_type = /turf/exterior/ice

/turf/exterior/wall/random/high_chance/ice
	strata_override = /decl/strata/permafrost
	floor_type = /turf/exterior/ice
