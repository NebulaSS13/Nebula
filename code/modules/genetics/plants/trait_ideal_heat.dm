/// Preferred temperature in Kelvin.
/decl/plant_trait/ideal_heat
	name = "ideal heat"
	shows_extended_data = TRUE
	default_value = 293

/decl/plant_trait/ideal_heat/get_station_survivable_value()
	return 293

/decl/plant_trait/ideal_heat/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "It thrives in a temperature of [val] Kelvin."
