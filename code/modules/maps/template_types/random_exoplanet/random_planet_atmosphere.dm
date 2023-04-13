
/datum/map_template/planetoid/proc/generate_atmosphere(var/datum/planetoid_data/gen_data)
	var/target_temp     = get_target_temperature(gen_data)
	var/target_pressure = get_target_pressure(gen_data)
	var/list/gas_list   = get_mandatory_gasses(gen_data) //amount of moles for each gases
	var/total_moles     = MOLES_CELLSTANDARD
	LAZYINITLIST(gas_list)

	//Make sure temperature can't damage people on casual planets (Only when not forcing an atmosphere)
	if(!length(initial_atmosphere_gases) && gen_data.habitability_class <= HABITABILITY_OKAY)
		var/decl/species/S = get_species_by_key(global.using_map.default_species)
		target_temp = clamp(target_temp, S.cold_level_1 + rand(1,5), S.heat_level_1 - rand(1,5))

	//Initial atmosphere bypasses randomgen and hability enforced gen
	if(length(initial_atmosphere_gases))
		for(var/agas in initial_atmosphere_gases)
			gas_list[agas] = initial_atmosphere_gases[agas] * total_moles
	//Skip fun gas gen for perfect terran worlds
	else if(gen_data.habitability_class == HABITABILITY_IDEAL)
		gas_list |= list(/decl/material/gas/oxygen = O2STANDARD * total_moles, /decl/material/gas/nitrogen = N2STANDARD * total_moles)
	else
		var/badflag = 0
		for(var/g in gas_list)
			total_moles = max(0, total_moles - gas_list[g])
			var/decl/material/mat = GET_DECL(g)
			if(mat.gas_flags & XGM_GAS_OXIDIZER)
				badflag |= XGM_GAS_FUEL
			if(mat.gas_flags & XGM_GAS_FUEL)
				badflag |= XGM_GAS_OXIDIZER

		//Breathable planet
		if(gen_data.habitability_class == HABITABILITY_OKAY)
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
	var/target_moles = target_pressure * CELL_VOLUME / (target_temp * R_IDEAL_GAS_EQUATION)
	var/list/set_gasmix = list()
	for(var/g in gas_list)
		var/adjusted_moles = gas_list[g] * target_moles / MOLES_CELLSTANDARD
		set_gasmix[g] = adjusted_moles

	var/datum/gas_mixture/new_atmos = new
	new_atmos.temperature = target_temp
	new_atmos.gas = set_gasmix.Copy()
	new_atmos.update_values()
	gen_data.set_atmosphere(new_atmos)

//List of gases that will be always present. Amounts are given assuming total of MOLES_CELLSTANDARD in atmosphere
/datum/map_template/planetoid/proc/get_mandatory_gasses(var/datum/planetoid_data/gen_data)
	if(gen_data.habitability_class == HABITABILITY_OKAY)
		return list(/decl/material/gas/oxygen = MOLES_O2STANDARD)

/datum/map_template/planetoid/proc/get_target_temperature(var/datum/planetoid_data/gen_data)
	return rand(atmosphere_temperature_min, atmosphere_temperature_max)

/datum/map_template/planetoid/proc/get_target_pressure(var/datum/planetoid_data/gen_data)
	return rand(atmosphere_pressure_min, atmosphere_pressure_max)

/datum/map_template/planetoid/proc/generate_habitability(var/datum/planetoid_data/gen_data)
	if(prob(10))
		. = HABITABILITY_IDEAL
	else if(prob(30))
		. = HABITABILITY_OKAY
	else if(prob(40))
		. = HABITABILITY_BAD
	else
		. = HABITABILITY_DEAD
	gen_data.set_habitability(.)