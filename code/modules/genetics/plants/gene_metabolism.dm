/decl/plant_gene/metabolism
	unmasked_name = "metabolism"
	associated_traits = list(
		TRAIT_REQUIRES_NUTRIENTS,
		TRAIT_REQUIRES_WATER,
		TRAIT_ALTER_TEMP
	)

/decl/plant_gene/metabolism/mutate(datum/seed/seed, turf/location)
	if(prob(65))
		seed.set_trait(TRAIT_REQUIRES_NUTRIENTS, seed.get_trait(TRAIT_REQUIRES_NUTRIENTS)+rand(-2,2),10,0)
	if(prob(65))
		seed.set_trait(TRAIT_REQUIRES_WATER, seed.get_trait(TRAIT_REQUIRES_WATER)+rand(-2,2),10,0)
	if(prob(40))
		seed.set_trait(TRAIT_ALTER_TEMP, seed.get_trait(TRAIT_ALTER_TEMP)+rand(-5,5),100,0)

/decl/plant_gene/metabolism/modify_seed(datum/plantgene/gene, datum/seed/seed)
	seed.product_type  = LAZYACCESS(gene.values, TRAIT_PRODUCT_TYPE)
	seed.slice_product = LAZYACCESS(gene.values, TRAIT_SLICE_PRODUCT)
	seed.slice_amount  = LAZYACCESS(gene.values, TRAIT_SLICE_AMOUNT)
	LAZYREMOVE(gene.values, TRAIT_PRODUCT_TYPE)
	return ..()

/decl/plant_gene/metabolism/copy_initial_seed_values(datum/plantgene/gene, datum/seed/seed)
	LAZYSET(gene.values, TRAIT_PRODUCT_TYPE,  seed.product_type)
	LAZYSET(gene.values, TRAIT_SLICE_PRODUCT, seed.slice_product)
	LAZYSET(gene.values, TRAIT_SLICE_AMOUNT,  seed.slice_amount)
	return ..()
