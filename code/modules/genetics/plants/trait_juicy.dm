/// When thrown, causes a splatter decal.
/decl/plant_trait/juicy
	name = "juiciness"
	shows_extended_data = TRUE

/decl/plant_trait/juicy/get_extended_data(val, datum/seed/grown_seed)
	switch(val)
		if(1)
			return "The fruit is soft-skinned and juicy."
		if(2)
			return "The fruit is excessively juicy."
