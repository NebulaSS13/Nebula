/// Threshold for weeds to impact health.
/decl/plant_trait/weed_tolerance
	name = "weed tolerance"
	shows_extended_data = TRUE
	default_value = 5

/decl/plant_trait/weed_tolerance/get_extended_data(val, datum/seed/grown_seed)
	if(val < 3)
		return "It is highly sensitive to weeds."
	if(val > 6)
		return "It is remarkably resistant to weeds."