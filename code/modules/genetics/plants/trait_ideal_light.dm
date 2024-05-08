/// Preferred light level in luminosity.
/decl/plant_trait/ideal_light
	name = "ideal light"
	shows_extended_data = TRUE
	default_value = 5

/decl/plant_trait/ideal_light/get_station_survivable_value()
	return 4

/decl/plant_trait/ideal_light/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "It thrives in a light level of [val] lumen\s."
