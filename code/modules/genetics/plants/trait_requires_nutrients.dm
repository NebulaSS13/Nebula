/// The plant can starve.
/decl/plant_trait/requires_nutrients
	name = "required nutrients"
	shows_extended_data = TRUE
	default_value = 1

/decl/plant_trait/requires_nutrients/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		if(val < 0.05)
			return "It consumes a small amount of nutrient fluid."
		if(val > 0.2)
			return "It requires a heavy supply of nutrient fluid."
		return "It requires a supply of nutrient fluid."
