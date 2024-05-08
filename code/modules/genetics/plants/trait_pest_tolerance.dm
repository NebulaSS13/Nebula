/// Threshold for pests to impact health.
/decl/plant_trait/pest_tolerance
	name = "pest tolerance"
	shows_extended_data = TRUE
	default_value = 5

/decl/plant_trait/pest_tolerance/get_extended_data(val, datum/seed/grown_seed)
	if(val < 3)
		return "It is highly sensitive to pests."
	if(val > 6)
		return "It is remarkably resistant to pests."