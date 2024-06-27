/// If set, the plant will periodically alter local temp by this amount.
/decl/plant_trait/alter_temp
	name = "temperature alteration"
	shows_extended_data = TRUE

/decl/plant_trait/alter_temp/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "It will periodically alter the local temperature by [val] degrees Kelvin."
