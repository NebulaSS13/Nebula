/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()


	var/target_temp = get_target_temperature()

	//Make sure temperature can't damage people on casual planets
	if(habitability_class <= HABITABILITY_OKAY)
		var/decl/species/S = get_species_by_key(global.using_map.default_species)
		target_temp = clamp(target_temp, S.cold_level_1 + rand(1,5), S.heat_level_1 - rand(1,5))

	//Skip fun gas gen for perfect terran worlds
	if(habitability_class == HABITABILITY_IDEAL)
		for(var/obj/abstract/level_data/level_data in zlevels)
			level_data.exterior_atmos_temp = target_temp
			level_data.exterior_atmosphere = list(
				/decl/material/gas/oxygen = MOLES_O2STANDARD,
				/decl/material/gas/nitrogen = MOLES_N2STANDARD
			)
			level_data.setup_level_data()
		return

	var/total_moles = MOLES_CELLSTANDARD

	//Add the non-negotiable gasses
	var/badflag = 0
	var/gas_list = get_mandatory_gasses()
	for(var/g in gas_list)
		total_moles = max(0, total_moles - gas_list[g])
		var/decl/material/mat = GET_DECL(g)
		if(mat.gas_flags & XGM_GAS_OXIDIZER)
			badflag |= XGM_GAS_FUEL
		if(mat.gas_flags & XGM_GAS_FUEL)
			badflag |= XGM_GAS_OXIDIZER

	//Breathable planet
	if(habitability_class == HABITABILITY_OKAY)
		badflag |= XGM_GAS_CONTAMINANT

	var/list/newgases = list()
	var/list/all_materials = decls_repository.get_decls_of_subtype(/decl/material)
	for(var/mat_type in all_materials)
		var/decl/material/mat = all_materials[mat_type]
		if(mat.exoplanet_rarity == MAT_RARITY_NOWHERE)
			continue
		if(isnull(mat.boiling_point) || mat.boiling_point > target_temp)
			continue
		if(!isnull(mat.gas_condensation_point) && mat.gas_condensation_point <= target_temp)
			continue
		newgases[mat.type] = mat.exoplanet_rarity

	if(prob(50)) //alium gas should be slightly less common than mundane shit
		newgases -= /decl/material/gas/alien

	// Prune gases that won't stay gaseous
	for(var/g in newgases)
		var/decl/material/mat = GET_DECL(g)
		if(mat.gas_flags & badflag)
			newgases -= g

	if(length(newgases))
		var/gasnum = rand(1,4)
		var/i = 1
		while(i <= gasnum && total_moles && newgases.len)
			if(badflag)
				for(var/g in newgases)
					var/decl/material/mat = GET_DECL(g)
					if(mat.gas_flags & badflag)
						newgases -= g
			var/ng = pickweight(newgases)	//pick a gas
			newgases -= ng

			// Make sure atmosphere is not flammable
			var/decl/material/mat = GET_DECL(ng)
			if(mat.gas_flags & XGM_GAS_OXIDIZER)
				badflag |= XGM_GAS_FUEL
			if(mat.gas_flags & XGM_GAS_FUEL)
				badflag |= XGM_GAS_OXIDIZER

			var/part = total_moles * rand(20,80)/100 //allocate percentage to it
			if(i == gasnum || !newgases.len) //if it's last gas, let it have all remaining moles
				part = total_moles
			gas_list[ng] += part
			total_moles = max(total_moles - part, 0)
			i++

	// Add all gasses, adjusted for target temperature and pressure
	var/target_pressure = get_target_pressure()
	var/target_moles = target_pressure * CELL_VOLUME / (target_temp * R_IDEAL_GAS_EQUATION)
	var/list/set_gasmix = list()
	for(var/g in gas_list)
		var/adjusted_moles = gas_list[g] * target_moles / MOLES_CELLSTANDARD
		set_gasmix[g] = adjusted_moles
	for(var/obj/abstract/level_data/level_data in zlevels)
		level_data.exterior_atmos_temp = target_temp
		level_data.exterior_atmosphere = set_gasmix.Copy()
		level_data.setup_level_data()

//List of gases that will be always present. Amounts are given assuming total of MOLES_CELLSTANDARD in atmosphere
/obj/effect/overmap/visitable/sector/exoplanet/proc/get_mandatory_gasses()
	if(habitability_class == HABITABILITY_OKAY)
		return list(/decl/material/gas/oxygen = MOLES_O2STANDARD)
	return list()

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_target_temperature()
	return T20C + rand(-5,5)

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_target_pressure()
	return ONE_ATMOSPHERE * rand(8, 12)/10

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_habitability()
	var/roll = rand(1,100)
	switch(roll)
		if(1 to 10)
			habitability_class = HABITABILITY_IDEAL
		if(11 to 50)
			habitability_class = HABITABILITY_OKAY
		else
			habitability_class = HABITABILITY_BAD