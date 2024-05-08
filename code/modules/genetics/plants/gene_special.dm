/decl/plant_gene/special
	unmasked_name = "special"
	associated_traits = list(
		TRAIT_TELEPORTING
	)

/decl/plant_gene/special/mutate(datum/seed/seed, turf/location)
	if(prob(65))
		seed.set_trait(TRAIT_TELEPORTING, !seed.get_trait(TRAIT_TELEPORTING))
