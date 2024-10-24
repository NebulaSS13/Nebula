/decl/plant_gene/biochemistry
	unmasked_name = "biochemistry"
	associated_traits = list(
		TRAIT_POTENCY
	)
	var/list/modify_traits = list(
		TRAIT_YIELD,
		TRAIT_ENDURANCE
	)

/decl/plant_gene/biochemistry/mutate(datum/seed/seed)
	seed.set_trait(TRAIT_POTENCY, seed.get_trait(TRAIT_POTENCY)+rand(-20,20),200, 0)

/decl/plant_gene/biochemistry/modify_seed(datum/plantgene/gene, datum/seed/seed)

	for(var/trait in modify_traits)
		if(seed.get_trait(trait) > 0)
			seed.set_trait(trait, seed.get_trait(trait), null, 1, 0.85)

	seed.produces_pollen = LAZYACCESS(gene.values, TRAIT_POLLEN)

	LAZYINITLIST(seed.chems)
	var/list/gene_value = LAZYACCESS(gene.values, TRAIT_CHEMS)
	for(var/rid in gene_value)

		var/list/gene_chem = gene_value[rid]
		if(!seed.chems[rid])
			seed.chems[rid] = gene_chem.Copy()
			continue

		for(var/i = 1 to length(gene_chem))
			if(isnull(gene_chem[i]))
				gene_chem[i] = 0
			if(seed.chems[rid][i])
				seed.chems[rid][i] = max(1, round((gene_chem[i] + seed.chems[rid][i])/2))
			else
				seed.chems[rid][i] = gene_chem[i]

	var/list/new_gasses = LAZYACCESS(gene.values, TRAIT_EXUDE_GASSES)
	if(islist(new_gasses) && length(new_gasses))
		LAZYDISTINCTADD(seed.exude_gasses, new_gasses)
		for(var/gas in seed.exude_gasses)
			seed.exude_gasses[gas] = max(1, round(seed.exude_gasses[gas] * 0.8))

	LAZYREMOVE(gene.values, TRAIT_EXUDE_GASSES)
	LAZYREMOVE(gene.values, TRAIT_CHEMS)
	LAZYREMOVE(gene.values, TRAIT_POLLEN)

	return ..()

/decl/plant_gene/biochemistry/copy_initial_seed_values(datum/plantgene/gene, datum/seed/seed)
	LAZYSET(gene.values, TRAIT_CHEMS, seed.chems?.Copy())
	LAZYSET(gene.values, TRAIT_EXUDE_GASSES, seed.exude_gasses?.Copy())
	LAZYSET(gene.values, TRAIT_POLLEN, seed.produces_pollen)
	return ..()
