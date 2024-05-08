/decl/plant_gene/diet
	unmasked_name = "diet"
	associated_traits = list(
		TRAIT_CARNIVOROUS,
		TRAIT_PARASITE,
		TRAIT_NUTRIENT_CONSUMPTION,
		TRAIT_WATER_CONSUMPTION
	)

/decl/plant_gene/diet/mutate(datum/seed/seed, turf/location)
	if(prob(60))
		seed.set_trait(TRAIT_CARNIVOROUS, seed.get_trait(TRAIT_CARNIVOROUS)+rand(-1,1),2,0)
	if(prob(60))
		seed.set_trait(TRAIT_PARASITE, !seed.get_trait(TRAIT_PARASITE))
	if(prob(65))
		seed.set_trait(TRAIT_NUTRIENT_CONSUMPTION, seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION)+rand(-0.1,0.1),5,0)
	if(prob(65))
		seed.set_trait(TRAIT_WATER_CONSUMPTION, seed.get_trait(TRAIT_WATER_CONSUMPTION)+rand(-1,1),50,0)

/decl/plant_gene/diet/modify_seed(datum/plantgene/gene, datum/seed/seed)
	var/list/new_gasses = LAZYACCESS(gene.values, TRAIT_CONSUME_GASSES)
	if(islist(new_gasses) && length(new_gasses))
		LAZYDISTINCTADD(seed.consume_gasses, new_gasses)
	gene.values -= TRAIT_CONSUME_GASSES
	return ..()

/decl/plant_gene/diet/copy_initial_seed_values(datum/plantgene/gene, datum/seed/seed)
	LAZYSET(gene.values, TRAIT_CONSUME_GASSES, seed.consume_gasses?.Copy())
	return ..()
