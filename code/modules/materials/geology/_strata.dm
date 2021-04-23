/decl/strata
	var/name
	var/list/base_materials
	var/list/ores_sparse
	var/list/ores_rich
	var/default_strata_candidate = FALSE
	var/maximum_temperature = INFINITY

/decl/strata/proc/is_valid_exoplanet_strata(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	var/check_temp = planet?.atmosphere?.temperature || 0
	. = check_temp <= maximum_temperature

/decl/strata/Initialize()
	. = ..()

	for(var/mat_type in ores_sparse)
		if(isnull(ores_sparse[mat_type]))
			var/decl/material/mat = GET_DECL(mat_type)
			ores_sparse[mat_type] = mat.sparse_material_weight

	for(var/mat_type in ores_rich)
		if(isnull(ores_rich[mat_type]))
			var/decl/material/mat = GET_DECL(mat_type)
			ores_rich[mat_type] = mat.rich_material_weight

	if(isnull(ores_sparse) && islist(ores_rich))
		ores_sparse = ores_rich.Copy()
	else if(isnull(ores_rich) && islist(ores_sparse))
		ores_rich = ores_sparse.Copy()

	for(var/mat_type in (ores_sparse|ores_rich))
		var/decl/material/mat = GET_DECL(mat_type)
		maximum_temperature = min((mat.melting_point-1), maximum_temperature)
