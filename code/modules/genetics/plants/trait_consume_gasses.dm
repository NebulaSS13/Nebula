/decl/plant_trait/consume_gasses
	name = "gas consumption"
	shows_extended_data = TRUE
	requires_master_gene = FALSE

/decl/plant_trait/consume_gasses/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "It will remove gas from the environment."
