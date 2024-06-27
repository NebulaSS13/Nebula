/decl/plant_gene/hardiness
	unmasked_name = "hardiness"
	associated_traits = list(
		TRAIT_TOXINS_TOLERANCE,
		TRAIT_PEST_TOLERANCE,
		TRAIT_WEED_TOLERANCE,
		TRAIT_ENDURANCE
	)

/decl/plant_gene/hardiness/mutate(datum/seed/seed, turf/location)
	if(prob(60))
		seed.set_trait(TRAIT_TOXINS_TOLERANCE, seed.get_trait(TRAIT_TOXINS_TOLERANCE)+rand(-2,2),10,0)
	if(prob(60))
		seed.set_trait(TRAIT_PEST_TOLERANCE, seed.get_trait(TRAIT_PEST_TOLERANCE)+rand(-2,2),10,0)
	if(prob(60))
		seed.set_trait(TRAIT_WEED_TOLERANCE, seed.get_trait(TRAIT_WEED_TOLERANCE)+rand(-2,2),10,0)
	if(prob(60))
		seed.set_trait(TRAIT_ENDURANCE, seed.get_trait(TRAIT_ENDURANCE)+rand(-5,5),100,0)
