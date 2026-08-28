/decl/plant_gene/special
	unmasked_name = "special"
	associated_traits = list(
		TRAIT_TELEPORTING
	)
	uid = "plant_gene_special"

/decl/plant_gene/special/mutate(datum/seed/seed, atom/location)
	if(prob(65))
		seed.set_trait(TRAIT_TELEPORTING, !seed.get_trait(TRAIT_TELEPORTING))
