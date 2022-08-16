// Boilerplate from parent type with self gas modification removed.
/datum/gas_mixture/immutable/equalize(datum/gas_mixture/sharer)
	// Special exception: there isn't enough air around to be worth processing this edge next tick, zap both to zero.
	if(total_moles + sharer.total_moles <= MINIMUM_AIR_TO_SUSPEND)
		sharer.clear_gas_list()
	for(var/g in gas|GET_GAS_LIST(sharer))
		var/comb = gas[g] + GET_GAS(sharer, g)
		comb /= volume + sharer.volume
		sharer.adjust_gas(g, (comb * sharer.volume) - GET_GAS(sharer, g), FALSE)
	sharer.temperature = temperature
	sharer.update_values()
	return 1

/datum/gas_mixture/immutable/remove(amount)
	amount = min(amount, total_moles * group_multiplier) //Can not take more air than the gas mixture has!
	if(amount <= 0)
		return null
	var/datum/gas_mixture/removed = new
	for(var/g in gas)
		removed.adjust_gas(g, QUANTIZE((gas[g] / total_moles) * amount), FALSE)
	removed.temperature = temperature
	removed.update_values()
	return removed

/datum/gas_mixture/immutable/remove_ratio(ratio, out_group_multiplier = 1)
	if(ratio <= 0)
		return null
	out_group_multiplier = between(1, out_group_multiplier, group_multiplier)
	ratio = min(ratio, 1)
	var/datum/gas_mixture/removed = new
	removed.group_multiplier = out_group_multiplier
	for(var/g in gas)
		removed.adjust_gas(g, gas[g] * ratio * group_multiplier / out_group_multiplier, FALSE)
	removed.temperature = temperature
	removed.volume = volume * group_multiplier / out_group_multiplier
	removed.update_values()
	return removed

/datum/gas_mixture/immutable/remove_by_flag(flag, amount, mat_flag = FALSE)
	var/datum/gas_mixture/removed = new
	if(!flag || amount <= 0)
		return removed
	var/sum = 0
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		var/list/check = mat_flag ? mat.flags : mat.gas_flags
		if(check & flag)
			sum += gas[g]
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		var/list/check = mat_flag ? mat.flags : mat.gas_flags
		if(check & flag)
			removed.adjust_gas(g, QUANTIZE((gas[g] / sum) * amount), FALSE)
	removed.temperature = temperature
	removed.update_values()
	return removed

/datum/gas_mixture/immutable/share_ratio(datum/gas_mixture/other, connecting_tiles, share_size = null, one_way = 0)
	PRINT_STACK_TRACE("Immutable gas mixture attempted to share_ratio, immutable mixes should not be involved in ZAS!")

// Simple overrides.
/datum/gas_mixture/immutable/copy_from(const/datum/gas_mixture/sample)
	return FALSE
/datum/gas_mixture/immutable/compare(const/datum/gas_mixture/sample, var/vacuum_exception = 0)
	return FALSE
/datum/gas_mixture/immutable/add(datum/gas_mixture/right_side)
	return FALSE
/datum/gas_mixture/immutable/subtract(datum/gas_mixture/right_side)
	return FALSE
/datum/gas_mixture/immutable/multiply(factor)
	return FALSE
/datum/gas_mixture/immutable/divide(factor)
	return FALSE
/datum/gas_mixture/immutable/add_thermal_energy(var/thermal_energy)
	return 0
/datum/gas_mixture/immutable/clear_gas_list(var/update_values = TRUE)
	return
/datum/gas_mixture/immutable/adjust_gas(gasid, moles, update = 1)
	return
/datum/gas_mixture/immutable/adjust_gas_temp(gasid, moles, temp, update = 1)
	return
/datum/gas_mixture/immutable/adjust_multi()
	return
/datum/gas_mixture/immutable/adjust_multi_temp()
	return
/datum/gas_mixture/immutable/merge(const/datum/gas_mixture/giver)
	return
