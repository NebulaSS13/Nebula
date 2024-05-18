/// If set, plant will never mutate. If -1, plant is highly mutable.
/decl/plant_trait/immutable
	name = "genetic immutability"
	shows_extended_data = TRUE
	requires_master_gene = FALSE

/decl/plant_trait/immutable/get_extended_data(val, datum/seed/grown_seed)
	if(val == -1)
		return "This plant is highly mutable."
	if(val > 0)
		return "This plant does not possess genetics that are alterable."
