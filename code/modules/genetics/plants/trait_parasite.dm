 /// 0 = no, 1 = gain health from weed level.
/decl/plant_trait/parasite
	name = "parasitism"
	shows_extended_data = TRUE
	base_worth = 5

/decl/plant_trait/parasite/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "It is capable of parisitising and gaining sustenance from tray weeds."