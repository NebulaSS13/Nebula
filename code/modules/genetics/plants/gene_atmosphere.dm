/decl/plant_gene/atmosphere
	unmasked_name = "atmosphere"
	associated_traits = list(
		TRAIT_HEAT_TOLERANCE,
		TRAIT_LOWKPA_TOLERANCE,
		TRAIT_HIGHKPA_TOLERANCE
	)

/decl/plant_gene/atmosphere/mutate(datum/seed/seed, turf/location)
	if(prob(60))
		seed.set_trait(TRAIT_HEAT_TOLERANCE, seed.get_trait(TRAIT_HEAT_TOLERANCE)+rand(-5,5),800,70)
	if(prob(60))
		seed.set_trait(TRAIT_LOWKPA_TOLERANCE, seed.get_trait(TRAIT_LOWKPA_TOLERANCE)+rand(-5,5),80,0)
	if(prob(60))
		seed.set_trait(TRAIT_HIGHKPA_TOLERANCE, seed.get_trait(TRAIT_HIGHKPA_TOLERANCE)+rand(-5,5),500,110)
