// These variables are used to speed up certain calculations by using dot products.
var/global/alist/cached_specific_heat = alist()
var/global/alist/cached_molar_mass = alist()
var/global/alist/cached_mat_r = alist()
var/global/alist/cached_mat_g = alist()
var/global/alist/cached_mat_b = alist()
var/global/alist/cached_mat_a = alist()
var/global/alist/cached_mat_color_weight = alist()

/datum/gas_mixture
	//Associative list of gas moles.
	//Gases with 0 moles are not tracked and are pruned by update_values()
	var/alist/gas = alist()
	//Temperature in Kelvin of this gas mix.
	var/temperature = 0

	//Sum of all the gas moles in this mix.  Updated by update_values()
	var/total_moles = 0
	//Volume of this mix.
	var/total_volume = CELL_VOLUME
	//Size of the group this gas_mixture is representing.  1 for singletons.
	var/group_multiplier = 1

	//List of active tile overlays for this gas_mixture.  Updated by check_tile_graphic()
	var/list/graphic
	//Cache of gas overlay objects
	var/list/tile_overlay_cache
	///The last cached color of the gas mixture
	var/tmp/cached_mix_color

/datum/gas_mixture/New(_volume, _temperature, _group_multiplier)
	if(!isnull(_volume))
		total_volume = _volume
	if(!isnull(_temperature))
		temperature = _temperature
	if(!isnull(_group_multiplier))
		group_multiplier = _group_multiplier

	//Since we may have values defined on creation, update everything.
	if(total_volume && length(gas))
		update_values()

/datum/gas_mixture/proc/get_gas(gasid)
	return gas[gasid] * group_multiplier

/datum/gas_mixture/proc/get_total_moles()
	return total_moles * group_multiplier

//Takes a gas string and the amount of moles to adjust by.  Calls update_values() if update isn't 0.
/datum/gas_mixture/proc/adjust_gas(gasid, moles, update = 1)
	if(moles == 0)
		return

	if (group_multiplier != 1)
		gas[gasid] += moles/group_multiplier
	else
		gas[gasid] += moles

	if(update)
		update_values()


