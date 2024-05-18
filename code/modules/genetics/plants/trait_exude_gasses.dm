/decl/plant_trait/exude_gasses
	name = "gas exuding"
	shows_extended_data = TRUE
	requires_master_gene = FALSE

/decl/plant_trait/exude_gasses/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "It will release gas into the environment."


