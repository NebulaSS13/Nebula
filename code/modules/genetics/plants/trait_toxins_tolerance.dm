/// Resistance to poison.
/decl/plant_trait/toxins_tolerance
	name = "toxins tolerance"
	shows_extended_data = TRUE
	default_value = 5

/decl/plant_trait/toxins_tolerance/get_extended_data(val, datum/seed/grown_seed)
	if(val < 3)
		return "It is highly sensitive to toxins."
	if(val > 6)
		return "It is remarkably resistant to toxins."