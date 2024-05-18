/decl/plant_gene/environment
	unmasked_name = "environment"
	associated_traits = list(
		TRAIT_IDEAL_HEAT,
		TRAIT_IDEAL_LIGHT,
		TRAIT_LIGHT_TOLERANCE
	)

/decl/plant_gene/environment/mutate(datum/seed/seed, turf/location)
	if(prob(60))
		seed.set_trait(TRAIT_IDEAL_HEAT, seed.get_trait(TRAIT_IDEAL_HEAT)+rand(-2,2),10,0)
	if(prob(60))
		seed.set_trait(TRAIT_IDEAL_LIGHT, seed.get_trait(TRAIT_IDEAL_LIGHT)+rand(-2,2),10,0)
	if(prob(60))
		seed.set_trait(TRAIT_LIGHT_TOLERANCE, seed.get_trait(TRAIT_LIGHT_TOLERANCE)+rand(-5,5),100,0)
