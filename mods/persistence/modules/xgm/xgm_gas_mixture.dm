/datum/gas_mixture
	var/list/serialized_gas

/datum/gas_mixture/before_save()
	. = ..()
	serialized_gas = list()
	for(var/gas_mat in gas)
		serialized_gas["[gas_mat]"] = gas[gas_mat]

/datum/gas_mixture/after_save()
	. = ..()
	serialized_gas = null

/datum/gas_mixture/after_deserialize()
	. = ..()
	if(!serialized_gas)
		return
	gas = list()
	for(var/gas_path in serialized_gas)
		gas[text2path(gas_path)] = serialized_gas[gas_path]
	