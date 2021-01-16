/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	var/target_temp = get_target_temperature()

	//Make sure temperature can't damage people on casual planets
	if(habitability_class <= HABITABILITY_OKAY)
		var/decl/species/S = get_species_by_key(GLOB.using_map.default_species)
		target_temp = Clamp(target_temp, S.cold_level_1 + rand(1,5), S.heat_level_1 - rand(1,5))

	atmosphere.temperature = target_temp

	//Skip fun gas gen for perfect terran worlds
	if(habitability_class == HABITABILITY_IDEAL)
		atmosphere.adjust_gas(/decl/material/gas/oxygen, MOLES_O2STANDARD)
		atmosphere.adjust_gas(/decl/material/gas/nitrogen, MOLES_N2STANDARD)
		return
	
	var/total_moles = MOLES_CELLSTANDARD
	
	//Add the non-negotiable gasses
	var/badflag = 0
	var/gas_list = get_mandatory_gasses()
	for(var/g in gas_list)
		total_moles = max(0, total_moles - gas_list[g])
		var/decl/material/mat = decls_repository.get_decl(g)
		if(mat.gas_flags & XGM_GAS_OXIDIZER)
			badflag |= XGM_GAS_FUEL
		if(mat.gas_flags & XGM_GAS_FUEL)
			badflag |= XGM_GAS_OXIDIZER

	//Breathable planet
	if(habitability_class == HABITABILITY_OKAY)
		badflag |= XGM_GAS_CONTAMINANT

	var/list/newgases = subtypesof(/decl/material/gas)
	if(prob(50)) //alium gas should be slightly less common than mundane shit
		newgases -= /decl/material/gas/alien

	// Prune gases that won't stay gaseous
	for(var/g in newgases)
		var/decl/material/mat = decls_repository.get_decl(g)
		if(mat.gas_flags & badflag)
			newgases -= g
		if(mat.gas_condensation_point && mat.gas_condensation_point <= atmosphere.temperature)
			newgases -= g
		if(mat.boiling_point && mat.boiling_point >= atmosphere.temperature)
			newgases -= g

	var/gasnum = rand(1,4)
	var/i = 1
	while(i <= gasnum && total_moles && newgases.len)
		if(badflag)
			for(var/g in newgases)
				var/decl/material/mat = decls_repository.get_decl(g)
				if(mat.gas_flags & badflag)
					newgases -= g
		var/ng = pick_n_take(newgases)	//pick a gas

		// Make sure atmosphere is not flammable
		var/decl/material/mat = decls_repository.get_decl(ng)
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
	var/target_moles = target_pressure * CELL_VOLUME / (atmosphere.temperature * R_IDEAL_GAS_EQUATION)
	for(var/g in gas_list)
		var/adjusted_moles = gas_list[g] * target_moles / MOLES_CELLSTANDARD
		atmosphere.adjust_gas(g, adjusted_moles, 0)
	atmosphere.update_values()

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