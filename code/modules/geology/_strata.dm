/decl/strata
	var/name
	var/list/base_materials
	var/list/ores_sparse
	var/list/ores_rich
	var/default_strata_candidate = FALSE
	var/maximum_temperature = INFINITY

/decl/strata/proc/is_valid_exoplanet_strata(var/datum/planetoid_data/planet)
	if(istype(planet.atmosphere))
		return planet.atmosphere.temperature <= maximum_temperature
	return TCMB <= maximum_temperature

/decl/strata/proc/is_valid_level_stratum(datum/level_data/level_data)
	var/temperature_to_check = istype(level_data.exterior_atmosphere) ? level_data.exterior_atmosphere.temperature : level_data.exterior_atmos_temp
	return (temperature_to_check || TCMB) <= maximum_temperature

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

	for(var/mat_type in (base_materials|ores_sparse|ores_rich))
		var/decl/material/mat = GET_DECL(mat_type)
		maximum_temperature = min((mat.melting_point-1), maximum_temperature)
