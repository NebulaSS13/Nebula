/datum/map
	var/datum/gas_mixture/immutable/exterior_atmosphere
	var/exterior_atmos_temp = T20C
	var/list/exterior_atmos_composition = list(
		/decl/material/gas/oxygen = O2STANDARD,
		/decl/material/gas/nitrogen = N2STANDARD
	)

/datum/map/proc/build_exterior_atmosphere()
	exterior_atmosphere = new(_initial_gas = exterior_atmos_composition)
	exterior_atmosphere.temperature = exterior_atmos_temp
	exterior_atmosphere.update_values()
	exterior_atmosphere.check_tile_graphic()
