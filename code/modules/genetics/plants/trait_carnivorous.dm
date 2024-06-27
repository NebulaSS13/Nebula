/// 0 = none, 1 = eat pests in tray, 2 = eat living things  (when a vine).
/decl/plant_trait/carnivorous
	name = "carnivorous"
	shows_extended_data = TRUE
	base_worth = 5

/decl/plant_trait/carnivorous/get_extended_data(val, datum/seed/grown_seed)
	switch(val)
		if(1)
			return "It is carnivorous and will eat tray pests for sustenance."
		if(2)
			return "It is carnivorous and poses a significant threat to living things around it."
