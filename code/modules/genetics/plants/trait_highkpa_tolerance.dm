/// High pressure capacity.
/decl/plant_trait/highkpa_tolerance
	name = "high pressure tolerance"
	shows_extended_data = TRUE
	default_value = 200

/decl/plant_trait/highkpa_tolerance/get_station_survivable_value()
	return 200

/decl/plant_trait/highkpa_tolerance/get_extended_data(val, datum/seed/grown_seed)
	if(val > 220)
		return "It is well adapted to high pressure levels."
