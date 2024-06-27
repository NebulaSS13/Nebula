/// 0 limits plant to tray, 1 = creepers, 2 = vines.
/decl/plant_trait/spread
	name = "spread"
	shows_extended_data = TRUE

/decl/plant_trait/spread/get_extended_data(val, datum/seed/grown_seed)
	switch(val)
		if(1)
			return "It is able to be planted outside of a tray."
		if(2)
			return "It is a robust and vigorous vine that will spread rapidly."
