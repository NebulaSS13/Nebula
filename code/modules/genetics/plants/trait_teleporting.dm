/// Uses the teleport tomato effect.
/decl/plant_trait/teleporting
	name = "teleporting"
	shows_extended_data = TRUE
	base_worth = 5

/decl/plant_trait/teleporting/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "The fruit is temporal/spatially unstable."
