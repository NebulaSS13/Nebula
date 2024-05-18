/// When thrown, acts as a grenade.
/decl/plant_trait/explosive
	name = "explosiveness"
	shows_extended_data = TRUE
	base_worth = -2

/decl/plant_trait/explosive/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "The fruit is internally unstable."
