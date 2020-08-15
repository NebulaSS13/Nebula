/datum/map
	var/datum/gas_mixture/exterior_atmosphere = new
	var/exterior_atmos_temp = T20C
	var/list/exterior_atmos_composition = list(
		/decl/material/gas/oxygen = O2STANDARD,
		/decl/material/gas/nitrogen = N2STANDARD
	)

/datum/map/New()
	..()
	var/update_atmos = FALSE
	for(var/gas in exterior_atmos_composition)
		update_atmos = TRUE
		exterior_atmosphere.adjust_gas(gas, exterior_atmos_composition[gas], FALSE)
	if(update_atmos)
		exterior_atmosphere.update_values()
	exterior_atmosphere.temperature = exterior_atmos_temp

/datum/map/proc/get_exterior_atmosphere()
	var/datum/gas_mixture/gas = new
	gas.copy_from(exterior_atmosphere)
	return gas