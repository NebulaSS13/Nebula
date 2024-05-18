/decl/plant_gene/fruit
	unmasked_name = "fruit"
	associated_traits = list(
		TRAIT_STINGS,
		TRAIT_EXPLOSIVE,
		TRAIT_FLESH_COLOUR,
		TRAIT_JUICY
	)

/decl/plant_gene/fruit/mutate(datum/seed/seed, turf/location)
	if(prob(65))
		seed.set_trait(TRAIT_STINGS, !seed.get_trait(TRAIT_STINGS))
	if(prob(65))
		seed.set_trait(TRAIT_EXPLOSIVE, !seed.get_trait(TRAIT_EXPLOSIVE))
	if(prob(65))
		seed.set_trait(TRAIT_JUICY, !seed.get_trait(TRAIT_JUICY))
