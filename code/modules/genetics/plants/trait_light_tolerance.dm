/// Departure from ideal that is survivable.
/decl/plant_trait/light_tolerance
	name = "light tolerance"
	shows_extended_data = TRUE
	default_value = 3

/decl/plant_trait/light_tolerance/get_station_survivable_value()
	return 5

/decl/plant_trait/light_tolerance/get_extended_data(val, datum/seed/grown_seed)
	if(val > 10)
		return "It is well adapted to a range of light levels."
	if(val < 3)
		return "It is very sensitive to light level shifts."
