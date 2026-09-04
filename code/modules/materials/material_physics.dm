//Clausius–Clapeyron relation
/decl/material/proc/get_boiling_temp(var/pressure = ONE_ATMOSPHERE)
	var/pressure_ratio = (pressure > 0)? log(pressure / ONE_ATMOSPHERE) : 0
	return (1 / (1/max(boiling_point, TCMB)) - ((R_IDEAL_GAS_EQUATION * pressure_ratio) / (latent_heat * molar_mass)))

/// Returns the phase of the matterial at the given temperature and pressure
/// Defaults to standard temperature and pressure (20c at one atmosphere)
/decl/material/proc/phase_at_temperature(var/temperature = T20C, var/pressure = ONE_ATMOSPHERE)
	//#TODO: implement plasma temperature and do pressure checks
	if(!isnull(boiling_point) && temperature >= get_boiling_temp(pressure))
		return MAT_PHASE_GAS
	else if(!isnull(heating_point) && temperature >= heating_point || \
			!isnull(melting_point) && temperature >= melting_point)
		return MAT_PHASE_LIQUID
	return MAT_PHASE_SOLID

// Returns the number of mols of material for the amount of solid or liquid units passed.
/decl/material/proc/get_mols_from_units(units, phase)
	var/ml = units*10 // Rough estimation.
	switch(phase)
		if(MAT_PHASE_LIQUID)
			var/kg = (liquid_density*ml)/1000
			return kg/molar_mass
		if(MAT_PHASE_SOLID)
			var/kg = (solid_density*ml)/1000
			return kg/molar_mass
		else
			log_warning("Invalid phase '[phase]' passed to get_mols_from_units!")
			return units

/decl/material/proc/neutron_interact(var/neutron_energy, var/total_interacted_units, var/total_units)
	. = list() // Returns associative list of interaction -> interacted units
	if(!length(neutron_interactions))
		return
	for(var/interaction in neutron_interactions)
		var/ideal_energy = neutron_interactions[interaction]
		var/interacted_units_ratio = (clamp(-((((neutron_energy-ideal_energy)**2)/(neutron_cross_section*1000)) - 100), 0, 100))/100
		var/interacted_units = round(interacted_units_ratio*total_interacted_units, 0.001)

		if(interacted_units > 0)
			.[interaction] = interacted_units
			total_interacted_units -= interacted_units
		if(total_interacted_units <= 0)
			return

/decl/material/proc/add_burn_product(var/datum/gas_mixture/environment, var/amount)
	if(!environment || amount <= 0 || !burn_product)
		return
	environment.adjust_gas(burn_product, amount)

// Returns null for no burn, empty list for burn with no products, assoc
// matter to value list for waste products.
// We assume a normalized mole amount for 'amount'.
/decl/material/proc/get_burn_products(var/amount, var/burn_temperature, var/ambient_pressure)

	// No chance of burning.
	if(isnull(ignition_point) && isnull(boiling_point) && !length(vapor_products))
		return

	// Burning a reagent of any kind.
	if(ignition_point && burn_temperature >= ignition_point)
		. = list() // We need to return a non-null value to indicate we consumed the material.
		if(burn_product)
			.[burn_product] = amount
		return

	// If it has a vapor product, turn it into that.
	if(length(vapor_products))
		. = list()
		for(var/vapor in vapor_products)
			.[vapor] = (amount * vapor_products[vapor])
		return

	// If it's not ignitable but can be boiled, consider vaporizing it.
	if(!isnull(boiling_point) && phase_at_temperature(burn_temperature, ambient_pressure) == MAT_PHASE_GAS)
		LAZYSET(., src, amount)
