/// If 1, this plant will fruit repeatedly.
/decl/plant_trait/harvest_repeat
	name = "repeat harvestability"
	shows_extended_data = TRUE
	base_worth = 3

/decl/plant_trait/harvest_repeat/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "This plant can be harvested repeatedly."
