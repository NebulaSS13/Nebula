/// Low pressure capacity.
/decl/plant_trait/lowkpa_tolerance
	name = "low pressure tolerance"
	shows_extended_data = TRUE
	default_value = 25

/decl/plant_trait/lowkpa_tolerance/get_station_survivable_value()
	return 25

/decl/plant_trait/lowkpa_tolerance/get_extended_data(val, datum/seed/grown_seed)
	if(val < 20)
		return "It is well adapted to low pressure levels."
