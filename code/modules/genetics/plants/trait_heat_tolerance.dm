/// Departure from ideal that is survivable.
/decl/plant_trait/heat_tolerance
	name = "heat tolerance"
	shows_extended_data = TRUE
	default_value = 20

/decl/plant_trait/heat_tolerance/get_station_survivable_value()
	return 20

/decl/plant_trait/heat_tolerance/get_extended_data(val, datum/seed/grown_seed)
	if(val > 30)
		return "It is well adapted to a range of temperatures."
	if(val < 10)
		return "It is very sensitive to temperature shifts."
