/// Can cause damage/inject reagents when thrown or handled.
/decl/plant_trait/stings
	name = "stinging"
	shows_extended_data = TRUE
	base_worth = -2

/decl/plant_trait/stings/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "The fruit is covered in stinging spines."
