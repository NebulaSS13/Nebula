/*

Making Bombs with ZAS:
Get gas to react in an air tank so that it gains pressure. If it gains enough pressure, it goes boom.
The more pressure, the more boom.
If it gains pressure too slowly, it may leak or just rupture instead of exploding.
*/

//Returns the firelevel
/datum/gas_mixture/proc/react(zone/zone, force_burn, no_check = 0)
	. = 0
	if((temperature > FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE || force_burn) && (no_check ||check_recombustibility()))

		#ifdef FIREDBG
		log_debug("***************** FIREDBG *****************")
		log_debug("Burning [zone? zone.name : "zoneless gas_mixture"]!")
		#endif

		var/total_fuel = 0
		var/total_oxidizers = 0

		//*** Get the fuel and oxidizer amounts
		for(var/g in gas)
			var/decl/material/mat = GET_DECL(g)
			if(mat.gas_flags & XGM_GAS_FUEL)
				total_fuel += gas[g]
			if(mat.gas_flags & XGM_GAS_OXIDIZER)
				total_oxidizers += gas[g]
		total_fuel *= group_multiplier
		total_oxidizers *= group_multiplier

		if(total_fuel <= 0.005)
			return 0

		//*** Determine how fast the fire burns

		//get the current thermal energy of the gas mix
		//this must be taken here to prevent the addition or deletion of energy by a changing heat capacity
		var/starting_energy = temperature * heat_capacity()

		//determine how far the reaction can progress
		var/reaction_limit = min(total_oxidizers*(FIRE_REACTION_FUEL_AMOUNT/FIRE_REACTION_OXIDIZER_AMOUNT), total_fuel) //stoichiometric limit

		//vapour fuels are extremely volatile! The reaction progress is a percentage of the total fuel (similar to old zburn).)
		var/firelevel = calculate_firelevel(total_fuel, total_oxidizers, reaction_limit, volume*group_multiplier) / vsc.fire_firelevel_multiplier
		var/min_burn = 0.30*volume*group_multiplier/CELL_VOLUME //in moles - so that fires with very small gas concentrations burn out fast
		var/total_reaction_progress = min(max(min_burn, firelevel*total_fuel)*FIRE_GAS_BURNRATE_MULT, total_fuel)
		var/used_fuel = min(total_reaction_progress, reaction_limit)
		var/used_oxidizers = used_fuel*(FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT)

		#ifdef FIREDBG
		log_debug("total_fuel = [total_fuel], total_oxidizers = [total_oxidizers]")
		log_debug("fuel_area = [fuel_area], total_fuel = [total_fuel], reaction_limit = [reaction_limit]")
		log_debug("firelevel -> [firelevel]")
		log_debug("total_reaction_progress = [total_reaction_progress]")
		log_debug("used_fuel = [used_fuel], used_oxidizers = [used_oxidizers]; ")
		#endif

		//if the reaction is progressing too slow then it isn't self-sustaining anymore and burns out
		if(zone && (!total_fuel || used_fuel <= FIRE_GAS_MIN_BURNRATE*zone.contents.len))
			return 0

		//*** Remove fuel and oxidizer, add carbon dioxide and heat
		//remove and add gasses as calculated
		used_fuel = min(used_fuel, total_fuel)
		//remove_by_flag() and adjust_gas() handle the group_multiplier for us.
		remove_by_flag(XGM_GAS_OXIDIZER, used_oxidizers)
		var/datum/gas_mixture/burned_fuel = remove_by_flag(XGM_GAS_FUEL, used_fuel)
		for(var/g in burned_fuel.gas)
			var/decl/material/mat = GET_DECL(g)
			if(mat.burn_product)
				adjust_gas(mat.burn_product, burned_fuel.gas[g])

		//calculate the energy produced by the reaction and then set the new temperature of the mix
		temperature = (starting_energy + vsc.fire_fuel_energy_release * used_fuel) / heat_capacity()
		update_values()

		#ifdef FIREDBG
		log_debug("used_fuel = [used_fuel]; total = [used_fuel]")
		log_debug("new temperature = [temperature]; new pressure = [return_pressure()]")
		#endif

		return firelevel

/datum/gas_mixture/proc/check_recombustibility()
	. = 0
	for(var/g in gas)
		if(gas[g] >= 0.1)
			var/decl/material/gas = GET_DECL(g)
			if(gas.gas_flags & XGM_GAS_OXIDIZER)
				. = 1
				break

	if(!.)
		return 0

	. = 0
	for(var/g in gas)
		if(gas[g] >= 0.1)
			var/decl/material/gas = GET_DECL(g)
			if(gas.gas_flags & XGM_GAS_OXIDIZER)
				. = 1
				break

/datum/gas_mixture/proc/check_combustibility()
	. = 0
	for(var/g in gas)
		if(QUANTIZE(gas[g] * vsc.fire_consuption_rate) >= 0.1)
			var/decl/material/gas = GET_DECL(g)
			if(gas.gas_flags & XGM_GAS_OXIDIZER)
				. = 1
				break

	if(!.)
		return 0

	. = 0
	for(var/g in gas)
		if(QUANTIZE(gas[g] * vsc.fire_consuption_rate) >= 0.1)
			var/decl/material/gas = GET_DECL(g)
			if(gas.gas_flags & XGM_GAS_FUEL)
				. = 1
				break

//returns a value between 0 and vsc.fire_firelevel_multiplier
/datum/gas_mixture/proc/calculate_firelevel(total_fuel, total_oxidizers, reaction_limit, gas_volume)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	var/total_combustibles = (total_fuel + total_oxidizers)
	var/active_combustibles = (FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT + 1)*reaction_limit

	if(total_combustibles > 0 && total_moles > 0 && group_multiplier > 0)
		//slows down the burning when the concentration of the reactants is low
		var/damping_multiplier = min(1, active_combustibles / (total_moles/group_multiplier))

		//weight the damping mult so that it only really brings down the firelevel when the ratio is closer to 0
		damping_multiplier = 2*damping_multiplier - (damping_multiplier*damping_multiplier)

		//calculates how close the mixture of the reactants is to the optimum
		//fires burn better when there is more oxidizer -- too much fuel will choke the fire out a bit, reducing firelevel.
		var/mix_multiplier = 1 / (1 + (5 * ((total_fuel / total_combustibles) ** 2)))

		#ifdef FIREDBG
		ASSERT(damping_multiplier <= 1)
		ASSERT(mix_multiplier <= 1)
		#endif

		//toss everything together -- should produce a value between 0 and fire_firelevel_multiplier
		firelevel = vsc.fire_firelevel_multiplier * mix_multiplier * damping_multiplier

	return max( 0, firelevel)
