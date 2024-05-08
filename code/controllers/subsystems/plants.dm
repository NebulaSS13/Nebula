PROCESSING_SUBSYSTEM_DEF(plants)
	name       = "Plants"
	priority   = SS_PRIORITY_PLANTS
	runlevels  = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	flags      = SS_BACKGROUND|SS_POST_FIRE_TIMING
	init_order = SS_INIT_PLANTS
	wait       = 60

	/// Stores generated fruit descs.
	var/list/product_descs         = list()
	/// All seed data stored here.
	var/list/seeds                 = list()
	/// Stores images of growth, fruits and seeds.
	var/list/plant_icon_cache      = list()
	/// List of all harvested product sprites.
	var/list/plant_sprites         = list()
	/// List of all growth sprites plus number of growth stages.
	var/list/plant_product_sprites = list()
	/// Precalculated gene decl/mask list for use in botany machine UI.
	var/list/gene_masked_list      = list()

/datum/controller/subsystem/processing/plants/Initialize()
	// Build the icon lists.
	for(var/icostate in icon_states('icons/obj/hydroponics/hydroponics_growing.dmi'))
		var/split = findtext(icostate,"-")
		if(!split)
			// invalid icon_state
			continue

		var/ikey = copytext(icostate,(split+1))
		if(ikey == "dead")
			// don't count dead icons
			continue
		ikey = text2num(ikey)
		var/base = copytext(icostate,1,split)

		if(!(plant_sprites[base]) || (plant_sprites[base]<ikey))
			plant_sprites[base] = ikey

	for(var/icostate in icon_states('icons/obj/hydroponics/hydroponics_products.dmi'))
		var/split = findtext(icostate,"-")
		if(split)
			plant_product_sprites |= copytext(icostate,1,split)

	// Pre-init all our gene master datums. This generates mask strings and prepares us for trait copying/mutation.
	// We'll also populate our masked gene list here for the botany machine UI.
	for(var/decl/plant_gene/gene in decls_repository.get_decls_of_type_unassociated(/decl/plant_gene))
		gene_masked_list.Add(list(list("tag" = "\ref[gene]", "mask" = gene.name)))

	// Populate the global seed datum list.
	for(var/type in subtypesof(/datum/seed))
		var/datum/seed/S = new type
		S.update_growth_stages()
		seeds[S.name] = S
		S.roundstart = 1

	. = ..()

// Proc for creating a random seed type.
/datum/controller/subsystem/processing/plants/proc/create_random_seed(var/survive_on_station)
	var/datum/seed/seed = new()
	seed.randomize()
	seed.name = "[seed.uid]"
	seed.base_seed_value = rand(10, 15)
	seeds[seed.name] = seed
	if(survive_on_station)
		seed.consume_gasses = null
		for(var/decl/plant_trait/plant_trait in decls_repository.get_decls_of_type_unassociated(/decl/plant_trait))
			var/val = plant_trait.get_station_survivable_value()
			if(!isnull(val))
				seed.set_trait(plant_trait.type, val)
	return seed