//Same as adjust_gas(), but takes a temperature which is mixed in with the gas.
/datum/gas_mixture/proc/adjust_gas_temp(gasid, moles, temp, update = 1)
	if(moles == 0)
		return

	if(moles > 0 && abs(temperature - temp) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/decl/material/mat = GET_DECL(gasid)
		var/giver_heat_capacity = mat.gas_specific_heat * moles
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (temp * giver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity

	if (group_multiplier != 1)
		gas[gasid] += moles/group_multiplier
	else
		gas[gasid] += moles

	if(update)
		update_values()

/// Merges all the gas from another mixture into this one.  Respects group_multipliers and adjusts temperature correctly.
/// Does not modify giver in any way.
/datum/gas_mixture/proc/merge(const/datum/gas_mixture/giver)
	if(!giver)
		return FALSE

	if(abs(temperature-giver.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/giver_heat_capacity = giver.heat_capacity()
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (giver.temperature*giver_heat_capacity + temperature*self_heat_capacity)/combined_heat_capacity

	if((group_multiplier != 1)||(giver.group_multiplier != 1))
		var/scale_factor = giver.group_multiplier / group_multiplier
		for(var/gas_type, gas_amount in giver.gas)
			gas[gas_type] += gas_amount * scale_factor
	else
		for(var/gas_type, gas_amount in giver.gas)
			gas[gas_type] += gas_amount

	update_values()
	return TRUE

// Used to equalize the mixture between two zones before sleeping an edge.
/datum/gas_mixture/proc/equalize(datum/gas_mixture/sharer)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	// Special exception: there isn't enough air around to be worth processing this edge next tick, zap both to zero.
	if(total_moles + sharer.total_moles <= MINIMUM_AIR_TO_SUSPEND)
		gas.Cut()
		sharer.gas.Cut()

	var/scale_factor = total_volume + sharer.total_volume
	var/origin_scale_factor = total_volume / scale_factor
	var/sharer_scale_factor = sharer.total_volume / scale_factor
	for(var/gas_type in gas|sharer.gas) // we can only iterate keys here since merging alists doesn't combine values
		var/comb = gas[gas_type] + sharer.gas[gas_type]
		gas[gas_type] = comb * origin_scale_factor
		sharer.gas[gas_type] = comb * sharer_scale_factor

	if(our_heatcap + share_heatcap)
		temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
	sharer.temperature = temperature

	update_values()
	sharer.update_values()

	return 1


//Returns the heat capacity of the gas mix based on the specific heat of the gases.
/datum/gas_mixture/proc/heat_capacity()
	return values_dot(gas, global.cached_specific_heat) * max(1, group_multiplier)

//Adds or removes thermal energy. Returns the actual thermal energy change, as in the case of removing energy we can't go below TCMB.
/datum/gas_mixture/proc/add_thermal_energy(var/thermal_energy)

	if (total_moles == 0)
		return 0

	var/heat_capacity = heat_capacity()
	if(heat_capacity <= 0)
		return 0

	if (thermal_energy < 0)
		if (temperature < TCMB)
			return 0
		var/thermal_energy_limit = -(temperature - TCMB)*heat_capacity	//ensure temperature does not go below TCMB
		thermal_energy = max( thermal_energy, thermal_energy_limit )	//thermal_energy and thermal_energy_limit are negative here.
	temperature += thermal_energy/heat_capacity
	return thermal_energy

//Returns the thermal energy change required to get to a new temperature
/datum/gas_mixture/proc/get_thermal_energy_change(var/new_temperature)
	return heat_capacity()*(max(new_temperature, 0) - temperature)

//Technically vacuum doesn't have a specific entropy. Just use a really big number (infinity would be ideal) here so that it's easy to add gas to vacuum and hard to take gas out.
#define SPECIFIC_ENTROPY_VACUUM		150000


//Returns the ideal gas specific entropy of the whole mix. This is the entropy per mole of /mixed/ gas.
/datum/gas_mixture/proc/specific_entropy()
	if (!gas.len || total_moles == 0)
		return SPECIFIC_ENTROPY_VACUUM

	. = 0
	for(var/g in gas)
		. += gas[g] * specific_entropy_gas(g)
	. /= total_moles


/*
	It's arguable whether this should even be called entropy anymore. It's more "based on" entropy than actually entropy now.

	Returns the ideal gas specific entropy of a specific gas in the mix. This is the entropy due to that gas per mole of /that/ gas in the mixture, not the entropy due to that gas per mole of gas mixture.

	For the purposes of SS13, the specific entropy is just a number that tells you how hard it is to move gas. You can replace this with whatever you want.
	Just remember that returning a SMALL number == adding gas to this gas mix is HARD, taking gas away is EASY, and that returning a LARGE number means the opposite (so a vacuum should approach infinity).

	So returning a constant/(partial pressure) would probably do what most players expect. Although the version I have implemented below is a bit more nuanced than simply 1/P in that it scales in a way
	which is bit more realistic (natural log), and returns a fairly accurate entropy around room temperatures and pressures.
*/
/datum/gas_mixture/proc/specific_entropy_gas(var/gasid)
	if (!gas[gasid])
		return SPECIFIC_ENTROPY_VACUUM	//that gas isn't here

	//group_multiplier gets divided out in volume/gas[gasid] - also, V/(m*T) = R/(partial pressure)
	var/decl/material/mat = GET_DECL(gasid)
	var/molar_mass = mat.molar_mass
	var/specific_heat = mat.gas_specific_heat
	var/safe_temp = max(temperature, TCMB) // We're about to divide by this.
	return R_IDEAL_GAS_EQUATION * ( log( (IDEAL_GAS_ENTROPY_CONSTANT*total_volume/(gas[gasid] * safe_temp)) * (molar_mass*specific_heat*safe_temp)**(2/3) + 1 ) +  15 )

	//alternative, simpler equation
	//var/partial_pressure = gas[gasid] * R_IDEAL_GAS_EQUATION * temperature / volume
	//return R_IDEAL_GAS_EQUATION * ( log (1 + IDEAL_GAS_ENTROPY_CONSTANT/partial_pressure) + 20 )


//Updates the total_moles count and trims any empty gases.
/datum/gas_mixture/proc/update_values()
	values_cut_under(gas, ATMOS_PRECISION)
	total_moles = values_sum(gas)
	//Mark the cached color for update
	cached_mix_color = null

//Returns the pressure of the gas mix.  Only accurate if there have been no gas modifications since update_values() has been called.
/datum/gas_mixture/proc/return_pressure()
	if(total_volume)
		return total_moles * R_IDEAL_GAS_EQUATION * temperature / total_volume
	return 0


//Removes moles from the gas mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove(amount)
	amount = min(amount, total_moles * group_multiplier) //Can not take more air than the gas mixture has!
	if(amount <= 0)
		return null

	var/datum/gas_mixture/removed = new

	for(var/gas_type, gas_amount in gas)
		removed.gas[gas_type] = QUANTIZE((gas_amount / total_moles) * amount)
		gas[gas_type] -= removed.gas[gas_type] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed


//Removes a ratio of gas from the mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove_ratio(ratio, out_group_multiplier = 1)
	if(ratio <= 0)
		return null
	out_group_multiplier = clamp(out_group_multiplier, 1, group_multiplier)

	ratio = min(ratio, 1)

	var/datum/gas_mixture/removed = new
	removed.group_multiplier = out_group_multiplier

	for(var/gas_type, gas_amount in gas)
		removed.gas[gas_type] = (gas_amount * ratio * group_multiplier / out_group_multiplier)
		gas[gas_type] = gas_amount * (1 - ratio)

	removed.temperature = temperature
	removed.total_volume = total_volume * group_multiplier / out_group_multiplier
	update_values()
	removed.update_values()

	return removed

//Removes a volume of gas from the mixture and returns a gas_mixture containing the removed air with the given volume
/datum/gas_mixture/proc/remove_volume(removed_volume)
	var/datum/gas_mixture/removed = remove_ratio(removed_volume/(total_volume*group_multiplier), 1)
	removed.total_volume = removed_volume
	return removed

//Removes moles from the gas mixture, limited by a given flag.  Returns a gax_mixture containing the removed air.
/datum/gas_mixture/proc/remove_by_flag(flag, amount, mat_flag = FALSE)
	var/datum/gas_mixture/removed = new

	if(!flag || amount <= 0)
		return removed

	var/sum = 0
	for(var/gas_type, gas_amount in gas)
		var/decl/material/mat = GET_DECL(gas_type)
		var/check = mat_flag ? mat.flags : mat.gas_flags
		if(check & flag)
			sum += gas_amount

	for(var/gas_type, gas_amount in gas)
		var/decl/material/mat = GET_DECL(gas_type)
		var/check = mat_flag ? mat.flags : mat.gas_flags
		if(check & flag)
			removed.gas[gas_type] = QUANTIZE((gas_amount / sum) * amount)
			gas[gas_type] -= removed.gas[gas_type] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

//Returns the amount of gas that has the given flag, in moles
/datum/gas_mixture/proc/get_by_flag(flag)
	. = 0
	for(var/gas_type, gas_amount in gas)
		var/decl/material/mat = GET_DECL(gas_type)
		if(mat.gas_flags & flag)
			. += gas_amount

//Copies gas and temperature from another gas_mixture.
/datum/gas_mixture/proc/copy_from(const/datum/gas_mixture/sample)
	gas = sample.gas.Copy()
	temperature = sample.temperature
	update_values()
	check_tile_graphic()
	return 1

/datum/gas_mixture/GetCloneArgs()
	return list(total_volume, temperature, group_multiplier)

/datum/gas_mixture/PopulateClone(datum/gas_mixture/clone)
	clone.gas         = gas.Copy()
	clone.total_moles = total_moles
	update_values()
	return clone

//Checks if we are within acceptable range of another gas_mixture to suspend processing or merge.
/datum/gas_mixture/proc/compare(const/datum/gas_mixture/sample, var/vacuum_exception = 0)
	if(!sample) return 0

	if(vacuum_exception)
		// Special case - If one of the two is zero pressure, the other must also be zero.
		// This prevents suspending processing when an air-filled room is next to a vacuum,
		// an edge case which is particually obviously wrong to players
		if(total_moles == 0 && sample.total_moles != 0 || sample.total_moles == 0 && total_moles != 0)
			return 0

	var/alist/marked = alist()
	for(var/gas_type, gas_amount in gas)
		if((abs(gas_amount - sample.gas[gas_type]) > MINIMUM_AIR_TO_SUSPEND) && \
		((gas_amount < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[gas_type]) || \
		(gas_amount > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[gas_type])))
			return 0
		marked[gas_type] = 1

	if(abs(return_pressure() - sample.return_pressure()) > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
		return 0

	for(var/sample_type, sample_moles in sample.gas)
		if(!marked[sample_type])
			if((abs(gas[sample_type] - sample_moles) > MINIMUM_AIR_TO_SUSPEND) && \
			((gas[sample_type] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample_moles) || \
			(gas[sample_type] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample_moles)))
				return 0

	if(total_moles > MINIMUM_AIR_TO_SUSPEND)
		if((abs(temperature - sample.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
		((temperature < (1 - MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature) || \
		(temperature > (1 + MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature)))
			return 0

	return 1

//Rechecks the gas_mixture and adjusts the graphic list if needed.
//Two lists can be passed by reference if you need know specifically which graphics were added and removed.
// Returns TRUE if the graphics list was mutated.
/datum/gas_mixture/proc/check_tile_graphic(list/graphic_add = null, list/graphic_remove = null)
	if(LAZYLEN(graphic))
		for(var/obj/effect/gas_overlay/O in graphic)
			if(gas[O.material.type] <= O.material.gas_overlay_limit)
				LAZYADD(graphic_remove, O)
	for(var/gas_type, gas_amount in gas)
		var/decl/material/mat = GET_DECL(gas_type)
		//Overlay isn't applied for this gas, check if it's valid and needs to be added.
		if(!isnull(mat.gas_overlay_limit) && gas_amount > mat.gas_overlay_limit)
			if(!LAZYACCESS(tile_overlay_cache, gas_type))
				LAZYSET(tile_overlay_cache, gas_type, new /obj/effect/gas_overlay(null, gas_type))
			var/tile_overlay = tile_overlay_cache[gas_type]
			if(!(tile_overlay in graphic))
				LAZYADD(graphic_add, tile_overlay)
	. = FALSE
	//Apply changes
	if(LAZYLEN(graphic_add))
		LAZYADD(graphic, graphic_add)
		. = TRUE
	if(LAZYLEN(graphic_remove))
		LAZYREMOVE(graphic, graphic_remove)
		. = TRUE
	if(LAZYLEN(graphic))
		var/pressure_mod = clamp(return_pressure() / ONE_ATMOSPHERE, 0, 2)
		for(var/obj/effect/gas_overlay/O in graphic)
			var/concentration_mod = clamp(gas[O.material.type] / total_moles, 0.1, 1)
			var/new_alpha = min(230, round(pressure_mod * concentration_mod * 180, 5))
			if(new_alpha != O.alpha)
				O.update_alpha_animation(new_alpha)

//Multiply all gas amounts by a factor.
/datum/gas_mixture/proc/multiply(factor)
	for(var/g in gas)
		gas[g] *= factor

	update_values()
	return 1


//Divide all gas amounts by a factor.
/datum/gas_mixture/proc/divide(factor)
	for(var/g in gas)
		gas[g] /= factor

	update_values()
	return 1


//Shares gas with another gas_mixture based on the amount of connecting tiles and a fixed lookup table.
/datum/gas_mixture/proc/share_ratio(datum/gas_mixture/other, connecting_tiles, share_size = null, one_way = 0)
	var/static/list/sharing_lookup_table = list(0.30, 0.40, 0.48, 0.54, 0.60, 0.66)
	//Shares a specific ratio of gas between mixtures using simple weighted averages.
	var/ratio = sharing_lookup_table[6]

	var/size = max(1, group_multiplier)
	if(isnull(share_size)) share_size = max(1, other.group_multiplier)

	var/full_heat_capacity = heat_capacity()
	var/s_full_heat_capacity = other.heat_capacity()

	var/alist/avg_gas = alist()
	var/scale_factor = (size + share_size)
	var/self_scale_factor = size / scale_factor
	var/other_scale_factor = share_size / scale_factor

	for(var/gas_type, gas_moles in gas)
		avg_gas[gas_type] += gas_moles * self_scale_factor

	for(var/gas_type, gas_moles in other.gas)
		avg_gas[gas_type] += gas_moles * other_scale_factor

	var/temp_avg = 0
	if(full_heat_capacity + s_full_heat_capacity)
		temp_avg = (temperature * full_heat_capacity + other.temperature * s_full_heat_capacity) / (full_heat_capacity + s_full_heat_capacity)

	//WOOT WOOT DO NOT TOUCH THIS.
	if(sharing_lookup_table.len >= connecting_tiles) //6 or more interconnecting tiles will max at 42% of air moved per tick.
		ratio = sharing_lookup_table[connecting_tiles]
	//WOOT WOOT DO NOT TOUCH THIS.

	for(var/gas_type, gas_amount in avg_gas)
		gas[gas_type] = max(0, (gas[gas_type] - gas_amount) * (1 - ratio) + gas_amount)
		if(!one_way)
			other.gas[gas_type] = max(0, (other.gas[gas_type] - gas_amount) * (1 - ratio) + gas_amount)

	temperature = max(0, (temperature - temp_avg) * (1-ratio) + temp_avg)
	if(!one_way)
		other.temperature = max(0, (other.temperature - temp_avg) * (1-ratio) + temp_avg)

	update_values()
	other.update_values()

	return compare(other)


//A wrapper around share_ratio for spacing gas at the same rate as if it were going into a large airless room.
/datum/gas_mixture/proc/share_space(datum/gas_mixture/unsim_air)
	return share_ratio(unsim_air, unsim_air.group_multiplier, max(1, max(group_multiplier + 3, 1) + unsim_air.group_multiplier), one_way = 1)

//Equalizes a list of gas mixtures.  Used for pipe networks.
/proc/equalize_gases(list/datum/gas_mixture/gases)
	//Calculate totals from individual components
	var/total_volume = 0
	var/total_thermal_energy = 0
	var/total_heat_capacity = 0

	var/alist/total_gas = alist()
	for(var/datum/gas_mixture/gasmix in gases)
		total_volume += gasmix.total_volume
		var/temp_heatcap = gasmix.heat_capacity()
		total_thermal_energy += gasmix.temperature * temp_heatcap
		total_heat_capacity += temp_heatcap
		for(var/gas_type, gas_amount in gasmix.gas)
			total_gas[gas_type] += gas_amount

	if(total_volume > 0)
		var/datum/gas_mixture/combined = new(total_volume)
		combined.gas = total_gas

		//Calculate temperature
		if(total_heat_capacity > 0)
			combined.temperature = total_thermal_energy / total_heat_capacity
		combined.update_values()

		//Allow for reactions
		combined.react()

		//Average out the gases
		combined.divide(total_volume)

		//Update individual gas_mixtures
		for(var/datum/gas_mixture/gasmix in gases)
			gasmix.gas = combined.gas.Copy()
			gasmix.temperature = combined.temperature
			gasmix.multiply(gasmix.total_volume)

	return 1

/datum/gas_mixture/proc/get_mass()
	return values_dot(gas, global.cached_molar_mass) * group_multiplier

/datum/gas_mixture/proc/specific_mass()
	var/M = get_total_moles()
	if(M)
		return get_mass()/M
	return 0

///Returns a color blended from all materials the gas mixture contains
/datum/gas_mixture/proc/get_overall_color()
	if(!cached_mix_color)
		if(!length(gas))
			cached_mix_color = "#ffffffff"
			return cached_mix_color

		if(length(gas) == 1)
			for(var/gas_type in gas)
				var/decl/material/G = GET_DECL(gas_type)
				cached_mix_color = G.color + num2hex(G.opacity * 255)
			return cached_mix_color

		//If we really have to, add up all colors
		cached_mix_color = rgb(255,255,255,255)
		for(var/mat_path, mat_moles in gas)
			var/decl/material/G = GET_DECL(mat_path)
			if(G.color_weight <= 0)
				continue
			var/hex = uppertext(G.color) + num2hex(G.opacity * 255)
			cached_mix_color = BlendHSV(cached_mix_color, hex, (mat_moles * G.color_weight) / total_moles)

	return cached_mix_color
