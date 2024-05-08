/// The plant can become dehydrated.
/decl/plant_trait/requires_water
	name = "required water"
	shows_extended_data = TRUE
	default_value = 1

/decl/plant_trait/requires_water/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		if(val < 1)
			return "It requires very little water."
		if(val > 5)
			return "It requires a large amount of water."
		return "It requires a steady supply of water."
