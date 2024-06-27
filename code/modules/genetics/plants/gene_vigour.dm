/decl/plant_gene/vigour
	unmasked_name = "vigour"
	associated_traits = list(
		TRAIT_PRODUCTION,
		TRAIT_MATURATION,
		TRAIT_YIELD,
		TRAIT_SPREAD
	)

/decl/plant_gene/vigour/mutate(datum/seed/seed, turf/location)
	if(prob(65))
		seed.set_trait(TRAIT_PRODUCTION, seed.get_trait(TRAIT_PRODUCTION)+rand(-1,1),10,0)
	if(prob(65))
		seed.set_trait(TRAIT_MATURATION, seed.get_trait(TRAIT_MATURATION)+rand(-1,1),30,0)
	if(prob(55))
		seed.set_trait(TRAIT_SPREAD, seed.get_trait(TRAIT_SPREAD)+rand(-1,1),2,0)
		location.visible_message(SPAN_NOTICE("\The [seed.display_name] spasms visibly."))
