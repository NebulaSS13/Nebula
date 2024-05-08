/// Can be used to make a battery.
/decl/plant_trait/produces_power
	name = "power production" // TODO look up the chemical reaction that causes this
	shows_extended_data = TRUE
	base_worth = 3

/decl/plant_trait/produces_power/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "The fruit will function as a battery if prepared appropriately."
