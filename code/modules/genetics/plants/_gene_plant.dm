/decl/plant_gene
	abstract_type   = /decl/plant_gene
	//expected_source = /datum/seed
	//expected_target = /datum/seed
	/// Set to a randomized gene mask in Initialize().
	var/name
	/// Actual name of the gene, used mostly for VV.
	var/unmasked_name
	/// A list of trait values to copy wholesale in copy_initial_seed_values().
	var/list/associated_traits
	/// Tracker to make sure masked names are unique.
	var/static/list/_used_masks = list()

/decl/plant_gene/Initialize()
	. = ..()
	while(isnull(name) || (name in _used_masks))
		name = uppertext(num2hex(rand(0,255)))
	_used_masks |= name

/decl/plant_gene/validate()
	. = ..()
	if(!istext(name) || length(name) != 2)
		. += "null or invalid post-mask name: [name || "NULL"]"
	if(!istext(unmasked_name))
		. += "null or invalid unmasked name: [unmasked_name || "NULL"]"
	for(var/trait in associated_traits)
		if(!ispath(trait, /decl/plant_trait))
			. += "erroneous trait value in associated traits: [trait || "NULL"]"

// Splicing products has some detrimental effects on yield and lifespan.
// We handle this before we do the rest of the looping (in overrides), as normal traits don't really include lists.
/decl/plant_gene/proc/modify_seed(datum/plantgene/gene, datum/seed/seed)
	SHOULD_CALL_PARENT(TRUE)
	for(var/trait in gene.values)
		seed.set_trait(trait, gene.values[trait])

// Specific gene data is handled in overrides before calling parent.
/decl/plant_gene/proc/copy_initial_seed_values(datum/plantgene/gene, datum/seed/seed)
	SHOULD_CALL_PARENT(TRUE)
	if(length(associated_traits))
		for(var/trait in associated_traits)
			LAZYSET(gene.values, trait, seed.get_trait(trait))

/decl/plant_gene/proc/mutate(datum/seed/seed, turf/location)
	return

// Instance of a gene, used for copying data around. Functionally just a holder for a list.
// Could probably be replaced by `/decl/plant_gene/foo = list(some_trait = some_value)` down the track.
/datum/plantgene
	/// Reference back to our master
	var/decl/plant_gene/genetype
	/// Values to copy into the target seed datum.
	var/list/values

/datum/plantgene/New(decl/plant_gene/gene_archetype, datum/seed/donor)
	genetype = gene_archetype
	if(ispath(genetype))
		genetype = GET_DECL(genetype)
	if(!istype(genetype))
		CRASH("Non-gene decl data passed to plant gene instance: [gene_archetype || "NULL"].")
	if(!istype(donor))
		CRASH("Non-seed datum passed to plant gene instance: [donor || "NULL"].")
	genetype.copy_initial_seed_values(src, donor)
