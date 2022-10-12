/datum/map
	/// A per-turf gasmix (associative, ex. list(/decl/material/gas/oxygen = O2STANDARD)) returned to exterior return_air.
	var/list/exterior_atmos_composition
	/// Temperature of standard exterior atmosphere.
	var/exterior_atmos_temp = T20C
	/// Gaxmis datum generated from exterior_atmos_composition.
	var/datum/gas_mixture/exterior_atmosphere

/datum/map/proc/build_exterior_atmosphere()
	exterior_atmosphere = new
	for(var/gas in exterior_atmos_composition)
		exterior_atmosphere.adjust_gas(gas, exterior_atmos_composition[gas], FALSE)
	exterior_atmosphere.temperature = exterior_atmos_temp
	exterior_atmosphere.update_values()
	exterior_atmosphere.check_tile_graphic()

/datum/map/proc/get_exterior_atmosphere()
	if(exterior_atmosphere)
		var/datum/gas_mixture/gas = new
		gas.copy_from(exterior_atmosphere)
		return gas
